package com.tradingjournal.controller;

import com.tradingjournal.dto.AuthResponse;
import com.tradingjournal.dto.LoginRequest;
import com.tradingjournal.dto.RegisterRequest;
import com.tradingjournal.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS})
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        // Let GlobalExceptionHandler handle exceptions - returns proper JSON
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        // Let GlobalExceptionHandler handle exceptions - returns proper JSON
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}
