package com.tradingjournal.service;

import com.tradingjournal.dto.AnalyticsResponse;
import com.tradingjournal.dto.TradeResponse;
import com.tradingjournal.entity.Trade;
import com.tradingjournal.entity.User;
import com.tradingjournal.exception.ResourceNotFoundException;
import com.tradingjournal.repository.TradeRepository;
import com.tradingjournal.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AnalyticsService {

    @Autowired
    private TradeRepository tradeRepository;

    @Autowired
    private UserRepository userRepository;

    public AnalyticsResponse getAnalytics(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Long userId = user.getId();

        // Get all trades
        List<Trade> trades = tradeRepository.findByUserIdOrderByTradeDateDesc(userId);

        // Calculate metrics
        BigDecimal totalProfitLoss = tradeRepository.getTotalProfitLossByUserId(userId);
        if (totalProfitLoss == null) {
            totalProfitLoss = BigDecimal.ZERO;
        }

        Long totalTrades = tradeRepository.countByUserId(userId);
        Long winningTrades = tradeRepository.countWinningTradesByUserId(userId);
        Long losingTrades = tradeRepository.countLosingTradesByUserId(userId);

        double winRate = 0.0;
        if (totalTrades > 0) {
            winRate = (winningTrades.doubleValue() / totalTrades.doubleValue()) * 100.0;
            winRate = Math.round(winRate * 100.0) / 100.0;
        }

        // Get best and worst trades
        TradeResponse bestTrade = null;
        TradeResponse worstTrade = null;

        List<Trade> bestTrades = tradeRepository.findBestTradeByUserId(userId);
        if (!bestTrades.isEmpty()) {
            bestTrade = convertToResponse(bestTrades.get(0));
        }

        List<Trade> worstTrades = tradeRepository.findWorstTradeByUserId(userId);
        if (!worstTrades.isEmpty()) {
            worstTrade = convertToResponse(worstTrades.get(0));
        }

        // Monthly summary
        List<AnalyticsResponse.MonthlySummary> monthlySummary = calculateMonthlySummary(trades);

        AnalyticsResponse response = new AnalyticsResponse();
        response.setTotalProfitLoss(totalProfitLoss);
        response.setTotalTrades(totalTrades);
        response.setWinningTrades(winningTrades);
        response.setLosingTrades(losingTrades);
        response.setWinRate(winRate);
        response.setBestTrade(bestTrade);
        response.setWorstTrade(worstTrade);
        response.setMonthlySummary(monthlySummary);

        return response;
    }

    private List<AnalyticsResponse.MonthlySummary> calculateMonthlySummary(List<Trade> trades) {
        Map<String, List<Trade>> tradesByMonth = trades.stream()
                .collect(Collectors.groupingBy(trade -> {
                    LocalDate date = trade.getTradeDate();
                    return date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
                }));

        List<AnalyticsResponse.MonthlySummary> summary = new ArrayList<>();
        tradesByMonth.forEach((month, monthTrades) -> {
            BigDecimal monthProfitLoss = monthTrades.stream()
                    .map(Trade::getProfitLoss)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            AnalyticsResponse.MonthlySummary monthly = new AnalyticsResponse.MonthlySummary();
            monthly.setMonth(month);
            monthly.setTradeCount((long) monthTrades.size());
            monthly.setProfitLoss(monthProfitLoss);
            summary.add(monthly);
        });

        return summary.stream()
                .sorted((a, b) -> b.getMonth().compareTo(a.getMonth()))
                .collect(Collectors.toList());
    }

    private TradeResponse convertToResponse(Trade trade) {
        TradeResponse response = new TradeResponse();
        response.setId(trade.getId());
        response.setInstrument(trade.getInstrument());
        response.setTradeType(trade.getTradeType());
        response.setEntryPrice(trade.getEntryPrice());
        response.setExitPrice(trade.getExitPrice());
        response.setQuantity(trade.getQuantity());
        response.setLotSize(trade.getLotSize());
        response.setTradeDate(trade.getTradeDate());
        response.setNotes(trade.getNotes());
        response.setProfitLoss(trade.getProfitLoss());
        response.setCreatedAt(trade.getCreatedAt());
        response.setUpdatedAt(trade.getUpdatedAt());
        return response;
    }
}
