package com.tradingjournal.config;

import com.tradingjournal.entity.Subscription;
import com.tradingjournal.entity.User;
import com.tradingjournal.repository.SubscriptionRepository;
import com.tradingjournal.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Create admin user if not exists
        String adminUsername = "VedPandey18";
        String adminEmail = "Ved201283@gmail.com";
        String adminPassword = "Qwertyx201#";

        if (!userRepository.existsByUsername(adminUsername) && 
            !userRepository.existsByEmail(adminEmail)) {
            
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

            System.out.println("========================================");
            System.out.println("Admin user created successfully!");
            System.out.println("Username: " + adminUsername);
            System.out.println("Email: " + adminEmail);
            System.out.println("========================================");
        } else {
            System.out.println("========================================");
            System.out.println("Admin user already exists!");
            System.out.println("Username: " + adminUsername);
            System.out.println("========================================");
        }
    }
}
