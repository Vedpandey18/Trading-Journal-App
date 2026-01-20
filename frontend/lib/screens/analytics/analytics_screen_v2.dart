import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/theme.dart';
import '../../models/trade_model.dart';
import 'package:intl/intl.dart';

/// Analytics Screen with Professional Charts
/// Uses fl_chart library for professional trading charts
class AnalyticsScreenV2 extends StatefulWidget {
  const AnalyticsScreenV2({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreenV2> createState() => _AnalyticsScreenV2State();
}

class _AnalyticsScreenV2State extends State<AnalyticsScreenV2> {

  // Chart data
  final List<FlSpot> equityCurveData = [
    const FlSpot(0, 0),
    const FlSpot(1, 500),
    const FlSpot(2, 1200),
    const FlSpot(3, 800),
    const FlSpot(4, 1500),
    const FlSpot(5, 2000),
    const FlSpot(6, 1800),
    const FlSpot(7, 2500),
    const FlSpot(8, 3000),
    const FlSpot(9, 3500),
    const FlSpot(10, 4000),
  ];

  final List<BarChartGroupData> dailyPnLData = [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(toY: 500, color: AppTheme.profit),
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(toY: 700, color: AppTheme.profit),
    ]),
    BarChartGroupData(x: 2, barRods: [
      BarChartRodData(toY: -200, color: AppTheme.loss),
    ]),
    BarChartGroupData(x: 3, barRods: [
      BarChartRodData(toY: 400, color: AppTheme.profit),
    ]),
    BarChartGroupData(x: 4, barRods: [
      BarChartRodData(toY: 500, color: AppTheme.profit),
    ]),
    BarChartGroupData(x: 5, barRods: [
      BarChartRodData(toY: -100, color: AppTheme.loss),
    ]),
    BarChartGroupData(x: 6, barRods: [
      BarChartRodData(toY: 700, color: AppTheme.profit),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Win vs Loss Donut Chart
              _WinLossDonutChart(
                winningTrades: winningTrades,
                losingTrades: losingTrades,
                totalTrades: totalTrades,
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Equity Curve Line Chart
              _EquityCurveChart(data: equityCurveData),
              const SizedBox(height: AppTheme.spaceLG),

              // Daily P&L Bar Chart
              _DailyPnLBarChart(data: dailyPnLData),
              const SizedBox(height: AppTheme.spaceLG),

              // Best & Worst Trades
              Text(
                'Best & Worst Trades',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              Row(
                children: [
                  Expanded(
                    child: _BestWorstCard(
                      title: 'Best Trade',
                      instrument: 'NIFTY',
                      tradeType: 'BUY',
                      entryPrice: 19500.50,
                      exitPrice: 19600.75,
                      profitLoss: 5012.50,
                      isBest: true,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: _BestWorstCard(
                      title: 'Worst Trade',
                      instrument: 'RELIANCE',
                      tradeType: 'BUY',
                      entryPrice: 2450.00,
                      exitPrice: 2435.50,
                      profitLoss: -145.00,
                      isBest: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Monthly Performance
              Text(
                'Monthly Performance',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              ..._buildMonthlySummary(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  List<Widget> _buildMonthlySummary() {
    // Return empty list - will be replaced with real data
    final monthlyData = <Map<String, dynamic>>[];

    return monthlyData.map((data) {
      final pnl = data['pnl'] as double;
      return Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
        padding: const EdgeInsets.all(AppTheme.spaceMD),
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

/// Win vs Loss Donut Chart
class _WinLossDonutChart extends StatelessWidget {
  final int winningTrades;
  final int losingTrades;
  final int totalTrades;

  const _WinLossDonutChart({
    required this.winningTrades,
    required this.losingTrades,
    required this.totalTrades,
  });

  @override
  Widget build(BuildContext context) {
    final winPercentage = (winningTrades / totalTrades) * 100;
    final lossPercentage = (losingTrades / totalTrades) * 100;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Win vs Loss',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: winPercentage,
                    color: AppTheme.profit,
                    title: '${winPercentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: lossPercentage,
                    color: AppTheme.loss,
                    title: '${lossPercentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                ],
                centerSpaceRadius: 50,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem('Win', winningTrades, AppTheme.profit),
              const SizedBox(width: AppTheme.spaceLG),
              _LegendItem('Loss', losingTrades, AppTheme.loss),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _LegendItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Equity Curve Line Chart
class _EquityCurveChart extends StatelessWidget {
  final List<FlSpot> data;

  const _EquityCurveChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equity Curve',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.neutral300,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}',
                          style: AppTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppTheme.neutral300),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Daily P&L Bar Chart
class _DailyPnLBarChart extends StatelessWidget {
  final List<BarChartGroupData> data;

  const _DailyPnLBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily P&L',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.neutral300,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}',
                          style: AppTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'Day ${value.toInt() + 1}',
                          style: AppTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppTheme.neutral300),
                ),
                barGroups: data,
                maxY: 1000,
                minY: -500,
              ),
            ),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.getPnLColor(profitLoss).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
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
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            _formatCurrency(profitLoss),
            style: AppTheme.getPnLTextStyle(profitLoss, fontSize: 22),
          ),
          const SizedBox(height: AppTheme.spaceSM),
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
