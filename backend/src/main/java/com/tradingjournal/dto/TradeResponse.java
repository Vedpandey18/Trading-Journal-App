package com.tradingjournal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TradeResponse {
    private Long id;
    private String instrument;
    private String tradeType;
    private BigDecimal entryPrice;
    private BigDecimal exitPrice;
    private Integer quantity;
    private Integer lotSize;
    private LocalDate tradeDate;
    private String notes;
    private BigDecimal profitLoss;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
