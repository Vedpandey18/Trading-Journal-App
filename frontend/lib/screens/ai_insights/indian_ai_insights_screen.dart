import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/ai_insight_model.dart';
import '../../models/exchange_model.dart';
import '../../models/indian_trade_model.dart';
import 'insight_card_widget.dart';

/// Indian Market AI Insights Screen
/// India-specific insights: BTC vs Gold, Exchange performance, etc.
/// Descriptive only - no advice
class IndianAIInsightsScreen extends StatefulWidget {
  const IndianAIInsightsScreen({Key? key}) : super(key: key);

  @override
  State<IndianAIInsightsScreen> createState() => _IndianAIInsightsScreenState();
}

class _IndianAIInsightsScreenState extends State<IndianAIInsightsScreen> {
  // Mock insights - will be replaced with API
  final List<AIInsightModel> _insights = [
    AIInsightModel(
      id: '1',
      title: 'Asset Volatility Comparison',
      description: 'Your BTC trades show higher volatility than Gold trades',
      type: InsightType.pattern,
      severity: InsightSeverity.neutral,
      supportingData: {
        'btc_volatility': 15.5,
        'gold_volatility': 8.2,
        'sample_size': 45,
      },
    ),
    AIInsightModel(
      id: '2',
      title: 'Exchange Performance',
      description: 'Most profitable exchange for BTC (based on your data): WazirX',
      type: InsightType.instrument,
      severity: InsightSeverity.positive,
      supportingData: {
        'exchange': 'WazirX',
        'avg_pnl': 4500.00,
        'trade_count': 15,
      },
    ),
    AIInsightModel(
      id: '3',
      title: 'Consistency Analysis',
      description: 'Gold trades show better consistency in your portfolio',
      type: InsightType.consistency,
      severity: InsightSeverity.positive,
      supportingData: {
        'gold_consistency': 75.0,
        'btc_consistency': 60.0,
      },
    ),
    AIInsightModel(
      id: '4',
      title: 'Overtrading Pattern',
      description: 'Overtrading detected on crypto exchanges',
      type: InsightType.psychology,
      severity: InsightSeverity.warning,
      supportingData: {
        'threshold': 3,
        'avg_trades_per_day': 4.5,
        'performance_impact': -12.5,
      },
    ),
    AIInsightModel(
      id: '5',
      title: 'Time-Based Pattern (BTC)',
      description: 'Weekend BTC trades show different performance than weekday trades',
      type: InsightType.timing,
      severity: InsightSeverity.neutral,
      supportingData: {
        'weekend_avg_pnl': 850.00,
        'weekday_avg_pnl': 1200.00,
      },
    ),
    AIInsightModel(
      id: '6',
      title: 'MCX Gold Session Performance',
      description: 'MCX Gold trades during market hours show consistent performance',
      type: InsightType.timing,
      severity: InsightSeverity.positive,
      supportingData: {
        'market_hours_pnl': 3500.00,
        'after_hours_pnl': 500.00,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('AI Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDisclaimer,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshInsights,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer Banner
              _IndiaInsightsDisclaimer(),
              const SizedBox(height: AppTheme.spaceLG),

              // Insights Header
              Text(
                'Trading Insights',
                style: AppTheme.heading2,
              ),
              const SizedBox(height: AppTheme.spaceSM),
              Text(
                'Patterns observed in your historical trades. '
                'For self-analysis only - not investment advice.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutral700,
                ),
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Insights List
              ..._insights.map((insight) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceMD),
                    child: InsightCardWidget(insight: insight),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshInsights() async {
    // Refresh from API
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showDisclaimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Insights'),
        content: const Text(
          'AI Insights analyze your past trading data to identify patterns.\n\n'
          'These insights are:\n'
          '• Descriptive (show what happened)\n'
          '• Educational (help you understand yourself)\n'
          '• For self-analysis only\n\n'
          'They do NOT provide:\n'
          '• Trading advice\n'
          '• Predictions\n'
          '• Buy/sell signals\n'
          '• Exchange recommendations\n\n'
          'Use insights to improve your self-awareness and trading discipline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}

/// India-Specific Insights Disclaimer
class _IndiaInsightsDisclaimer extends StatelessWidget {
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
                'Important',
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'All insights are based on your historical trades only. '
            'They describe past patterns, not future outcomes. '
            'This is not investment advice. Crypto trading involves significant risk.',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.info,
            ),
          ),
        ],
      ),
    );
  }
}
