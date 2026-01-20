import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/trade_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/premium_theme.dart';
import '../../widgets/advanced_charts.dart';
import '../../widgets/loading_skeleton.dart';
import 'package:intl/intl.dart';

/// Premium Analytics Screen
/// Advanced charts and visual analytics
class PremiumAnalyticsScreen extends StatefulWidget {
  const PremiumAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<PremiumAnalyticsScreen> createState() => _PremiumAnalyticsScreenState();
}

class _PremiumAnalyticsScreenState extends State<PremiumAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
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
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? PremiumTheme.lightBackground
          : PremiumTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: PremiumTheme.heading2(brightness),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: 'Toggle theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
              tradeProvider.refreshTrades();
              tradeProvider.refreshAnalytics();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
          await tradeProvider.refreshTrades();
          await tradeProvider.refreshAnalytics();
        },
        child: Consumer<TradeProvider>(
          builder: (context, tradeProvider, _) {
            if (tradeProvider.isLoadingAnalytics) {
              return const Center(child: CircularProgressIndicator());
            }

            final trades = tradeProvider.trades;
            
            if (trades.isEmpty) {
              return _buildEmptyState(brightness);
            }

            // Calculate stats
            final totalTrades = trades.length;
            final winningTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl > 0;
            }).length;
            final losingTrades = trades.where((t) {
              final pnl = (t['profitLoss'] as num?)?.toDouble() ?? 0.0;
              return pnl < 0;
            }).length;

            // Prepare chart data
            final pnlSpots = _generatePnLSpots(trades);
            final equitySpots = _generateEquitySpots(trades);
            final monthlyBars = _generateMonthlyBars(trades);

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
              padding: const EdgeInsets.all(PremiumTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Win vs Loss Pie Chart
                  AdvancedCharts.winLossPieChart(
                    wins: winningTrades,
                    losses: losingTrades,
                    context: context,
                  ),
                  const SizedBox(height: PremiumTheme.spaceMD),

                  // P&L Curve
                  if (pnlSpots.isNotEmpty)
                    AdvancedCharts.pnlCurveChart(
                      spots: pnlSpots,
                      context: context,
                    ),
                  const SizedBox(height: PremiumTheme.spaceMD),

                  // Equity Curve
                  if (equitySpots.isNotEmpty)
                    AdvancedCharts.equityCurveChart(
                      spots: equitySpots,
                      context: context,
                    ),
                  const SizedBox(height: PremiumTheme.spaceMD),

                  // Monthly P&L
                  if (monthlyBars.isNotEmpty)
                    AdvancedCharts.monthlyPnLChart(
                      barGroups: monthlyBars,
                      context: context,
                    ),
                  const SizedBox(height: PremiumTheme.spaceMD),

                  // Best & Worst Trades
                  if (bestTrade != null || worstTrade != null) ...[
                    Text(
                      'Best & Worst Trades',
                      style: PremiumTheme.heading3(brightness),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),
                    Row(
                      children: [
                        if (bestTrade != null)
                          Expanded(
                            child: _buildBestWorstCard(
                              bestTrade!,
                              'Best Trade',
                              true,
                              brightness,
                            ),
                          ),
                        if (bestTrade != null && worstTrade != null)
                          const SizedBox(width: PremiumTheme.spaceMD),
                        if (worstTrade != null)
                          Expanded(
                            child: _buildBestWorstCard(
                              worstTrade!,
                              'Worst Trade',
                              false,
                              brightness,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),
                  ],

                  // Monthly Performance
                  if (trades.isNotEmpty) ...[
                    Text(
                      'Monthly Performance',
                      style: PremiumTheme.heading3(brightness),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),
                    ..._buildMonthlySummary(trades, brightness),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<FlSpot> _generatePnLSpots(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    final spots = <FlSpot>[];
    for (int i = 0; i < trades.length; i++) {
      final pnl = (trades[i]['profitLoss'] as num?)?.toDouble() ?? 0.0;
      spots.add(FlSpot(i.toDouble(), pnl));
    }
    return spots;
  }

  List<FlSpot> _generateEquitySpots(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) return [];
    final spots = <FlSpot>[];
    double cumulativePnL = 0;
    for (int i = 0; i < trades.length; i++) {
      final pnl = (trades[i]['profitLoss'] as num?)?.toDouble() ?? 0.0;
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }
    return bars;
  }

  Widget _buildBestWorstCard(
    Map<String, dynamic> trade,
    String title,
    bool isBest,
    Brightness brightness,
  ) {
    final instrument = trade['instrument'] ?? 'N/A';
    final tradeType = trade['tradeType'] ?? 'BUY';
    final entryPrice = (trade['entryPrice'] as num?)?.toDouble() ?? 0.0;
    final exitPrice = (trade['exitPrice'] as num?)?.toDouble() ?? 0.0;
    final pnl = (trade['profitLoss'] as num?)?.toDouble() ?? 0.0;
    final pnlColor = PremiumTheme.getPnLColor(pnl, brightness);

    return Container(
      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
      decoration: PremiumTheme.cardDecoration(brightness).copyWith(
        border: Border.all(
          color: pnlColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PremiumTheme.labelMedium(brightness),
          ),
          const SizedBox(height: PremiumTheme.spaceSM),
          Text(
            '₹${pnl.abs().toStringAsFixed(2)}',
            style: PremiumTheme.getPnLTextStyle(pnl, brightness, fontSize: 24),
          ),
          const SizedBox(height: PremiumTheme.spaceSM),
          Text(
            '$instrument - $tradeType',
            style: PremiumTheme.bodyMedium(brightness),
          ),
          const SizedBox(height: 4),
          Text(
            'Entry: ₹${entryPrice.toStringAsFixed(2)}',
            style: PremiumTheme.bodySmall(brightness),
          ),
          Text(
            'Exit: ₹${exitPrice.toStringAsFixed(2)}',
            style: PremiumTheme.bodySmall(brightness),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMonthlySummary(List<Map<String, dynamic>> trades, Brightness brightness) {
    final monthlyTrades = <String, List<Map<String, dynamic>>>{};
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
    monthlyData.sort((a, b) => (b['month'] as String).compareTo(a['month'] as String));

    if (monthlyData.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(PremiumTheme.spaceMD),
          decoration: PremiumTheme.cardDecoration(brightness),
          child: Text(
            'No monthly data available',
            style: PremiumTheme.bodyMedium(brightness),
          ),
        ),
      ];
    }

    return monthlyData.take(6).map((data) {
      final pnl = data['pnl'] as double;
      return Container(
        margin: const EdgeInsets.only(bottom: PremiumTheme.spaceMD),
        padding: const EdgeInsets.all(PremiumTheme.spaceMD),
        decoration: PremiumTheme.cardDecoration(brightness),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['month'] as String,
                  style: PremiumTheme.heading3(brightness),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data['trades']} trades',
                  style: PremiumTheme.bodySmall(brightness),
                ),
              ],
            ),
            Text(
              '₹${pnl.toStringAsFixed(2)}',
              style: PremiumTheme.getPnLTextStyle(pnl, brightness, fontSize: 20),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(Brightness brightness) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PremiumTheme.space2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: brightness == Brightness.light
                  ? PremiumTheme.lightTextTertiary
                  : PremiumTheme.darkTextTertiary,
            ),
            const SizedBox(height: PremiumTheme.spaceMD),
            Text(
              'No analytics yet',
              style: PremiumTheme.heading2(brightness),
            ),
            const SizedBox(height: PremiumTheme.spaceSM),
            Text(
              'Add trades to see detailed analytics',
              style: PremiumTheme.bodyMedium(brightness),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
