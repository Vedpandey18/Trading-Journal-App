package com.tradingjournal.service;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.tradingjournal.dto.PaymentRequest;
import com.tradingjournal.dto.PaymentVerificationRequest;
import com.tradingjournal.dto.SubscriptionStatusResponse;
import com.tradingjournal.entity.Subscription;
import com.tradingjournal.entity.User;
import com.tradingjournal.exception.ResourceNotFoundException;
import com.tradingjournal.repository.SubscriptionRepository;
import com.tradingjournal.repository.UserRepository;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class SubscriptionService {

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private UserRepository userRepository;

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    public boolean isProUser(Long userId) {
        Optional<Subscription> subscriptionOpt = subscriptionRepository.findByUserId(userId);
        if (subscriptionOpt.isEmpty()) {
            return false;
        }

        Subscription subscription = subscriptionOpt.get();
        return (subscription.getPlanType() == Subscription.PlanType.PRO_MONTHLY ||
                subscription.getPlanType() == Subscription.PlanType.PRO_YEARLY) &&
               Boolean.TRUE.equals(subscription.getIsActive()) &&
               (subscription.getEndDate() == null || subscription.getEndDate().isAfter(LocalDateTime.now()));
    }

    public SubscriptionStatusResponse getSubscriptionStatus(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Optional<Subscription> subscriptionOpt = subscriptionRepository.findByUserId(user.getId());
        if (subscriptionOpt.isEmpty()) {
            return new SubscriptionStatusResponse(
                "FREE",
                true,
                LocalDateTime.now(),
                null,
                null,
                false,
                0,
                "ACTIVE"
            );
        }

        Subscription subscription = subscriptionOpt.get();
        LocalDateTime now = LocalDateTime.now();
        boolean isActive = Boolean.TRUE.equals(subscription.getIsActive()) &&
                          (subscription.getEndDate() == null || subscription.getEndDate().isAfter(now));

        int remainingDays = 0;
        if (subscription.getEndDate() != null && subscription.getEndDate().isAfter(now)) {
            remainingDays = (int) java.time.Duration.between(now, subscription.getEndDate()).toDays();
        }

        String status = isActive ? "ACTIVE" : "EXPIRED";
        if (subscription.getPlanType() == Subscription.PlanType.FREE) {
            status = "ACTIVE";
        }

        return new SubscriptionStatusResponse(
            subscription.getPlanType() != null ? subscription.getPlanType().name() : "FREE",
            isActive,
            subscription.getStartDate(),
            subscription.getEndDate(),
            subscription.getEndDate(),
            subscription.getPlanType() != Subscription.PlanType.FREE && isActive,
            remainingDays,
            status
        );
    }

    public void cancelSubscription(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Optional<Subscription> subscriptionOpt = subscriptionRepository.findByUserId(user.getId());
        if (subscriptionOpt.isPresent()) {
            Subscription subscription = subscriptionOpt.get();
            // Don't cancel immediately - let it expire naturally
            // This follows Play Store guidelines for subscription cancellation
            subscription.setIsActive(false);
            subscriptionRepository.save(subscription);
        }
    }

    public JSONObject createOrder(String username, PaymentRequest request) throws RazorpayException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        RazorpayClient razorpay = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

        JSONObject orderRequest = new JSONObject();
        orderRequest.put("amount", request.getAmount() * 100); // Amount in paise
        orderRequest.put("currency", request.getCurrency());
        orderRequest.put("receipt", "receipt_" + user.getId());

        Order order = razorpay.orders.create(orderRequest);

        // Save order ID to subscription with plan type
        Subscription subscription = subscriptionRepository.findByUserId(user.getId())
                .orElse(new Subscription());
        subscription.setUser(user);
        subscription.setRazorpayOrderId(order.get("id").toString());
        
        // Store plan type temporarily (will be confirmed on payment verification)
        if ("PRO_MONTHLY".equals(request.getPlanType())) {
            subscription.setPlanType(Subscription.PlanType.PRO_MONTHLY);
            subscription.setSubscriptionPeriod(Subscription.SubscriptionPeriod.MONTHLY);
        } else if ("PRO_YEARLY".equals(request.getPlanType())) {
            subscription.setPlanType(Subscription.PlanType.PRO_YEARLY);
            subscription.setSubscriptionPeriod(Subscription.SubscriptionPeriod.YEARLY);
        }
        
        subscriptionRepository.save(subscription);

        return order.toJson();
    }

    @Transactional
    public void verifyPayment(String username, PaymentVerificationRequest request) throws RazorpayException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // Verify payment signature
        JSONObject attributes = new JSONObject();
        attributes.put("razorpay_order_id", request.getRazorpayOrderId());
        attributes.put("razorpay_payment_id", request.getRazorpayPaymentId());
        attributes.put("razorpay_signature", request.getRazorpaySignature());

        boolean isValidSignature = false;
        try {
            com.razorpay.Utils.verifyPaymentSignature(attributes, razorpayKeySecret);
            isValidSignature = true;
        } catch (Exception e) {
            throw new RuntimeException("Payment verification failed: Invalid signature");
        }

        if (isValidSignature) {
            // Get subscription with plan type already set from order creation
            Subscription subscription = subscriptionRepository.findByUserId(user.getId())
                    .orElseThrow(() -> new RuntimeException("Subscription order not found"));
            
            subscription.setRazorpayPaymentId(request.getRazorpayPaymentId());
            subscription.setRazorpaySignature(request.getRazorpaySignature());
            subscription.setStartDate(LocalDateTime.now());
            
            // Set end date based on subscription period
            if (subscription.getSubscriptionPeriod() == Subscription.SubscriptionPeriod.YEARLY) {
                subscription.setEndDate(LocalDateTime.now().plusYears(1));
            } else {
                subscription.setEndDate(LocalDateTime.now().plusMonths(1));
            }
            
            subscription.setIsActive(true);
            subscriptionRepository.save(subscription);
        }
    }
}
