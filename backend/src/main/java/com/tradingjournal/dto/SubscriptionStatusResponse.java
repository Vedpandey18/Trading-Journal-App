package com.tradingjournal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Subscription Status Response DTO
 * Returns current user subscription status
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubscriptionStatusResponse {
    private String planType; // FREE, PRO_MONTHLY, PRO_YEARLY
    private boolean isActive;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime nextBillingDate;
    private boolean canCancel;
    private int remainingDays;
    private String status; // ACTIVE, EXPIRED, CANCELLED
}
