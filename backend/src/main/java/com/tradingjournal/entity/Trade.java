package com.tradingjournal.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "trades")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Trade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false)
    private String instrument;

    @NotBlank
    @Column(name = "trade_type", nullable = false)
    private String tradeType; // "BUY" or "SELL"

    @NotNull
    @DecimalMin(value = "0.0", inclusive = false)
    @Column(name = "entry_price", nullable = false, precision = 19, scale = 2)
    private BigDecimal entryPrice;

    @NotNull
    @DecimalMin(value = "0.0", inclusive = false)
    @Column(name = "exit_price", nullable = false, precision = 19, scale = 2)
    private BigDecimal exitPrice;

    @NotNull
    @Min(1)
    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "lot_size")
    private Integer lotSize = 1; // Default lot size

    @NotNull
    @Column(name = "trade_date", nullable = false)
    private LocalDate tradeDate;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "profit_loss", precision = 19, scale = 2)
    private BigDecimal profitLoss;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        calculateProfitLoss();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        calculateProfitLoss();
    }

    private void calculateProfitLoss() {
        if (entryPrice != null && exitPrice != null && quantity != null && lotSize != null) {
            int totalQuantity = quantity * lotSize;
            if ("BUY".equalsIgnoreCase(tradeType)) {
                // For BUY: Profit = (Exit - Entry) * Quantity
                profitLoss = exitPrice.subtract(entryPrice).multiply(BigDecimal.valueOf(totalQuantity));
            } else if ("SELL".equalsIgnoreCase(tradeType)) {
                // For SELL: Profit = (Entry - Exit) * Quantity
                profitLoss = entryPrice.subtract(exitPrice).multiply(BigDecimal.valueOf(totalQuantity));
            }
        }
    }
}
