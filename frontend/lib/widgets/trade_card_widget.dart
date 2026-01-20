import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/trade_model.dart';
import 'package:intl/intl.dart';

/// Professional Trade Card Widget
/// Reusable card for displaying trade information
/// Mobile-optimized, touch-friendly design
class TradeCardWidget extends StatelessWidget {
  final TradeModel trade;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const TradeCardWidget({
    Key? key,
    required this.trade,
    this.onTap,
    this.onDelete,
    this.showDeleteButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pnlColor = AppTheme.getPnLColor(trade.profitLoss);
    final isProfit = trade.isProfit;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Instrument + Trade Type + P&L
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Instrument & Trade Type
                Expanded(
                  child: Row(
                    children: [
                      // Trade Type Badge
                      _TradeTypeBadge(
                        tradeType: trade.tradeType,
                      ),
                      const SizedBox(width: AppTheme.spaceSM),
                      // Instrument Name
                      Expanded(
                        child: Text(
                          trade.instrument,
                          style: AppTheme.heading3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: P&L
                if (trade.profitLoss != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isProfit ? Icons.trending_up : Icons.trending_down,
                            size: 18,
                            color: pnlColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trade.formattedPnL,
                            style: AppTheme.getPnLTextStyle(
                              trade.profitLoss,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceMD),
            
            // Price Information Row
            Row(
              children: [
                Expanded(
                  child: _PriceInfo(
                    label: 'Entry',
                    price: trade.entryPrice,
                    icon: Icons.arrow_downward,
                    iconColor: AppTheme.loss,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMD),
                Expanded(
                  child: _PriceInfo(
                    label: 'Exit',
                    price: trade.exitPrice,
                    icon: Icons.arrow_upward,
                    iconColor: AppTheme.profit,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSM),
            
            // Quantity & Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Qty: ${trade.totalQuantity}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.neutral700,
                  ),
                ),
                Text(
                  trade.formattedDate,
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            
            // Notes (if available)
            if (trade.notes != null && trade.notes!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spaceSM),
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceSM),
                decoration: BoxDecoration(
                  color: AppTheme.neutral100,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Text(
                  trade.notes!,
                  style: AppTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            
            // Delete Button (if enabled)
            if (showDeleteButton && onDelete != null) ...[
              const SizedBox(height: AppTheme.spaceSM),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppTheme.loss,
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Trade Type Badge Widget
class _TradeTypeBadge extends StatelessWidget {
  final String tradeType;

  const _TradeTypeBadge({required this.tradeType});

  @override
  Widget build(BuildContext context) {
    final isBuy = tradeType.toUpperCase() == 'BUY';
    final color = isBuy ? AppTheme.profit : AppTheme.loss;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        tradeType,
        style: TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Price Information Widget
class _PriceInfo extends StatelessWidget {
  final String label;
  final double price;
  final IconData icon;
  final Color iconColor;

  const _PriceInfo({
    required this.label,
    required this.price,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceSM),
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: AppTheme.smallNumber(AppTheme.neutral900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Usage Example:
/// 
/// ```dart
/// ListView.builder(
///   itemCount: trades.length,
///   itemBuilder: (context, index) {
///     return TradeCardWidget(
///       trade: trades[index],
///       onTap: () {
///         // Navigate to trade details
///       },
///       onDelete: () {
///         // Delete trade
///       },
///     );
///   },
/// )
/// ```
