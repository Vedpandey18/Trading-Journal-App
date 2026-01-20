package com.tradingjournal.controller;

import com.tradingjournal.dto.TradeRequest;
import com.tradingjournal.dto.TradeResponse;
import com.tradingjournal.service.TradeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/trades")
@CrossOrigin(origins = "*")
public class TradeController {

    @Autowired
    private TradeService tradeService;

    @PostMapping
    public ResponseEntity<?> addTrade(
            @Valid @RequestBody TradeRequest request,
            Authentication authentication) {
        try {
            String username = authentication.getName();
            TradeResponse response = tradeService.addTrade(username, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<List<TradeResponse>> getAllTrades(Authentication authentication) {
        String username = authentication.getName();
        List<TradeResponse> trades = tradeService.getAllTrades(username);
        return ResponseEntity.ok(trades);
    }

    @GetMapping("/date-range")
    public ResponseEntity<List<TradeResponse>> getTradesByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            Authentication authentication) {
        String username = authentication.getName();
        List<TradeResponse> trades = tradeService.getTradesByDateRange(username, startDate, endDate);
        return ResponseEntity.ok(trades);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTrade(
            @PathVariable Long id,
            Authentication authentication) {
        try {
            String username = authentication.getName();
            tradeService.deleteTrade(username, id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        }
    }
}
