import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/time_performance_model.dart';
import '../../models/instrument_performance_model.dart';

/// Time Analysis Widget
/// Shows performance by time of day
/// Descriptive only - shows patterns
class TimeAnalysisWidget extends StatelessWidget {
  final TimePerformanceModel timePerformance;

  const TimeAnalysisWidget({
    Key? key,
    required this.timePerformance,
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
            'Time-Based Performance',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Your performance patterns by time of day',
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          // Best/Worst Hour
          Row(
            children: [
              if (timePerformance.bestHour != null)
                Expanded(
                  child: _TimeCard(
                    label: 'Best Hour',
                    hour: timePerformance.bestHour!,
                    pnl: timePerformance.hourlyPnL[timePerformance.bestHour] ?? 0.0,
                    isPositive: true,
                  ),
                ),
              if (timePerformance.bestHour != null &&
                  timePerformance.worstHour != null)
                const SizedBox(width: AppTheme.spaceMD),
              if (timePerformance.worstHour != null)
                Expanded(
                  child: _TimeCard(
                    label: 'Worst Hour',
                    hour: timePerformance.worstHour!,
                    pnl: timePerformance.hourlyPnL[timePerformance.worstHour] ?? 0.0,
                    isPositive: false,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          // Hourly breakdown
          Text(
            'Hourly Breakdown',
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          ...timePerformance.hourlyPnL.entries.map((entry) {
            return _HourlyRow(
              hour: entry.key,
              pnl: entry.value,
              tradeCount: timePerformance.hourlyTradeCount[entry.key] ?? 0,
            );
          }),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final String hour;
  final double pnl;
  final bool isPositive;

  const _TimeCard({
    required this.label,
    required this.hour,
    required this.pnl,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppTheme.profit : AppTheme.loss;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
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
            style: AppTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${hour}:00',
            style: AppTheme.heading3,
          ),
          Text(
            '₹${pnl.toStringAsFixed(0)}',
            style: AppTheme.smallNumber(color),
          ),
        ],
      ),
    );
  }
}

class _HourlyRow extends StatelessWidget {
  final String hour;
  final double pnl;
  final int tradeCount;

  const _HourlyRow({
    required this.hour,
    required this.pnl,
    required this.tradeCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = pnl >= 0 ? AppTheme.profit : AppTheme.loss;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '${hour}:00',
              style: AppTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.neutral300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (pnl.abs() / 1000).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '₹${pnl.toStringAsFixed(0)}',
              style: AppTheme.bodySmall.copyWith(color: color),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '($tradeCount)',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Instrument Analysis Widget
class InstrumentAnalysisWidget extends StatelessWidget {
  final InstrumentPerformanceModel instrumentPerformance;

  const InstrumentAnalysisWidget({
    Key? key,
    required this.instrumentPerformance,
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
            'Instrument Performance',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Your performance by instrument',
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          // Best/Worst Instrument
          if (instrumentPerformance.bestInstrument != null ||
              instrumentPerformance.worstInstrument != null)
            Row(
              children: [
                if (instrumentPerformance.bestInstrument != null)
                  Expanded(
                    child: _InstrumentCard(
                      label: 'Best',
                      instrument: instrumentPerformance.bestInstrument!,
                      pnl: instrumentPerformance
                              .instrumentPnL[instrumentPerformance.bestInstrument] ??
                          0.0,
                      isPositive: true,
                    ),
                  ),
                if (instrumentPerformance.bestInstrument != null &&
                    instrumentPerformance.worstInstrument != null)
                  const SizedBox(width: AppTheme.spaceMD),
                if (instrumentPerformance.worstInstrument != null)
                  Expanded(
                    child: _InstrumentCard(
                      label: 'Worst',
                      instrument: instrumentPerformance.worstInstrument!,
                      pnl: instrumentPerformance
                              .instrumentPnL[instrumentPerformance.worstInstrument] ??
                          0.0,
                      isPositive: false,
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppTheme.spaceMD),
          // Instrument list
          ...instrumentPerformance.instrumentPnL.entries.map((entry) {
            return _InstrumentRow(
              instrument: entry.key,
              pnl: entry.value,
              tradeCount:
                  instrumentPerformance.instrumentTradeCount[entry.key] ?? 0,
            );
          }),
        ],
      ),
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  final String label;
  final String instrument;
  final double pnl;
  final bool isPositive;

  const _InstrumentCard({
    required this.label,
    required this.instrument,
    required this.pnl,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppTheme.profit : AppTheme.loss;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
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
            style: AppTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Text(
            instrument,
            style: AppTheme.heading3,
          ),
          Text(
            '₹${pnl.toStringAsFixed(0)}',
            style: AppTheme.smallNumber(color),
          ),
        ],
      ),
    );
  }
}

class _InstrumentRow extends StatelessWidget {
  final String instrument;
  final double pnl;
  final int tradeCount;

  const _InstrumentRow({
    required this.instrument,
    required this.pnl,
    required this.tradeCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = pnl >= 0 ? AppTheme.profit : AppTheme.loss;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            instrument,
            style: AppTheme.bodyMedium,
          ),
          Row(
            children: [
              Text(
                '₹${pnl.toStringAsFixed(0)}',
                style: AppTheme.bodyMedium.copyWith(color: color),
              ),
              const SizedBox(width: 8),
              Text(
                '($tradeCount trades)',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
