package com.tradingjournal.controller;

import com.tradingjournal.entity.Subscription;
import com.tradingjournal.entity.User;
import com.tradingjournal.repository.SubscriptionRepository;
import com.tradingjournal.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/create-admin")
    public ResponseEntity<Map<String, String>> createAdmin() {
        Map<String, String> response = new HashMap<>();
        
        String adminUsername = "VedPandey18";
        String adminEmail = "Ved201283@gmail.com";
        String adminPassword = "Qwertyx201#";

        // Check if admin already exists
        if (userRepository.existsByUsername(adminUsername) || 
            userRepository.existsByEmail(adminEmail)) {
            response.put("status", "exists");
            response.put("message", "Admin user already exists!");
            return ResponseEntity.ok(response);
        }

        try {
            // Create admin user
            User adminUser = new User();
            adminUser.setUsername(adminUsername);
            adminUser.setEmail(adminEmail);
            adminUser.setPassword(passwordEncoder.encode(adminPassword));
            adminUser = userRepository.save(adminUser);

            // Create FREE subscription for admin
            Subscription subscription = new Subscription();
            subscription.setUser(adminUser);
            subscription.setPlanType(Subscription.PlanType.FREE);
            subscription.setIsActive(true);
            subscriptionRepository.save(subscription);

            response.put("status", "success");
            response.put("message", "Admin user created successfully!");
            response.put("username", adminUsername);
            response.put("email", adminEmail);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Failed to create admin user: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/check-admin")
    public ResponseEntity<Map<String, Object>> checkAdmin() {
        Map<String, Object> response = new HashMap<>();
        
        String adminUsername = "VedPandey18";
        boolean exists = userRepository.existsByUsername(adminUsername);
        
        response.put("exists", exists);
        response.put("username", adminUsername);
        
        if (exists) {
            User admin = userRepository.findByUsername(adminUsername).orElse(null);
            if (admin != null) {
                response.put("email", admin.getEmail());
                response.put("userId", admin.getId());
            }
        }
        
        return ResponseEntity.ok(response);
    }
}
