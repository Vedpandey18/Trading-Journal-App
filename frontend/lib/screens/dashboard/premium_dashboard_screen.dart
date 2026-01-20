import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/trade_provider.dart';
import '../../theme/premium_theme.dart';
import '../../widgets/advanced_charts.dart';
import '../../widgets/loading_skeleton.dart';
import 'package:intl/intl.dart';

/// Premium Dashboard Screen
/// Modern fintech dashboard with KPI cards and advanced charts
class PremiumDashboardScreen extends StatefulWidget {
  const PremiumDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PremiumDashboardScreen> createState() => _PremiumDashboardScreenState();
}

class _PremiumDashboardScreenState extends State<PremiumDashboardScreen> {
  // Cache expensive calculations
  List<FlSpot>? _cachedPnLSpots;
  List<FlSpot>? _cachedEquitySpots;
  List<BarChartGroupData>? _cachedMonthlyBars;
  List<BarChartGroupData>? _cachedDailyBars;
  int? _lastTradesHash; // Track when trades change to invalidate cache
  
  @override
  void initState() {
    super.initState();
    // Load data asynchronously without blocking UI - only if not already fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      
      // Only fetch trades if not already loaded and not currently loading
      if (!tradeProvider.isLoading && 
          !tradeProvider.tradesFetched && 
          tradeProvider.trades.isEmpty) {
        // Fetch trades immediately
        tradeProvider.fetchTrades();
        // Fetch analytics in parallel (don't wait for trades)
        if (!tradeProvider.analyticsFetched && tradeProvider.analytics == null) {
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              tradeProvider.fetchAnalytics();
            }
          });
        }
      } else if (!tradeProvider.analyticsFetched && tradeProvider.analytics == null) {
        // If trades already exist, fetch analytics immediately
        tradeProvider.fetchAnalytics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Force dark mode only as per requirements
    final brightness = Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: PremiumTheme.premiumDarkGradient(),
        child: _buildContent(brightness, isMobile, isTablet, isDesktop, screenWidth),
      ),
    );
  }

  Widget _buildContent(Brightness brightness, bool isMobile, bool isTablet, bool isDesktop, double screenWidth) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Dashboard',
          style: PremiumTheme.heading2(brightness).copyWith(
            color: PremiumTheme.darkTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 20 : 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: PremiumTheme.darkTextPrimary,
            ),
            onPressed: () {
              final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
              tradeProvider.refreshTrades();
              tradeProvider.refreshAnalytics();
              // Clear cache on refresh
              _cachedPnLSpots = null;
              _cachedEquitySpots = null;
              _cachedMonthlyBars = null;
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
          await tradeProvider.refreshTrades();
          await tradeProvider.refreshAnalytics();
          // Clear cache on refresh
          _cachedPnLSpots = null;
          _cachedEquitySpots = null;
          _cachedMonthlyBars = null;
          _cachedDailyBars = null;
          _lastTradesHash = null;
        },
        child: Consumer<TradeProvider>(
          builder: (context, tradeProvider, child) {
            // Always show UI immediately - use existing data or defaults
            // Don't block UI waiting for data
            final analytics = tradeProvider.analytics;
            final trades = tradeProvider.trades;
            
            // Calculate metrics (use defaults if analytics not loaded yet)
            final totalPnL = (analytics?['totalProfitLoss'] as num?)?.toDouble() ?? 0.0;
            final totalTrades = trades.length;
            final winningTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl > 0;
            }).length;
            final losingTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl < 0;
            }).length;
            final winRate = totalTrades > 0 ? (winningTrades / totalTrades) * 100 : 0.0;
            final avgProfit = (analytics?['avgProfit'] as num?)?.toDouble() ?? 0.0;
            final avgLoss = (analytics?['avgLoss'] as num?)?.toDouble() ?? 0.0;

            // Prepare chart data (cached - only regenerate if trades changed)
            // Use simple hash based on trades length and first trade ID for fast comparison
            final tradesHash = trades.isEmpty 
                ? 0 
                : trades.length.hashCode ^ (trades.first['id']?.hashCode ?? 0);
            
            if (_lastTradesHash != tradesHash) {
              _cachedPnLSpots = null;
              _cachedEquitySpots = null;
              _cachedMonthlyBars = null;
              _cachedDailyBars = null;
              _lastTradesHash = tradesHash;
            }
            
            // Generate chart data lazily (only when needed)
            final pnlSpots = _cachedPnLSpots ??= _generatePnLSpots(trades);
            final equitySpots = _cachedEquitySpots ??= _generateEquitySpots(trades);
            final monthlyBars = _cachedMonthlyBars ??= _generateMonthlyBars(trades);
            final dailyBars = _cachedDailyBars ??= _generateDailyBars(trades);

            // Responsive padding
            final padding = isMobile 
                ? PremiumTheme.spaceMD 
                : isTablet 
                    ? PremiumTheme.spaceLG 
                    : PremiumTheme.spaceXL;
            
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1200 : double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero P&L Card with gradient background
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isMobile ? 18 : 22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: totalPnL >= 0
                            ? PremiumTheme.profitGradient()
                            : totalPnL < 0
                                ? PremiumTheme.lossGradient()
                                : PremiumTheme.primaryGradient(),
                        boxShadow: [
                          BoxShadow(
                            color: (totalPnL >= 0
                                    ? PremiumTheme.darkProfit
                                    : totalPnL < 0
                                        ? PremiumTheme.darkLoss
                                        : PremiumTheme.darkPrimary)
                                .withOpacity(0.25),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL P&L',
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${totalPnL.toStringAsFixed(2)}',
                            style: PremiumTheme.heroNumber(
                              Colors.white,
                              Brightness.dark,
                            ).copyWith(
                              fontSize: isMobile ? 28 : isTablet ? 32 : 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: PremiumTheme.spaceMD),

                  // Stats Grid with clean minimal cards (responsive)
                  GridView.count(
                    crossAxisCount: isMobile ? 2 : isTablet ? 2 : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD,
                    mainAxisSpacing: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD,
                    childAspectRatio: isMobile ? 1.3 : isTablet ? 1.4 : 1.5,
                    children: [
                      _buildMinimalStatCard(
                        title: 'Total Trades',
                        value: totalTrades.toString(),
                        icon: Icons.bar_chart_rounded,
                        iconColor: Colors.blueAccent,
                        isMobile: isMobile,
                      ),
                      _buildMinimalStatCard(
                        title: 'Win Rate',
                        value: '${winRate.toStringAsFixed(1)}%',
                        icon: Icons.percent_rounded,
                        iconColor: Colors.greenAccent,
                        isMobile: isMobile,
                      ),
                      _buildMinimalStatCard(
                        title: 'Avg Profit',
                        value: '₹${avgProfit.toStringAsFixed(2)}',
                        icon: Icons.trending_up_rounded,
                        iconColor: Colors.green,
                        isMobile: isMobile,
                      ),
                      _buildMinimalStatCard(
                        title: 'Avg Loss',
                        value: '₹${avgLoss.toStringAsFixed(2)}',
                        icon: Icons.trending_down_rounded,
                        iconColor: Colors.redAccent,
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                  const SizedBox(height: PremiumTheme.spaceLG),

                  // Charts (lazy loaded with RepaintBoundary for performance)
                  if (pnlSpots.isNotEmpty) ...[
                    RepaintBoundary(
                      child: AdvancedCharts.pnlCurveChart(
                        spots: pnlSpots,
                        context: context,
                      ),
                    ),
                    SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
                  ],

                  // Day-wise P&L Bar Chart (always show if data available)
                  if (dailyBars.isNotEmpty) ...[
                    RepaintBoundary(
                      child: AdvancedCharts.dailyPnLChart(
                        barGroups: dailyBars,
                        context: context,
                      ),
                    ),
                    SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
                  ],

                  if (equitySpots.isNotEmpty && !isMobile) ...[
                    RepaintBoundary(
                      child: AdvancedCharts.equityCurveChart(
                        spots: equitySpots,
                        context: context,
                      ),
                    ),
                    SizedBox(height: PremiumTheme.spaceMD),
                  ],

                  if (monthlyBars.isNotEmpty && !isMobile) ...[
                    RepaintBoundary(
                      child: AdvancedCharts.monthlyPnLChart(
                        barGroups: monthlyBars,
                        context: context,
                      ),
                    ),
                    SizedBox(height: PremiumTheme.spaceMD),
                  ],

                  RepaintBoundary(
                    child: AdvancedCharts.winLossPieChart(
                      wins: winningTrades,
                      losses: losingTrades,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: PremiumTheme.spaceLG),

                  // Recent Trades Section
                  if (trades.isNotEmpty) ...[
                    Text(
                      'Recent Trades',
                      style: PremiumTheme.heading3(brightness),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),
                    ...trades.take(3).map((trade) => RepaintBoundary(
                      child: _buildTradeCard(trade, brightness),
                    )),
                  ] else ...[
                    _buildEmptyState(brightness),
                  ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<FlSpot> _generatePnLSpots(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    
    // Sort trades by date to ensure chronological order
    final sortedTrades = List<Map<String, dynamic>>.from(trades);
    sortedTrades.sort((a, b) {
      final dateA = a['tradeDate'] as String?;
      final dateB = b['tradeDate'] as String?;
      if (dateA == null || dateB == null) return 0;
      try {
        return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
      } catch (e) {
        return 0;
      }
    });
    
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedTrades.length; i++) {
      final pnl = (sortedTrades[i]['profitLoss'] as num?)?.toDouble() ?? 0.0;
      spots.add(FlSpot(i.toDouble(), pnl));
    }
    return spots;
  }

  List<FlSpot> _generateEquitySpots(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    
    // Sort trades by date to ensure chronological order
    final sortedTrades = List<Map<String, dynamic>>.from(trades);
    sortedTrades.sort((a, b) {
      final dateA = a['tradeDate'] as String?;
      final dateB = b['tradeDate'] as String?;
      if (dateA == null || dateB == null) return 0;
      try {
        return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
      } catch (e) {
        return 0;
      }
    });
    
    final spots = <FlSpot>[];
    double cumulativePnL = 0;
    for (int i = 0; i < sortedTrades.length; i++) {
      final pnl = (sortedTrades[i]['profitLoss'] as num?)?.toDouble() ?? 0.0;
      cumulativePnL += pnl;
      spots.add(FlSpot(i.toDouble(), cumulativePnL));
    }
    return spots;
  }

  List<BarChartGroupData> _generateMonthlyBars(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    
    final monthlyPnL = <String, double>{};
    for (var trade in trades) {
      final dateStr = trade['tradeDate'] as String?;
      if (dateStr != null) {
        try {
          final date = DateTime.parse(dateStr);
          final monthKey = DateFormat('MMM yyyy').format(date);
          final pnl = (trade['profitLoss'] as num?)?.toDouble() ?? 0.0;
          monthlyPnL[monthKey] = (monthlyPnL[monthKey] ?? 0.0) + pnl;
        } catch (e) {
          // Skip invalid dates
        }
      }
    }

    final sortedMonths = monthlyPnL.keys.toList()..sort();
    final bars = <BarChartGroupData>[];
    for (int i = 0; i < sortedMonths.length && i < 6; i++) {
      final pnl = monthlyPnL[sortedMonths[i]] ?? 0.0;
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: pnl,
              color: pnl >= 0 ? PremiumTheme.lightProfit : PremiumTheme.lightLoss,
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }
    return bars;
  }

  // Generate day-wise bar chart data
  List<BarChartGroupData> _generateDailyBars(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    
    final dailyPnL = <String, double>{};
    for (var trade in trades) {
      final dateStr = trade['tradeDate'] as String?;
      if (dateStr != null) {
        try {
          final date = DateTime.parse(dateStr);
          final dayKey = DateFormat('MMM dd').format(date);
          final pnl = (trade['profitLoss'] as num?)?.toDouble() ?? 0.0;
          dailyPnL[dayKey] = (dailyPnL[dayKey] ?? 0.0) + pnl;
        } catch (e) {
          // Skip invalid dates
        }
      }
    }

    // Sort by date and take last 7-14 days
    final sortedDays = dailyPnL.keys.toList()..sort((a, b) {
      try {
        final dateA = DateFormat('MMM dd').parse(a);
        final dateB = DateFormat('MMM dd').parse(b);
        return dateA.compareTo(dateB);
      } catch (e) {
        return 0;
      }
    });
    
    final bars = <BarChartGroupData>[];
    final daysToShow = sortedDays.length > 14 ? sortedDays.sublist(sortedDays.length - 14) : sortedDays;
    
    for (int i = 0; i < daysToShow.length; i++) {
      final pnl = dailyPnL[daysToShow[i]] ?? 0.0;
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: pnl,
              color: pnl >= 0 ? PremiumTheme.lightProfit : PremiumTheme.lightLoss,
              width: 16,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }
    return bars;
  }

  Widget _buildTradeCard(Map<String, dynamic> trade, Brightness brightness) {
    final instrument = trade['instrument'] ?? 'N/A';
    final tradeType = trade['tradeType'] ?? 'BUY';
    final pnl = (trade['profitLoss'] as num?)?.toDouble() ?? 0.0;
    final dateStr = trade['tradeDate'] as String?;
    DateTime? tradeDate;
    if (dateStr != null) {
      try {
        tradeDate = DateTime.parse(dateStr);
      } catch (e) {
        // Invalid date
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: PremiumTheme.spaceMD),
      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(brightness),
      child: Row(
        children: [
          // Instrument Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: PremiumTheme.lightPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
            ),
            child: Text(
              instrument,
              style: PremiumTheme.bodyMedium(brightness).copyWith(
                fontWeight: FontWeight.w600,
                color: PremiumTheme.lightPrimary,
              ),
            ),
          ),
          const SizedBox(width: PremiumTheme.spaceMD),
          
          // Trade Type Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tradeType == 'BUY'
                  ? PremiumTheme.lightProfit.withOpacity(0.1)
                  : PremiumTheme.lightLoss.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tradeType,
              style: PremiumTheme.bodySmall(brightness).copyWith(
                color: tradeType == 'BUY'
                    ? PremiumTheme.lightProfit
                    : PremiumTheme.lightLoss,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const Spacer(),
          
          // P&L
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${pnl.toStringAsFixed(2)}',
                style: PremiumTheme.getPnLTextStyle(pnl, brightness, fontSize: 18),
              ),
              if (tradeDate != null)
                Text(
                  DateFormat('MMM dd').format(tradeDate),
                  style: PremiumTheme.bodySmall(brightness),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Brightness brightness) {
    return Container(
      padding: const EdgeInsets.all(PremiumTheme.space2XL),
      decoration: PremiumTheme.glassmorphicCard(brightness),
      child: Column(
        children: [
          Icon(
            Icons.trending_up,
            size: 64,
            color: PremiumTheme.darkTextTertiary,
          ),
          const SizedBox(height: PremiumTheme.spaceMD),
          Text(
            'No trades yet',
            style: PremiumTheme.heading3(brightness),
          ),
          const SizedBox(height: PremiumTheme.spaceSM),
          Text(
            'Add your first trade to see analytics',
            style: PremiumTheme.bodyMedium(brightness),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: PremiumTheme.darkCard.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: isMobile ? 20 : 24),
          const Spacer(),
          Text(
            value,
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
              fontSize: isMobile ? 11 : 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChartCard() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: PremiumTheme.darkCard.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'P&L Curve',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                '📈 Chart will appear here',
                style: PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                  color: Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
