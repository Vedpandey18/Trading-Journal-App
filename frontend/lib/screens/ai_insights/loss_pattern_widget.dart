import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/ai_insight_model.dart';

/// Loss Pattern Widget
/// Displays loss pattern insights
/// Educational - shows patterns, not advice
class LossPatternWidget extends StatelessWidget {
  final List<AIInsightModel> lossPatterns;

  const LossPatternWidget({
    Key? key,
    required this.lossPatterns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loss Patterns',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Patterns observed in your losing trades',
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          ...lossPatterns.map((pattern) => _LossPatternCard(pattern)),
        ],
      ),
    );
  }
}

class _LossPatternCard extends StatelessWidget {
  final AIInsightModel pattern;

  const _LossPatternCard(this.pattern);

  @override
  Widget build(BuildContext context) {
    final isCritical = pattern.severity == InsightSeverity.critical;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: isCritical
            ? AppTheme.loss.withOpacity(0.05)
            : AppTheme.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: isCritical ? AppTheme.loss : AppTheme.warning,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCritical ? Icons.warning : Icons.info_outline,
                size: 20,
                color: isCritical ? AppTheme.loss : AppTheme.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pattern.title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCritical ? AppTheme.loss : AppTheme.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            pattern.description,
            style: AppTheme.bodyMedium,
          ),
          if (pattern.supportingData != null) ...[
            const SizedBox(height: AppTheme.spaceSM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceSM),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(6),
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
                    _formatData(pattern.supportingData!),
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatData(Map<String, dynamic> data) {
    if (data.containsKey('frequency')) {
      return 'Observed ${data['frequency']}% of the time';
    }
    if (data.containsKey('sample_size')) {
      return 'Based on ${data['sample_size']} losing trades';
    }
    return 'View details for more information';
  }
}
