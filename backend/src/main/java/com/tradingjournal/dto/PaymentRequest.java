package com.tradingjournal.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PaymentRequest {
    @NotNull(message = "Amount is required")
    private Double amount;

    @NotBlank(message = "Currency is required")
    private String currency = "INR";

    @NotBlank(message = "Plan type is required")
    private String planType; // PRO_MONTHLY, PRO_YEARLY
}
