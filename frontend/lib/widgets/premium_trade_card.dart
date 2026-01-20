import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/premium_theme.dart';

/// Premium Trade Card Widget
/// Modern card design with animations and swipe actions
class PremiumTradeCard extends StatelessWidget {
  final Map<String, dynamic> trade;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const PremiumTradeCard({
    Key? key,
    required this.trade,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    final instrument = trade['instrument'] ?? 'N/A';
    final tradeType = trade['tradeType'] ?? 'BUY';
    final quantity = trade['quantity'] ?? 0;
    final lotSize = trade['lotSize'] ?? 1;
    final entryPrice = (trade['entryPrice'] as num?)?.toDouble() ?? 0.0;
    final exitPrice = (trade['exitPrice'] as num?)?.toDouble() ?? 0.0;
    final pnl = (trade['profitLoss'] as num?)?.toDouble() ?? 0.0;
    final dateStr = trade['tradeDate'] as String?;
    
    DateTime? tradeDate;
    if (dateStr != null) {
      try {
        tradeDate = DateTime.parse(dateStr);
      } catch (e) {
        // Invalid date
      }
    }

    final isProfit = pnl > 0;
    final pnlColor = PremiumTheme.getPnLColor(pnl, brightness);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusMD),
        child: Container(
          margin: const EdgeInsets.only(bottom: PremiumTheme.spaceMD),
          padding: const EdgeInsets.all(PremiumTheme.spaceMD),
          decoration: PremiumTheme.cardDecoration(brightness),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Instrument Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: PremiumTheme.lightPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                      border: Border.all(
                        color: PremiumTheme.lightPrimary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.show_chart,
                          size: 16,
                          color: PremiumTheme.lightPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          instrument,
                          style: PremiumTheme.bodyMedium(brightness).copyWith(
                            fontWeight: FontWeight.w600,
                            color: PremiumTheme.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  
                  // Trade Type Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: tradeType == 'BUY'
                          ? PremiumTheme.lightProfit.withOpacity(0.15)
                          : PremiumTheme.lightLoss.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tradeType,
                      style: PremiumTheme.bodySmall(brightness).copyWith(
                        color: tradeType == 'BUY'
                            ? PremiumTheme.lightProfit
                            : PremiumTheme.lightLoss,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: PremiumTheme.spaceMD),
              
              // Trade Details Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity',
                          style: PremiumTheme.labelSmall(brightness),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${quantity}x${lotSize}',
                          style: PremiumTheme.bodyMedium(brightness).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entry',
                          style: PremiumTheme.labelSmall(brightness),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${entryPrice.toStringAsFixed(2)}',
                          style: PremiumTheme.bodyMedium(brightness).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exit',
                          style: PremiumTheme.labelSmall(brightness),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${exitPrice.toStringAsFixed(2)}',
                          style: PremiumTheme.bodyMedium(brightness).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: PremiumTheme.spaceMD),
              
              // P&L & Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  if (tradeDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: brightness == Brightness.light
                              ? PremiumTheme.lightTextTertiary
                              : PremiumTheme.darkTextTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(tradeDate),
                          style: PremiumTheme.bodySmall(brightness),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  
                  // P&L
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: pnlColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isProfit ? Icons.trending_up : Icons.trending_down,
                              size: 16,
                              color: pnlColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '₹${pnl.abs().toStringAsFixed(2)}',
                              style: PremiumTheme.getPnLTextStyle(
                                pnl,
                                brightness,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onDelete != null) ...[
                        const SizedBox(width: PremiumTheme.spaceSM),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: PremiumTheme.lightLoss,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onDelete,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
