import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/ai_insight_model.dart';
import 'insight_detail_screen.dart';

/// Insight Card Widget
/// Displays a single AI insight
/// Tap to view details
class InsightCardWidget extends StatelessWidget {
  final AIInsightModel insight;

  const InsightCardWidget({
    Key? key,
    required this.insight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(insight.severity);
    final icon = _getTypeIcon(insight.type);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InsightDetailScreen(insight: insight),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: AppTheme.spaceSM),
                Expanded(
                  child: Text(
                    insight.title,
                    style: AppTheme.heading3,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.neutral500,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSM),
            // Description
            Text(
              insight.description,
              style: AppTheme.bodyMedium,
            ),
            if (insight.supportingData != null) ...[
              const SizedBox(height: AppTheme.spaceSM),
              // Supporting data preview
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceSM),
                decoration: BoxDecoration(
                  color: AppTheme.neutral100,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 16,
                      color: AppTheme.neutral700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatSupportingData(insight.supportingData!),
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
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

  String _formatSupportingData(Map<String, dynamic> data) {
    if (data.containsKey('frequency')) {
      return 'Occurs ${data['frequency']}% of the time';
    }
    if (data.containsKey('avg_pnl')) {
      return 'Avg P&L: ₹${data['avg_pnl'].toStringAsFixed(2)}';
    }
    if (data.containsKey('sample_size')) {
      return 'Based on ${data['sample_size']} trades';
    }
    return 'View details for more info';
  }
}
