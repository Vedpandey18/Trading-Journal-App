import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/indian_trade_model.dart';
import '../../models/exchange_model.dart';
import '../../widgets/summary_card.dart';

/// Indian Market Dashboard Screen
/// Shows India-specific metrics: BTC P&L, Gold P&L, Exchange-wise performance
class IndianDashboardScreen extends StatefulWidget {
  const IndianDashboardScreen({Key? key}) : super(key: key);

  @override
  State<IndianDashboardScreen> createState() => _IndianDashboardScreenState();
}

class _IndianDashboardScreenState extends State<IndianDashboardScreen> {
  // Mock data - will be replaced with API
  final double _totalPnL = 12500.50;
  final double _btcPnL = 8500.25;
  final double _goldPnL = 4000.25;
  final int _totalTrades = 45;
  final double _winRate = 68.9;

  // Exchange-wise P&L
  final Map<String, double> _exchangeWisePnL = {
    'WazirX': 4500.00,
    'CoinDCX': 4000.25,
    'MCX': 4000.25,
    'Zerodha': 0.0, // No trades yet
  };

  // Asset distribution
  final Map<AssetType, int> _assetDistribution = {
    AssetType.btc: 25,
    AssetType.gold: 20,
  };

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
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer Banner
              _IndiaDisclaimerBanner(),
              const SizedBox(height: AppTheme.spaceLG),

              // HERO: Total P&L
              _HeroPnLCard(totalPnL: _totalPnL),
              const SizedBox(height: AppTheme.spaceLG),

              // Asset-wise P&L Row
              Row(
                children: [
                  Expanded(
                    child: _AssetPnLCard(
                      asset: 'BTC',
                      pnl: _btcPnL,
                      icon: Icons.currency_bitcoin,
                      color: AppTheme.warning,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: _AssetPnLCard(
                      asset: 'Gold',
                      pnl: _goldPnL,
                      icon: Icons.monetization_on,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Exchange-wise Performance
              Text(
                'Exchange-wise Performance',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spaceSM),
              Text(
                'Your performance across different exchanges and brokers',
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              ..._exchangeWisePnL.entries.map((entry) {
                return _ExchangePerformanceCard(
                  exchange: entry.key,
                  pnl: entry.value,
                );
              }),
              const SizedBox(height: AppTheme.spaceLG),

              // Asset Distribution
              Text(
                'Asset Distribution',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    _AssetDistributionRow(
                      asset: 'BTC',
                      count: _assetDistribution[AssetType.btc] ?? 0,
                      total: _totalTrades,
                      icon: Icons.currency_bitcoin,
                    ),
                    const Divider(),
                    _AssetDistributionRow(
                      asset: 'Gold',
                      count: _assetDistribution[AssetType.gold] ?? 0,
                      total: _totalTrades,
                      icon: Icons.monetization_on,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Summary Metrics
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Trades',
                      value: _totalTrades.toString(),
                      icon: Icons.trending_up,
                      iconColor: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: SummaryCard(
                      title: 'Win Rate',
                      value: '${_winRate.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      iconColor: AppTheme.profit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Refresh from API
    await Future.delayed(const Duration(seconds: 1));
  }
}

/// Disclaimer Banner for Indian Market
class _IndiaDisclaimerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.info),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.info, size: 20),
              const SizedBox(width: 8),
              Text(
                'Important Disclaimer',
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'This app does not provide investment advice. All analytics are based on '
            'historical trades. Crypto trading involves significant risk. '
            'Past performance does not guarantee future results.',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.info,
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero P&L Card
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
                'All Assets Combined',
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

/// Asset P&L Card
class _AssetPnLCard extends StatelessWidget {
  final String asset;
  final double pnl;
  final IconData icon;
  final Color color;

  const _AssetPnLCard({
    required this.asset,
    required this.pnl,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pnlColor = AppTheme.getPnLColor(pnl);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                '$asset P&L',
                style: AppTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            _formatCurrency(pnl),
            style: AppTheme.getPnLTextStyle(pnl, fontSize: 22),
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

/// Exchange Performance Card
class _ExchangePerformanceCard extends StatelessWidget {
  final String exchange;
  final double pnl;

  const _ExchangePerformanceCard({
    required this.exchange,
    required this.pnl,
  });

  @override
  Widget build(BuildContext context) {
    final pnlColor = AppTheme.getPnLColor(pnl);
    final hasTrades = pnl != 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exchange,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!hasTrades)
                    Text(
                      'No trades yet',
                      style: AppTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
          if (hasTrades)
            Text(
              _formatCurrency(pnl),
              style: AppTheme.getPnLTextStyle(pnl, fontSize: 18),
            )
          else
            Text(
              '--',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutral500,
              ),
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

/// Asset Distribution Row
class _AssetDistributionRow extends StatelessWidget {
  final String asset;
  final int count;
  final int total;
  final IconData icon;

  const _AssetDistributionRow({
    required this.asset,
    required this.count,
    required this.total,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSM),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(width: AppTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset,
                  style: AppTheme.bodyLarge,
                ),
                Text(
                  '$count trades (${percentage.toStringAsFixed(1)}%)',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.neutral300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
