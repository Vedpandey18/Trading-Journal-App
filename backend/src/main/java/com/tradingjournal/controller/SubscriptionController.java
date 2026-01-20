package com.tradingjournal.controller;

import com.tradingjournal.dto.SubscriptionPlanResponse;
import com.tradingjournal.dto.SubscriptionStatusResponse;
import com.tradingjournal.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/**
 * Subscription Controller
 * Handles subscription plans, status, and management
 */
@RestController
@RequestMapping("/api/subscription")
@CrossOrigin(origins = "*")
public class SubscriptionController {

    @Autowired
    private SubscriptionService subscriptionService;

    /**
     * Get available subscription plans
     */
    @GetMapping("/plans")
    public ResponseEntity<List<SubscriptionPlanResponse>> getPlans() {
        List<SubscriptionPlanResponse> plans = Arrays.asList(
            new SubscriptionPlanResponse(
                "free",
                "Free Plan",
                "FREE",
                BigDecimal.ZERO,
                "INR",
                null,
                "Perfect for beginners. Track up to 10 trades per month.",
                new String[]{
                    "Up to 10 trades/month",
                    "Basic analytics",
                    "Trade history",
                    "Email support"
                },
                false,
                null
            ),
            new SubscriptionPlanResponse(
                "pro_monthly",
                "Pro Monthly",
                "PRO_MONTHLY",
                new BigDecimal("299"),
                "INR",
                "MONTHLY",
                "Unlimited trades and advanced analytics for serious traders.",
                new String[]{
                    "Unlimited trades",
                    "Advanced analytics",
                    "AI insights",
                    "Export data",
                    "Priority support",
                    "No ads"
                },
                false,
                null
            ),
            new SubscriptionPlanResponse(
                "pro_yearly",
                "Pro Yearly",
                "PRO_YEARLY",
                new BigDecimal("2999"),
                "INR",
                "YEARLY",
                "Best value! Save 16% with annual subscription.",
                new String[]{
                    "Unlimited trades",
                    "Advanced analytics",
                    "AI insights",
                    "Export data",
                    "Priority support",
                    "No ads",
                    "Save ₹597/year"
                },
                true,
                new BigDecimal("597") // Savings: (299*12) - 2999 = 597
            )
        );
        return ResponseEntity.ok(plans);
    }

    /**
     * Get current user subscription status
     */
    @GetMapping("/status")
    public ResponseEntity<SubscriptionStatusResponse> getStatus(Authentication authentication) {
        String username = authentication.getName();
        SubscriptionStatusResponse status = subscriptionService.getSubscriptionStatus(username);
        return ResponseEntity.ok(status);
    }

    /**
     * Cancel subscription (for future use)
     */
    @PostMapping("/cancel")
    public ResponseEntity<?> cancelSubscription(Authentication authentication) {
        String username = authentication.getName();
        subscriptionService.cancelSubscription(username);
        return ResponseEntity.ok("Subscription cancelled successfully");
    }
}
