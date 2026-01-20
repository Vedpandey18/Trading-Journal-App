package com.tradingjournal.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class TradeRequest {

    @NotBlank(message = "Instrument is required")
    private String instrument;

    @NotBlank(message = "Trade type is required (BUY or SELL)")
    private String tradeType;

    @NotNull(message = "Entry price is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Entry price must be greater than 0")
    private BigDecimal entryPrice;

    @NotNull(message = "Exit price is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Exit price must be greater than 0")
    private BigDecimal exitPrice;

    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity;

    private Integer lotSize = 1;

    @NotNull(message = "Trade date is required")
    private LocalDate tradeDate;

    private String notes;
}
