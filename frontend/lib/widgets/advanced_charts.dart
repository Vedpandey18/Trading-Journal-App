import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/premium_theme.dart';

/// Advanced Charts Widget
/// TradingView-inspired charts for P&L and equity analysis
class AdvancedCharts {
  /// P&L Curve Chart (Trade-by-trade profit/loss)
  static Widget pnlCurveChart({
    required List<FlSpot> spots,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final chartHeight = isMobile ? 200.0 : 250.0;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: chartHeight + 100, // Account for title and padding
      ),
      padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'P&L Curve',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
          SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(spots),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: PremiumTheme.darkBorder.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 40 : 50,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '₹${value.toInt()}',
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              fontSize: isMobile ? 10 : 12,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 25 : 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                            fontSize: isMobile ? 10 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                    border: Border.all(
                      color: PremiumTheme.darkBorder.withOpacity(0.3),
                      width: 1,
                    ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: PremiumTheme.darkPrimary,
                    barWidth: 3.5,
                    dotData: const FlDotData(show: false),
                    shadow: Shadow(
                      color: PremiumTheme.darkPrimary.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          PremiumTheme.darkPrimary.withOpacity(0.3),
                          PremiumTheme.darkPrimary.withOpacity(0.05),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                    gradient: PremiumTheme.primaryGradient(),
                  ),
                ],
                minY: _calculateMinY(spots),
                maxY: _calculateMaxY(spots),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: PremiumTheme.darkCard.withOpacity(0.95),
                    tooltipRoundedRadius: PremiumTheme.radiusMD,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isProfit = spot.y >= 0;
                        final pnlColor = isProfit
                            ? PremiumTheme.darkProfit
                            : PremiumTheme.darkLoss;
                        return LineTooltipItem(
                          'Trade ${spot.x.toInt()}\n',
                          PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                            color: PremiumTheme.darkTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: '₹${spot.y.toStringAsFixed(2)}',
                              style: PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                                color: pnlColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Equity Curve Chart (Account growth over time)
  static Widget equityCurveChart({
    required List<FlSpot> spots,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final chartHeight = isMobile ? 200.0 : 250.0;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: chartHeight + 100,
      ),
      padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equity Curve',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
          SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(spots),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: PremiumTheme.darkBorder.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 40 : 50,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '₹${value.toInt()}',
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              fontSize: isMobile ? 10 : 12,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 25 : 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                            fontSize: isMobile ? 10 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                    border: Border.all(
                      color: PremiumTheme.darkBorder.withOpacity(0.3),
                      width: 1,
                    ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: PremiumTheme.lightProfit,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: PremiumTheme.lightProfit.withOpacity(0.2),
                    ),
                  ),
                ],
                minY: _calculateMinY(spots),
                maxY: _calculateMaxY(spots),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: PremiumTheme.darkCard,
                    tooltipRoundedRadius: PremiumTheme.radiusSM,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          'Day ${spot.x.toInt()}\n₹${spot.y.toStringAsFixed(2)}',
                          PremiumTheme.bodyMedium(Brightness.dark),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Monthly P&L Bar Chart
  static Widget monthlyPnLChart({
    required List<BarChartGroupData> barGroups,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final chartHeight = isMobile ? 200.0 : 250.0;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: chartHeight + 100,
      ),
      padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly P&L',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
          SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: PremiumTheme.darkBorder.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 40 : 50,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '₹${value.toInt()}',
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              fontSize: isMobile ? 10 : 12,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 25 : 30,
                      getTitlesWidget: (value, meta) {
                        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              fontSize: isMobile ? 10 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                    border: Border.all(
                      color: PremiumTheme.darkBorder.withOpacity(0.3),
                      width: 1,
                    ),
                ),
                barGroups: barGroups,
                maxY: _calculateMaxYFromBars(barGroups),
                minY: _calculateMinYFromBars(barGroups),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: PremiumTheme.darkCard,
                    tooltipRoundedRadius: PremiumTheme.radiusSM,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '₹${rod.toY.toStringAsFixed(2)}',
                        PremiumTheme.bodyMedium(Brightness.dark),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Daily P&L Bar Chart
  static Widget dailyPnLChart({
    required List<BarChartGroupData> barGroups,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final chartHeight = isMobile ? 200.0 : 250.0;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: chartHeight + 100,
      ),
      padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily P&L',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
          SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateIntervalFromBars(barGroups),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: PremiumTheme.darkBorder.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 45 : 55,
                      interval: _calculateIntervalFromBars(barGroups),
                      getTitlesWidget: (value, meta) {
                        // Only show labels at intervals to avoid crowding
                        final interval = _calculateIntervalFromBars(barGroups);
                        if ((value % interval).abs() < 0.01 || value == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              '₹${value.toInt()}',
                              style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                                fontSize: isMobile ? 10 : 12,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 25 : 30,
                      getTitlesWidget: (value, meta) {
                        // Show day labels (simplified - just show index)
                        if (value.toInt() % 2 == 0 && value.toInt() < barGroups.length) {
                          return Text(
                            'D${value.toInt() + 1}',
                            style: PremiumTheme.labelSmall(Brightness.dark).copyWith(
                              fontSize: isMobile ? 9 : 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: PremiumTheme.darkBorder.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                barGroups: barGroups,
                maxY: _calculateMaxYFromBars(barGroups),
                minY: _calculateMinYFromBars(barGroups),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: PremiumTheme.darkCard,
                    tooltipRoundedRadius: PremiumTheme.radiusSM,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final isProfit = rod.toY >= 0;
                      return BarTooltipItem(
                        '₹${rod.toY.toStringAsFixed(2)}',
                        PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                          color: isProfit ? PremiumTheme.darkProfit : PremiumTheme.darkLoss,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _calculateIntervalFromBars(List<BarChartGroupData> barGroups) {
    if (barGroups.isEmpty) return 1000;
    final maxY = _calculateMaxYFromBars(barGroups);
    final minY = _calculateMinYFromBars(barGroups);
    final range = maxY - minY;
    if (range <= 0) return 1000;
    // Better spacing for smaller ranges
    if (range <= 2000) return 500;
    if (range <= 5000) return 1000;
    if (range <= 10000) return 2000;
    if (range <= 20000) return 5000;
    return 10000;
  }

  /// Win vs Loss Distribution Pie Chart
  static Widget winLossPieChart({
    required int wins,
    required int losses,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final chartHeight = isMobile ? 200.0 : 250.0;
    final total = wins + losses;
    
    if (total == 0) {
      return Container(
        padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
        decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
        child: Center(
          child: Text(
            'No trades yet',
            style: PremiumTheme.bodyMedium(Brightness.dark),
          ),
        ),
      );
    }

    final winPercentage = (wins / total) * 100;
    final lossPercentage = (losses / total) * 100;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: chartHeight + 100,
      ),
      padding: EdgeInsets.all(isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
      decoration: PremiumTheme.glassmorphicCard(Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Win vs Loss',
            style: PremiumTheme.heading3(Brightness.dark).copyWith(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
          SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: isMobile ? 2 : 3,
                  child: SizedBox(
                    height: chartHeight - 20,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: winPercentage,
                            color: PremiumTheme.lightProfit,
                            title: winPercentage > 5 ? '${winPercentage.toStringAsFixed(0)}%' : '',
                            radius: isMobile ? 70 : 80,
                            titleStyle: PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 14 : 16,
                            ),
                          ),
                          PieChartSectionData(
                            value: lossPercentage,
                            color: PremiumTheme.lightLoss,
                            title: lossPercentage > 5 ? '${lossPercentage.toStringAsFixed(0)}%' : '',
                            radius: isMobile ? 70 : 80,
                            titleStyle: PremiumTheme.bodyMedium(Brightness.dark).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 14 : 16,
                            ),
                          ),
                        ],
                        centerSpaceRadius: isMobile ? 40 : 50,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? PremiumTheme.spaceSM : PremiumTheme.spaceMD),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        'Wins',
                        wins,
                        PremiumTheme.lightProfit,
                        Brightness.dark,
                      ),
                      SizedBox(height: isMobile ? PremiumTheme.spaceXS : PremiumTheme.spaceSM),
                      _buildLegendItem(
                        'Losses',
                        losses,
                        PremiumTheme.lightLoss,
                        Brightness.dark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLegendItem(
    String label,
    int value,
    Color color,
    Brightness brightness,
  ) {
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
        const SizedBox(width: 8),
        Text(
          '$label: $value',
          style: PremiumTheme.bodyMedium(brightness),
        ),
      ],
    );
  }

  static double _calculateInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1000;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final range = maxY - minY;
    if (range == 0) return 1000;
    return (range / 5).ceilToDouble();
  }

  static double _calculateMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    return minY - (minY.abs() * 0.1);
  }

  static double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1000;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxY + (maxY.abs() * 0.1);
  }

  static double _calculateMaxYFromBars(List<BarChartGroupData> bars) {
    if (bars.isEmpty) return 1000;
    double maxY = 0;
    for (var bar in bars) {
      for (var rod in bar.barRods) {
        if (rod.toY > maxY) maxY = rod.toY;
      }
    }
    return maxY + (maxY.abs() * 0.1);
  }

  static double _calculateMinYFromBars(List<BarChartGroupData> bars) {
    if (bars.isEmpty) return 0;
    double minY = 0;
    for (var bar in bars) {
      for (var rod in bar.barRods) {
        if (rod.toY < minY) minY = rod.toY;
      }
    }
    return minY - (minY.abs() * 0.1);
  }
}
