package com.tradingjournal.controller;

import com.tradingjournal.dto.AnalyticsResponse;
import com.tradingjournal.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/analytics")
@CrossOrigin(origins = "*")
public class AnalyticsController {

    @Autowired
    private AnalyticsService analyticsService;

    @GetMapping
    public ResponseEntity<AnalyticsResponse> getAnalytics(Authentication authentication) {
        String username = authentication.getName();
        AnalyticsResponse analytics = analyticsService.getAnalytics(username);
        return ResponseEntity.ok(analytics);
    }
}
