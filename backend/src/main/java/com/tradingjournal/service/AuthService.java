package com.tradingjournal.service;

import com.tradingjournal.dto.AuthResponse;
import com.tradingjournal.dto.LoginRequest;
import com.tradingjournal.dto.RegisterRequest;
import com.tradingjournal.entity.Subscription;
import com.tradingjournal.entity.User;
import com.tradingjournal.exception.ResourceNotFoundException;
import com.tradingjournal.repository.SubscriptionRepository;
import com.tradingjournal.repository.UserRepository;
import com.tradingjournal.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user = userRepository.save(user);

        // Create free subscription for new user
        Subscription subscription = new Subscription();
        subscription.setUser(user);
        subscription.setPlanType(Subscription.PlanType.FREE);
        subscription.setIsActive(true);
        subscriptionRepository.save(subscription);

        String token = jwtUtil.generateToken(user.getUsername());

        AuthResponse response = new AuthResponse();
        response.setToken(token);
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setPlanType("FREE");

        return response;
    }

    public AuthResponse login(LoginRequest request) {
        // Authenticate user credentials
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsernameOrEmail(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByUsernameOrEmail(
                request.getUsernameOrEmail(),
                request.getUsernameOrEmail()
        ).orElseThrow(() -> new ResourceNotFoundException("User not found"));

        String token = jwtUtil.generateToken(user.getUsername());

        Subscription subscription = subscriptionRepository.findByUserId(user.getId())
                .orElse(new Subscription());

        AuthResponse response = new AuthResponse();
        response.setToken(token);
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setPlanType(subscription.getPlanType() != null ? 
                subscription.getPlanType().name() : "FREE");

        return response;
    }
}
