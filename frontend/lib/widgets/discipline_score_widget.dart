import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/theme.dart';
import '../models/discipline_score_model.dart';

/// Discipline Score Widget
/// Circular progress indicator showing trading discipline score
/// Educational metric - not advice
class DisciplineScoreWidget extends StatelessWidget {
  final DisciplineScoreModel score;
  final double size;

  const DisciplineScoreWidget({
    Key? key,
    required this.score,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = score.score / 100.0;
    final color = _getScoreColor(score.score);

    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              backgroundColor: AppTheme.neutral300,
              valueColor: AlwaysStoppedColor<Color>(
                AppTheme.neutral300,
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedColor<Color>(color),
            ),
          ),
          // Score text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${score.score}',
                style: AppTheme.heroNumber(color).copyWith(fontSize: 48),
              ),
              Text(
                '/100',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutral700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                score.level,
                style: AppTheme.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.profit;
    if (score >= 60) return AppTheme.primary;
    if (score >= 40) return AppTheme.warning;
    return AppTheme.loss;
  }
}

/// Discipline Score Card
/// Full card with score and breakdown
class DisciplineScoreCard extends StatelessWidget {
  final DisciplineScoreModel score;

  const DisciplineScoreCard({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Title
          Text(
            'Trading Discipline Score',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'Based on your trading patterns',
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceLG),
          // Score widget
          DisciplineScoreWidget(score: score),
          const SizedBox(height: AppTheme.spaceLG),
          // Feedback
          if (score.feedback != null)
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.neutral100,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Text(
                score.feedback!,
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: AppTheme.spaceLG),
          // Factors breakdown
          if (score.factors.isNotEmpty) ...[
            Text(
              'Score Breakdown',
              style: AppTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            ...score.factors.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                child: _FactorRow(
                  label: entry.key,
                  value: entry.value,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  final String label;
  final double value;

  const _FactorRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _formatLabel(label),
            style: AppTheme.bodyMedium,
          ),
        ),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppTheme.neutral300,
            valueColor: AlwaysStoppedColor<Color>(
              _getFactorColor(value),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toInt()}',
          style: AppTheme.bodySmall,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  String _formatLabel(String label) {
    return label
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getFactorColor(double value) {
    if (value >= 80) return AppTheme.profit;
    if (value >= 60) return AppTheme.primary;
    if (value >= 40) return AppTheme.warning;
    return AppTheme.loss;
  }
}

/// Consistency Badge Widget
class ConsistencyBadgeWidget extends StatelessWidget {
  final ConsistencyLevel level;

  const ConsistencyBadgeWidget({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(level);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMD,
        vertical: AppTheme.spaceSM,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getLevelIcon(level),
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            level.label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(ConsistencyLevel level) {
    switch (level) {
      case ConsistencyLevel.excellent:
        return AppTheme.profit;
      case ConsistencyLevel.strong:
        return AppTheme.primary;
      case ConsistencyLevel.average:
        return AppTheme.warning;
      case ConsistencyLevel.poor:
        return AppTheme.loss;
    }
  }

  IconData _getLevelIcon(ConsistencyLevel level) {
    switch (level) {
      case ConsistencyLevel.excellent:
        return Icons.star;
      case ConsistencyLevel.strong:
        return Icons.trending_up;
      case ConsistencyLevel.average:
        return Icons.trending_flat;
      case ConsistencyLevel.poor:
        return Icons.trending_down;
    }
  }
}
