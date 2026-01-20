package com.tradingjournal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Subscription Plan Response DTO
 * Returns available subscription plans with pricing
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubscriptionPlanResponse {
    private String planId;
    private String planName;
    private String planType; // FREE, PRO_MONTHLY, PRO_YEARLY
    private BigDecimal price;
    private String currency;
    private String period; // MONTHLY, YEARLY
    private String description;
    private String[] features;
    private boolean isPopular;
    private BigDecimal savings; // For yearly plan
}
