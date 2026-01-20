import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/emotion_stats_model.dart';
import '../../models/emotion_stats_model.dart' as emotion;

/// Emotion Summary Widget
/// Shows emotional state analysis
/// For self-awareness and pattern recognition
class EmotionSummaryWidget extends StatelessWidget {
  final EmotionStatsModel emotionStats;

  const EmotionSummaryWidget({
    Key? key,
    required this.emotionStats,
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
            'Emotional Patterns',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Your emotional states during trades',
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          // Dominant emotion
          if (emotionStats.dominantEmotion != null)
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Row(
                children: [
                  Text(
                    'Most Common: ',
                    style: AppTheme.labelMedium,
                  ),
                  Text(
                    emotionStats.dominantEmotion!.toUpperCase(),
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          // Emotion chips
          Wrap(
            spacing: AppTheme.spaceSM,
            runSpacing: AppTheme.spaceSM,
            children: emotionStats.emotionCounts.entries.map((entry) {
              return _EmotionChip(
                emotion: entry.key,
                count: entry.value,
                avgPnL: emotionStats.emotionPnL[entry.key] ?? 0.0,
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          // Most/Least Profitable
          if (emotionStats.mostProfitableEmotion != null &&
              emotionStats.leastProfitableEmotion != null)
            Row(
              children: [
                Expanded(
                  child: _ProfitableEmotionCard(
                    label: 'Most Profitable',
                    emotion: emotionStats.mostProfitableEmotion!,
                    pnl: emotionStats.emotionPnL[emotionStats.mostProfitableEmotion] ?? 0.0,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSM),
                Expanded(
                  child: _ProfitableEmotionCard(
                    label: 'Least Profitable',
                    emotion: emotionStats.leastProfitableEmotion!,
                    pnl: emotionStats.emotionPnL[emotionStats.leastProfitableEmotion] ?? 0.0,
                    isPositive: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  final String emotion;
  final int count;
  final double avgPnL;

  const _EmotionChip({
    required this.emotion,
    required this.count,
    required this.avgPnL,
  });

  @override
  Widget build(BuildContext context) {
    final emotionType = _getEmotionType(emotion);
    final color = avgPnL >= 0 ? AppTheme.profit : AppTheme.loss;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emotionType.emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            emotionType.label,
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '($count)',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.neutral700,
            ),
          ),
        ],
      ),
    );
  }

  EmotionType _getEmotionType(String emotion) {
    return EmotionType.values.firstWhere(
      (e) => e.toString().split('.').last == emotion.toLowerCase(),
      orElse: () => EmotionType.calm,
    );
  }
}

class _ProfitableEmotionCard extends StatelessWidget {
  final String label;
  final String emotion;
  final double pnl;
  final bool isPositive;

  const _ProfitableEmotionCard({
    required this.label,
    required this.emotion,
    required this.pnl,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppTheme.profit : AppTheme.loss;
    final emotionType = _getEmotionType(emotion);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceSM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                emotionType.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  emotionType.label,
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            '₹${pnl.toStringAsFixed(0)}',
            style: AppTheme.smallNumber(color),
          ),
        ],
      ),
    );
  }

  EmotionType _getEmotionType(String emotion) {
    return EmotionType.values.firstWhere(
      (e) => e.toString().split('.').last == emotion.toLowerCase(),
      orElse: () => EmotionType.calm,
    );
  }
}
