import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/ai_insight_model.dart';

/// Insight Detail Screen
/// Shows detailed view of a single insight
/// Includes explanation, stats, and chart placeholder
class InsightDetailScreen extends StatelessWidget {
  final AIInsightModel insight;

  const InsightDetailScreen({
    Key? key,
    required this.insight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Insight Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Insight Header
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(insight.severity)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getTypeIcon(insight.type),
                          color: _getSeverityColor(insight.severity),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceMD),
                      Expanded(
                        child: Text(
                          insight.title,
                          style: AppTheme.heading2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  Text(
                    insight.description,
                    style: AppTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Disclaimer
            Container(
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
                      'This insight describes patterns in your past trades. '
                      'It is not advice or a prediction.',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Supporting Data
            if (insight.supportingData != null) ...[
              Text(
                'Supporting Data',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: insight.supportingData!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatKey(entry.key),
                            style: AppTheme.bodyMedium,
                          ),
                          Text(
                            _formatValue(entry.value),
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLG),
            ],

            // Chart Placeholder
            Text(
              'Visualization',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              height: 200,
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: AppTheme.cardDecoration,
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
                      'Visual representation will be displayed here',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // What This Means
            Text(
              'What This Means',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: AppTheme.cardDecoration,
              child: Text(
                _getExplanation(insight),
                style: AppTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.positive:
        return AppTheme.profit;
      case InsightSeverity.neutral:
        return AppTheme.primary;
      case InsightSeverity.warning:
        return AppTheme.warning;
      case InsightSeverity.critical:
        return AppTheme.loss;
    }
  }

  IconData _getTypeIcon(InsightType type) {
    switch (type) {
      case InsightType.pattern:
        return Icons.timeline;
      case InsightType.timing:
        return Icons.access_time;
      case InsightType.instrument:
        return Icons.trending_up;
      case InsightType.psychology:
        return Icons.psychology;
      case InsightType.consistency:
        return Icons.assessment;
    }
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is num) {
      if (value is double && value.toString().contains('.')) {
        return value.toStringAsFixed(2);
      }
      return value.toString();
    }
    return value.toString();
  }

  String _getExplanation(AIInsightModel insight) {
    // Educational explanation based on insight type
    switch (insight.type) {
      case InsightType.pattern:
        return 'This pattern shows a recurring behavior in your trading. '
            'Understanding these patterns can help you become more self-aware '
            'and make more conscious trading decisions.';
      case InsightType.timing:
        return 'This shows when you tend to perform better or worse. '
            'This is descriptive information about your past performance, '
            'not a recommendation of when to trade.';
      case InsightType.instrument:
        return 'This shows which instruments have been more or less profitable '
            'in your past trades. Use this for self-reflection, not as '
            'advice on what to trade.';
      case InsightType.psychology:
        return 'This insight relates to emotional patterns in your trading. '
            'Understanding your emotional state can help improve discipline, '
            'but this is not psychological advice.';
      case InsightType.consistency:
        return 'This measures how consistent your trading performance has been. '
            'Higher consistency often correlates with better discipline, '
            'but this is not a guarantee of future performance.';
    }
  }
}
