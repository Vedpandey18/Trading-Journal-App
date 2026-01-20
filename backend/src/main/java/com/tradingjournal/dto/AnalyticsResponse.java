package com.tradingjournal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnalyticsResponse {
    private BigDecimal totalProfitLoss;
    private Long totalTrades;
    private Long winningTrades;
    private Long losingTrades;
    private Double winRate;
    private TradeResponse bestTrade;
    private TradeResponse worstTrade;
    private List<MonthlySummary> monthlySummary;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MonthlySummary {
        private String month;
        private Long tradeCount;
        private BigDecimal profitLoss;
    }
}
