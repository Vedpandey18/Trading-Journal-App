import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/trade_card.dart';
import '../../widgets/date_range_selector.dart';
import '../../widgets/loading_skeleton.dart';
import '../../providers/trade_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:intl/intl.dart';

/// Dashboard Screen - Main screen for traders
/// Inspired by TraderVue dashboard
/// Shows key metrics and recent trades at a glance
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateRange _selectedRange = DateRange.month;

  @override
  void initState() {
    super.initState();
    // Fetch data asynchronously AFTER UI renders - non-blocking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      // Only fetch if not already loading and data is empty
      if (!tradeProvider.isLoading && tradeProvider.trades.isEmpty) {
        tradeProvider.fetchTrades();
      }
      // Analytics can load separately - don't block UI
      if (tradeProvider.analytics == null) {
        tradeProvider.fetchAnalytics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
              tradeProvider.fetchTrades();
              tradeProvider.fetchAnalytics();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
          await tradeProvider.fetchTrades();
          await tradeProvider.fetchAnalytics();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Selector
              DateRangeSelector(
                initialRange: _selectedRange,
                onRangeChanged: (range) {
                  setState(() {
                    _selectedRange = range;
                  });
                  // Filter data by date range
                },
              ),
              const SizedBox(height: AppTheme.spacingLG),

              // Dashboard Content with Real Data
              Consumer<TradeProvider>(
                builder: (context, tradeProvider, _) {
                  // Show loading skeleton while data loads
                  if (tradeProvider.isLoading && tradeProvider.analytics == null) {
                    return const DashboardLoadingSkeleton();
                  }
                  
                  final analytics = tradeProvider.analytics;
                  final totalPnL = (analytics?['totalProfitLoss'] as num?)?.toDouble() ?? 0.0;
                  final totalTrades = (analytics?['totalTrades'] as num?)?.toInt() ?? 0;
                  final winRate = (analytics?['winRate'] as num?)?.toDouble() ?? 0.0;
                  final avgProfit = (analytics?['avgProfit'] as num?)?.toDouble() ?? 0.0;
                  final avgLoss = (analytics?['avgLoss'] as num?)?.toDouble() ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total P&L Card (Most Important - Largest)
                      Container(
                        padding: AppTheme.cardPaddingLarge,
                        decoration: AppTheme.cardDecorationElevated,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total P&L',
                              style: AppTheme.labelMedium,
                            ),
                            const SizedBox(height: AppTheme.spacingSM),
                            Text(
                              _formatCurrency(totalPnL),
                              style: AppTheme.getPnLTextStyle(
                                totalPnL,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSM),
                            Row(
                              children: [
                                Icon(
                                  totalPnL >= 0 ? Icons.trending_up : Icons.trending_down,
                                  size: 16,
                                  color: AppTheme.getPnLColor(totalPnL),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${totalPnL >= 0 ? '+' : ''}${((totalPnL / 10000) * 100).toStringAsFixed(1)}%',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.getPnLColor(totalPnL),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMD),

                      // Summary Cards Row 1
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Total Trades',
                              value: totalTrades.toString(),
                              icon: Icons.trending_up,
                              iconColor: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMD),
                          Expanded(
                            child: SummaryCard(
                              title: 'Win Rate',
                              value: '${winRate.toStringAsFixed(1)}%',
                              icon: Icons.percent,
                              iconColor: AppTheme.profitGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMD),

                      // Summary Cards Row 2
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Avg Profit',
                              numericValue: avgProfit,
                              isPnL: true,
                              icon: Icons.arrow_upward,
                              iconColor: AppTheme.profitGreen,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMD),
                          Expanded(
                            child: SummaryCard(
                              title: 'Avg Loss',
                              numericValue: avgLoss,
                              isPnL: true,
                              icon: Icons.arrow_downward,
                              iconColor: AppTheme.lossRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppTheme.spacingLG),

              // Performance Chart Placeholder
              Container(
                padding: AppTheme.cardPadding,
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Chart',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.show_chart,
                              size: 48,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: AppTheme.spacingSM),
                            Text(
                              'Chart Placeholder',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                            ),
                            Text(
                              'Equity curve will be displayed here',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLG),

              // Recent Trades Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Trades',
                    style: AppTheme.heading3,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to trades list
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMD),

              // Recent Trades List
              Consumer<TradeProvider>(
                builder: (context, tradeProvider, _) {
                  final trades = tradeProvider.trades;
                  final recentTrades = trades.take(3).toList();
                  
                  if (recentTrades.isEmpty) {
                    return Container(
                      padding: AppTheme.cardPadding,
                      decoration: AppTheme.cardDecoration,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: AppTheme.spacingSM),
                            Text(
                              'No trades yet',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: recentTrades.map((trade) {
                      final tradeDate = trade['tradeDate'] != null
                          ? DateTime.parse(trade['tradeDate'])
                          : DateTime.now();
                      
                      return TradeCard(
                        instrument: trade['instrument'] ?? '',
                        tradeType: trade['tradeType'] ?? 'BUY',
                        entryPrice: (trade['entryPrice'] as num?)?.toDouble() ?? 0.0,
                        exitPrice: (trade['exitPrice'] as num?)?.toDouble() ?? 0.0,
                        quantity: (trade['quantity'] as num?)?.toInt() ?? 0,
                        lotSize: (trade['lotSize'] as num?)?.toInt() ?? 1,
                        profitLoss: (trade['profitLoss'] as num?)?.toDouble() ?? 0.0,
                        tradeDate: tradeDate,
                        notes: trade['notes'],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    if (value >= 0) {
      return '+${formatter.format(value)}';
    }
    return formatter.format(value);
  }

}
