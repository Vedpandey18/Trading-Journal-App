import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/discipline_score_model.dart';
import '../../models/ai_insight_model.dart';
import '../../models/time_performance_model.dart';
import '../../models/emotion_stats_model.dart';
import '../../widgets/discipline_score_widget.dart';
import 'insight_card_widget.dart';
import 'time_analysis_widget.dart';
import 'emotion_summary_widget.dart';

/// AI Insights Dashboard Screen
/// Main screen for AI-powered trading insights
/// Educational and descriptive only - no advice
class AIInsightsDashboardScreen extends StatefulWidget {
  const AIInsightsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AIInsightsDashboardScreen> createState() =>
      _AIInsightsDashboardScreenState();
}

class _AIInsightsDashboardScreenState extends State<AIInsightsDashboardScreen> {
  // Mock data - will be replaced with API
  final DisciplineScoreModel _disciplineScore = DisciplineScoreModel(
    score: 72,
    level: 'Good',
    factors: {
      'risk_management': 75.0,
      'consistency': 68.0,
      'emotional_control': 70.0,
      'position_sizing': 80.0,
    },
    feedback: 'You show good discipline in position sizing. Consider working on consistency.',
  );

  final ConsistencyLevel _consistencyLevel = ConsistencyLevel.strong;

  final List<AIInsightModel> _insights = [
    AIInsightModel(
      id: '1',
      title: 'Loss Pattern Detected',
      description: 'Most losses occur after 2 consecutive wins',
      type: InsightType.pattern,
      severity: InsightSeverity.warning,
      supportingData: {'frequency': 65, 'sample_size': 20},
    ),
    AIInsightModel(
      id: '2',
      title: 'Time-Based Pattern',
      description: 'Highest profit observed between 10 AM - 12 PM',
      type: InsightType.timing,
      severity: InsightSeverity.positive,
      supportingData: {'hour': '10-12', 'avg_pnl': 850.50},
    ),
    AIInsightModel(
      id: '3',
      title: 'Instrument Analysis',
      description: 'NIFTY shows highest average profit per trade',
      type: InsightType.instrument,
      severity: InsightSeverity.positive,
      supportingData: {'instrument': 'NIFTY', 'avg_pnl': 1200.00},
    ),
    AIInsightModel(
      id: '4',
      title: 'Overtrading Detected',
      description: 'Performance decreases after 3+ trades per day',
      type: InsightType.psychology,
      severity: InsightSeverity.critical,
      supportingData: {'threshold': 3, 'avg_pnl_after': -250.00},
    ),
  ];

  final TimePerformanceModel _timePerformance = TimePerformanceModel(
    hourlyPnL: {
      '9': 200.0,
      '10': 850.0,
      '11': 750.0,
      '12': 500.0,
      '13': -100.0,
      '14': 300.0,
      '15': -200.0,
    },
    bestHour: '10',
    worstHour: '15',
    hourlyTradeCount: {
      '9': 5,
      '10': 8,
      '11': 6,
      '12': 4,
      '13': 3,
      '14': 4,
      '15': 2,
    },
  );

  final EmotionStatsModel _emotionStats = EmotionStatsModel(
    emotionCounts: {
      'calm': 15,
      'confident': 12,
      'fear': 8,
      'greed': 5,
      'revenge': 3,
    },
    emotionPnL: {
      'calm': 850.0,
      'confident': 600.0,
      'fear': -200.0,
      'greed': -150.0,
      'revenge': -400.0,
    },
    dominantEmotion: 'calm',
    mostProfitableEmotion: 'calm',
    leastProfitableEmotion: 'revenge',
  );

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
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer Banner
              _DisclaimerBanner(),
              const SizedBox(height: AppTheme.spaceLG),

              // Discipline Score Card
              DisciplineScoreCard(score: _disciplineScore),
              const SizedBox(height: AppTheme.spaceLG),

              // Consistency Badge
              Center(
                child: ConsistencyBadgeWidget(level: _consistencyLevel),
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Time-Based Insights
              TimeAnalysisWidget(timePerformance: _timePerformance),
              const SizedBox(height: AppTheme.spaceLG),

              // Emotion Summary
              EmotionSummaryWidget(emotionStats: _emotionStats),
              const SizedBox(height: AppTheme.spaceLG),

              // Insights Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Key Insights',
                    style: AppTheme.heading2,
                  ),
                  TextButton(
                    onPressed: () {
                      // View all insights
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),

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
    // Refresh insights from API
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showDisclaimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Insights'),
        content: const Text(
          'AI Insights analyze your past trading data to identify patterns and behaviors.\n\n'
          'These insights are:\n'
          '• Descriptive (show what happened)\n'
          '• Educational (help you understand yourself)\n'
          '• For self-analysis only\n\n'
          'They do NOT provide:\n'
          '• Trading advice\n'
          '• Predictions\n'
          '• Buy/sell signals\n\n'
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

/// Disclaimer Banner
class _DisclaimerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.info),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.info, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Insights are based on past data and for self-analysis only. '
              'Not financial advice.',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.info,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
