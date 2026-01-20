import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/trade_provider.dart';
import '../../widgets/loading_skeleton.dart';
import 'package:intl/intl.dart';

/// Analytics Screen
/// Professional trading analytics dashboard
/// Shows charts, best/worst trades, monthly performance
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch analytics data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      if (tradeProvider.trades.isEmpty) {
        tradeProvider.fetchTrades();
      }
      tradeProvider.fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
          await tradeProvider.refreshTrades();
          await tradeProvider.refreshAnalytics();
        },
        child: Consumer<TradeProvider>(
          builder: (context, tradeProvider, _) {
            final analytics = tradeProvider.analytics;
            final trades = tradeProvider.trades;
            
            if (tradeProvider.isLoadingAnalytics) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            // Calculate stats from real data
            final totalTrades = trades.length;
            final winningTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl > 0;
            }).length;
            final losingTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl < 0;
            }).length;
            final totalPnL = trades.fold<double>(0.0, (sum, t) {
              return sum + ((t['profitLoss'] as num?)?.toDouble() ?? 0.0);
            });
            final winRate = totalTrades > 0 ? (winningTrades / totalTrades) * 100 : 0.0;
            
            // Find best and worst trades
            Map<String, dynamic>? bestTrade;
            Map<String, dynamic>? worstTrade;
            if (trades.isNotEmpty) {
              bestTrade = trades.reduce((a, b) {
                final pnlA = (a['profitLoss'] as num?)?.toDouble() ?? 0.0;
                final pnlB = (b['profitLoss'] as num?)?.toDouble() ?? 0.0;
                return pnlA > pnlB ? a : b;
              });
              worstTrade = trades.reduce((a, b) {
                final pnlA = (a['profitLoss'] as num?)?.toDouble() ?? 0.0;
                final pnlB = (b['profitLoss'] as num?)?.toDouble() ?? 0.0;
                return pnlA < pnlB ? a : b;
              });
            }
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppTheme.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Win vs Loss Chart
                  Container(
                    padding: AppTheme.cardPadding,
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Win vs Loss',
                          style: AppTheme.heading3,
                        ),
                        const SizedBox(height: AppTheme.spacingMD),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: totalTrades == 0
                              ? Center(
                                  child: Text(
                                    'No trades yet',
                                    style: AppTheme.bodyMedium,
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _buildChartSegment(
                                            'Win',
                                            winningTrades,
                                            totalTrades,
                                            AppTheme.profitGreen,
                                          ),
                                          const SizedBox(width: 8),
                                          _buildChartSegment(
                                            'Loss',
                                            losingTrades,
                                            totalTrades,
                                            AppTheme.lossRed,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppTheme.spacingMD),
                                      Text(
                                        '${winningTrades} Wins | ${losingTrades} Losses',
                                        style: AppTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: AppTheme.spacingLG),

              // Performance Chart
              Container(
                padding: AppTheme.cardPadding,
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit vs Loss Chart',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    Container(
                      height: 250,
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
                              'Line Chart Placeholder',
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

                  // Best & Worst Trades
                  if (bestTrade != null || worstTrade != null) ...[
                    Text(
                      'Best & Worst Trades',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    Row(
                      children: [
                        if (bestTrade != null)
                          Expanded(
                            child: _BestWorstCard(
                              title: 'Best Trade',
                              instrument: bestTrade['instrument'] ?? 'N/A',
                              tradeType: bestTrade['tradeType'] ?? 'BUY',
                              entryPrice: (bestTrade['entryPrice'] as num?)?.toDouble() ?? 0.0,
                              exitPrice: (bestTrade['exitPrice'] as num?)?.toDouble() ?? 0.0,
                              profitLoss: (bestTrade['profitLoss'] as num?)?.toDouble() ?? 0.0,
                              isBest: true,
                            ),
                          ),
                        if (bestTrade != null && worstTrade != null)
                          const SizedBox(width: AppTheme.spacingMD),
                        if (worstTrade != null)
                          Expanded(
                            child: _BestWorstCard(
                              title: 'Worst Trade',
                              instrument: worstTrade['instrument'] ?? 'N/A',
                              tradeType: worstTrade['tradeType'] ?? 'BUY',
                              entryPrice: (worstTrade['entryPrice'] as num?)?.toDouble() ?? 0.0,
                              exitPrice: (worstTrade['exitPrice'] as num?)?.toDouble() ?? 0.0,
                              profitLoss: (worstTrade['profitLoss'] as num?)?.toDouble() ?? 0.0,
                              isBest: false,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLG),
                  ],

                  // Monthly Performance Summary
                  if (trades.isNotEmpty) ...[
                    Text(
                      'Monthly Performance',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    ..._buildMonthlySummary(trades),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartSegment(
    String label,
    int value,
    int total,
    Color color,
  ) {
    final percentage = (value / total) * 100;
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall,
        ),
        Text(
          value.toString(),
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMonthlySummary(List<Map<String, dynamic>> trades) {
    // Group trades by month
    final Map<String, List<Map<String, dynamic>>> monthlyTrades = {};
    
    for (var trade in trades) {
      final dateStr = trade['tradeDate'] as String?;
      if (dateStr != null) {
        try {
          final date = DateTime.parse(dateStr);
          final monthKey = DateFormat('MMM yyyy').format(date);
          monthlyTrades.putIfAbsent(monthKey, () => []).add(trade);
        } catch (e) {
          // Skip invalid dates
        }
      }
    }
    
    // Convert to list and sort by date (newest first)
    final monthlyData = monthlyTrades.entries.map((entry) {
      final monthTrades = entry.value;
      final totalPnL = monthTrades.fold<double>(0.0, (sum, t) {
        return sum + ((t['profitLoss'] as num?)?.toDouble() ?? 0.0);
      });
      return {
        'month': entry.key,
        'trades': monthTrades.length,
        'pnl': totalPnL,
      };
    }).toList();
    
    // Sort by month (newest first) - simple string sort works for "MMM yyyy" format
    monthlyData.sort((a, b) => (b['month'] as String).compareTo(a['month'] as String));
    
    if (monthlyData.isEmpty) {
      return [
        Container(
          padding: AppTheme.cardPadding,
          decoration: AppTheme.cardDecoration,
          child: Text(
            'No monthly data available',
            style: AppTheme.bodyMedium,
          ),
        ),
      ];
    }
    
    return monthlyData.take(6).map((data) {
      final pnl = data['pnl'] as double;
      return Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMD),
        padding: AppTheme.cardPadding,
        decoration: AppTheme.cardDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['month'] as String,
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: 4),
                Text(
                  '${data['trades']} trades',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            Text(
              _formatCurrency(pnl),
              style: AppTheme.getPnLTextStyle(pnl, fontSize: 20),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatCurrency(double value) {
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}

class _BestWorstCard extends StatelessWidget {
  final String title;
  final String instrument;
  final String tradeType;
  final double entryPrice;
  final double exitPrice;
  final double profitLoss;
  final bool isBest;

  const _BestWorstCard({
    required this.title,
    required this.instrument,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.profitLoss,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: BoxDecoration(
        color: AppTheme.getPnLColor(profitLoss).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getPnLColor(profitLoss),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.labelMedium,
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            _formatCurrency(profitLoss),
            style: AppTheme.getPnLTextStyle(profitLoss, fontSize: 24),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            '$instrument - $tradeType',
            style: AppTheme.bodyMedium,
          ),
          Text(
            'Entry: ₹${entryPrice.toStringAsFixed(2)}',
            style: AppTheme.bodySmall,
          ),
          Text(
            'Exit: ₹${exitPrice.toStringAsFixed(2)}',
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}
