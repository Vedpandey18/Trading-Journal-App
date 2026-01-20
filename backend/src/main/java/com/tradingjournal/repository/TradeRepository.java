package com.tradingjournal.repository;

import com.tradingjournal.entity.Trade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TradeRepository extends JpaRepository<Trade, Long> {
    List<Trade> findByUserIdOrderByTradeDateDesc(Long userId);
    
    List<Trade> findByUserIdAndTradeDateBetweenOrderByTradeDateDesc(
        Long userId, LocalDate startDate, LocalDate endDate);
    
    @Query("SELECT COUNT(t) FROM Trade t WHERE t.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT t FROM Trade t WHERE t.user.id = :userId ORDER BY t.profitLoss DESC")
    List<Trade> findBestTradeByUserId(@Param("userId") Long userId);
    
    @Query("SELECT t FROM Trade t WHERE t.user.id = :userId ORDER BY t.profitLoss ASC")
    List<Trade> findWorstTradeByUserId(@Param("userId") Long userId);
    
    @Query("SELECT SUM(t.profitLoss) FROM Trade t WHERE t.user.id = :userId")
    java.math.BigDecimal getTotalProfitLossByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(t) FROM Trade t WHERE t.user.id = :userId AND t.profitLoss > 0")
    Long countWinningTradesByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(t) FROM Trade t WHERE t.user.id = :userId AND t.profitLoss < 0")
    Long countLosingTradesByUserId(@Param("userId") Long userId);
}
