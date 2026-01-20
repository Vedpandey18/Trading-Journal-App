import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../widgets/trade_card_widget.dart';
import '../../models/trade_model.dart';
import '../../providers/trade_provider.dart';
import 'package:intl/intl.dart';

/// Professional Dashboard Screen
/// Main screen for traders - shows key metrics at a glance
/// Inspired by TraderVue professional dashboard
class DashboardScreenV2 extends StatefulWidget {
  const DashboardScreenV2({Key? key}) : super(key: key);

  @override
  State<DashboardScreenV2> createState() => _DashboardScreenV2State();
}

class _DashboardScreenV2State extends State<DashboardScreenV2> {
  DateRange _selectedRange = DateRange.month;

  @override
  void initState() {
    super.initState();
    // Fetch data on screen load
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
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
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
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Selector
              _DateRangeSelector(
                selectedRange: _selectedRange,
                onRangeChanged: (range) {
                  setState(() {
                    _selectedRange = range;
                  });
                  // Filter data by date range
                },
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Dashboard Content with Real Data
              Consumer<TradeProvider>(
                builder: (context, tradeProvider, _) {
                  final analytics = tradeProvider.analytics;
                  final totalPnL = (analytics?['totalProfitLoss'] as num?)?.toDouble() ?? 0.0;
                  final totalTrades = (analytics?['totalTrades'] as num?)?.toInt() ?? 0;
                  final winRate = (analytics?['winRate'] as num?)?.toDouble() ?? 0.0;
                  final avgProfit = (analytics?['avgProfit'] as num?)?.toDouble() ?? 0.0;
                  final avgLoss = (analytics?['avgLoss'] as num?)?.toDouble() ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HERO: Total P&L Card (Most Dominant)
                      _HeroPnLCard(totalPnL: totalPnL),
                      const SizedBox(height: AppTheme.spaceLG),

                      // Secondary Metrics Row 1
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Total Trades',
                              value: totalTrades.toString(),
                              icon: Icons.trending_up,
                              iconColor: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceMD),
                          Expanded(
                            child: _MetricCard(
                              title: 'Win Rate',
                              value: '${winRate.toStringAsFixed(1)}%',
                              icon: Icons.percent,
                              iconColor: AppTheme.profit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceMD),

                      // Secondary Metrics Row 2
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Avg Profit',
                              numericValue: avgProfit,
                              isPnL: true,
                              icon: Icons.arrow_upward,
                              iconColor: AppTheme.profit,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceMD),
                          Expanded(
                            child: _MetricCard(
                              title: 'Avg Loss',
                              numericValue: avgLoss,
                              isPnL: true,
                              icon: Icons.arrow_downward,
                              iconColor: AppTheme.loss,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Mini Equity Curve Chart
              _EquityCurvePlaceholder(),
              const SizedBox(height: AppTheme.spaceLG),

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
              const SizedBox(height: AppTheme.spaceMD),

              // Recent Trades List
              Consumer<TradeProvider>(
                builder: (context, tradeProvider, _) {
                  final trades = tradeProvider.trades;
                  final recentTrades = trades.take(3).map((trade) {
                    return TradeModel(
                      id: trade['id'] as int?,
                      instrument: trade['instrument'] ?? '',
                      tradeType: trade['tradeType'] ?? 'BUY',
                      entryPrice: (trade['entryPrice'] as num?)?.toDouble() ?? 0.0,
                      exitPrice: (trade['exitPrice'] as num?)?.toDouble() ?? 0.0,
                      quantity: (trade['quantity'] as num?)?.toInt() ?? 0,
                      lotSize: (trade['lotSize'] as num?)?.toInt() ?? 1,
                      tradeDate: trade['tradeDate'] != null
                          ? DateTime.parse(trade['tradeDate'])
                          : DateTime.now(),
                      profitLoss: (trade['profitLoss'] as num?)?.toDouble(),
                      notes: trade['notes'],
                    );
                  }).toList();
                  
                  if (recentTrades.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(AppTheme.spaceMD),
                      decoration: AppTheme.cardDecoration,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: AppTheme.neutral500,
                            ),
                            const SizedBox(height: AppTheme.spaceSM),
                            Text(
                              'No trades yet',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: recentTrades.map((trade) => TradeCardWidget(
                      trade: trade,
                      showDeleteButton: false,
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

/// Date Range Enum
enum DateRange {
  today,
  week,
  month,
  all,
}

/// Date Range Selector Widget
class _DateRangeSelector extends StatelessWidget {
  final DateRange selectedRange;
  final Function(DateRange) onRangeChanged;

  const _DateRangeSelector({
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          _buildButton('Today', DateRange.today),
          const SizedBox(width: 4),
          _buildButton('7D', DateRange.week),
          const SizedBox(width: 4),
          _buildButton('30D', DateRange.month),
          const SizedBox(width: 4),
          _buildButton('All', DateRange.all),
        ],
      ),
    );
  }

  Widget _buildButton(String label, DateRange range) {
    final isSelected = selectedRange == range;
    return Expanded(
      child: GestureDetector(
        onTap: () => onRangeChanged(range),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.white : AppTheme.neutral700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Hero P&L Card - Most Dominant Element
class _HeroPnLCard extends StatelessWidget {
  final double totalPnL;

  const _HeroPnLCard({required this.totalPnL});

  @override
  Widget build(BuildContext context) {
    final pnlColor = AppTheme.getPnLColor(totalPnL);
    final isProfit = totalPnL >= 0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: AppTheme.cardDecorationElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total P&L',
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            _formatCurrency(totalPnL),
            style: AppTheme.heroNumber(pnlColor),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Row(
            children: [
              Icon(
                isProfit ? Icons.trending_up : Icons.trending_down,
                size: 18,
                color: pnlColor,
              ),
              const SizedBox(width: 6),
              Text(
                '${isProfit ? '+' : ''}${((totalPnL / 10000) * 100).toStringAsFixed(1)}%',
                style: AppTheme.bodySmall.copyWith(color: pnlColor),
              ),
            ],
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

/// Metric Card Widget
class _MetricCard extends StatelessWidget {
  final String title;
  final String? value;
  final double? numericValue;
  final IconData icon;
  final Color iconColor;
  final bool isPnL;

  const _MetricCard({
    required this.title,
    this.value,
    this.numericValue,
    required this.icon,
    required this.iconColor,
    this.isPnL = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? _formatNumber(numericValue);
    final textColor = isPnL
        ? AppTheme.getPnLColor(numericValue)
        : AppTheme.neutral900;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.labelMedium,
              ),
              Icon(icon, size: 20, color: iconColor),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            displayValue ?? '--',
            style: isPnL
                ? AppTheme.getPnLTextStyle(numericValue, fontSize: 22)
                : AppTheme.mediumNumber(textColor),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double? value) {
    if (value == null) return '--';
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}

/// Equity Curve Chart Placeholder
class _EquityCurvePlaceholder extends StatelessWidget {
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
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.neutral100,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppTheme.neutral500,
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  Text(
                    'Chart Placeholder',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.neutral500,
                    ),
                  ),
                  Text(
                    'Line chart will be displayed here',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Layout Logic Explanation:
/// 
/// 1. **Date Range First**: Traders filter by time period most often
///    - Quick access at top
///    - Visual toggle buttons
/// 
/// 2. **Hero P&L Card**: Largest, most prominent
///    - 36px font size (largest)
///    - Elevated shadow (stands out)
///    - Color-coded (green/red)
///    - Shows percentage change
/// 
/// 3. **Secondary Metrics**: Two rows of 2 cards each
///    - Balanced layout
///    - Quick scanning
///    - Icons for visual recognition
/// 
/// 4. **Chart**: Visual representation
///    - Helps identify trends
///    - Placeholder for now
/// 
/// 5. **Recent Trades**: Last 3-5 trades
///    - Quick access to latest activity
///    - Uses reusable TradeCard
///    - "View All" button for more
/// 
/// **UX Principles Applied:**
/// - Numbers > Text (large fonts for metrics)
/// - Important info at top (P&L first)
/// - Minimal scrolling (key info visible)
/// - One-hand usage (bottom navigation)
