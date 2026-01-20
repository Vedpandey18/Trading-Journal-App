package com.tradingjournal.service;

import com.tradingjournal.dto.TradeRequest;
import com.tradingjournal.dto.TradeResponse;
import com.tradingjournal.entity.Trade;
import com.tradingjournal.entity.User;
import com.tradingjournal.exception.ResourceNotFoundException;
import com.tradingjournal.repository.TradeRepository;
import com.tradingjournal.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TradeService {

    @Autowired
    private TradeRepository tradeRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubscriptionService subscriptionService;

    @Value("${subscription.free.trade.limit:10}")
    private int freeTradeLimit;

    @Transactional
    public TradeResponse addTrade(String username, TradeRequest request) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // Check subscription limits
        if (!subscriptionService.isProUser(user.getId())) {
            long tradeCount = tradeRepository.countByUserId(user.getId());
            if (tradeCount >= freeTradeLimit) {
                throw new RuntimeException("Free plan limit reached. Upgrade to PRO for unlimited trades.");
            }
        }

        // Validate trade type
        if (!"BUY".equalsIgnoreCase(request.getTradeType()) && 
            !"SELL".equalsIgnoreCase(request.getTradeType())) {
            throw new IllegalArgumentException("Trade type must be BUY or SELL");
        }

        Trade trade = new Trade();
        trade.setInstrument(request.getInstrument());
        trade.setTradeType(request.getTradeType().toUpperCase());
        trade.setEntryPrice(request.getEntryPrice());
        trade.setExitPrice(request.getExitPrice());
        trade.setQuantity(request.getQuantity());
        trade.setLotSize(request.getLotSize() != null ? request.getLotSize() : 1);
        trade.setTradeDate(request.getTradeDate());
        trade.setNotes(request.getNotes());
        trade.setUser(user);

        trade = tradeRepository.save(trade);

        return convertToResponse(trade);
    }

    public List<TradeResponse> getAllTrades(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        return tradeRepository.findByUserIdOrderByTradeDateDesc(user.getId())
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<TradeResponse> getTradesByDateRange(String username, LocalDate startDate, LocalDate endDate) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        return tradeRepository.findByUserIdAndTradeDateBetweenOrderByTradeDateDesc(
                user.getId(), startDate, endDate)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteTrade(String username, Long tradeId) {
        if (tradeId == null) {
            throw new IllegalArgumentException("Trade ID cannot be null");
        }
        
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Trade trade = tradeRepository.findById(tradeId)
                .orElseThrow(() -> new ResourceNotFoundException("Trade not found"));

        if (!trade.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized: Trade does not belong to user");
        }

        tradeRepository.delete(trade);
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
