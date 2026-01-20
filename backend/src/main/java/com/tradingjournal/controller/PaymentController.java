package com.tradingjournal.controller;

import com.razorpay.RazorpayException;
import com.tradingjournal.dto.PaymentRequest;
import com.tradingjournal.dto.PaymentVerificationRequest;
import com.tradingjournal.service.SubscriptionService;
import jakarta.validation.Valid;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payment")
@CrossOrigin(origins = "*")
public class PaymentController {

    @Autowired
    private SubscriptionService subscriptionService;

    @PostMapping("/create-order")
    public ResponseEntity<?> createOrder(
            @Valid @RequestBody PaymentRequest request,
            Authentication authentication) {
        try {
            String username = authentication.getName();
            JSONObject order = subscriptionService.createOrder(username, request);
            return ResponseEntity.ok(order.toString());
        } catch (RazorpayException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Failed to create order: " + e.getMessage());
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyPayment(
            @Valid @RequestBody PaymentVerificationRequest request,
            Authentication authentication) {
        try {
            String username = authentication.getName();
            subscriptionService.verifyPayment(username, request);
            return ResponseEntity.ok("Payment verified successfully. Subscription activated!");
        } catch (RazorpayException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Payment verification failed: " + e.getMessage());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
}
