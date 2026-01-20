import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

/// Professional Trade Card Widget
/// Displays individual trade information in a clean card format
class TradeCard extends StatelessWidget {
  final String instrument;
  final String tradeType; // "BUY" or "SELL"
  final double entryPrice;
  final double exitPrice;
  final int quantity;
  final int? lotSize;
  final double? profitLoss;
  final DateTime tradeDate;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TradeCard({
    Key? key,
    required this.instrument,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.quantity,
    this.lotSize,
    this.profitLoss,
    required this.tradeDate,
    this.notes,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalQty = quantity * (lotSize ?? 1);
    final isProfit = profitLoss != null && profitLoss! > 0;
    final pnlColor = AppTheme.getPnLColor(profitLoss);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMD),
        padding: AppTheme.cardPadding,
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Instrument + Trade Type + P&L
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Instrument & Trade Type
                Expanded(
                  child: Row(
                    children: [
                      // Trade Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tradeType == 'BUY'
                              ? AppTheme.profitGreen.withOpacity(0.1)
                              : AppTheme.lossRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tradeType,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tradeType == 'BUY'
                                ? AppTheme.profitGreen
                                : AppTheme.lossRed,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      // Instrument Name
                      Expanded(
                        child: Text(
                          instrument,
                          style: AppTheme.heading3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // P&L
                if (profitLoss != null)
                  Text(
                    _formatPnL(profitLoss!),
                    style: AppTheme.getPnLTextStyle(profitLoss, fontSize: 18),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            // Price Row
            Row(
              children: [
                Expanded(
                  child: _PriceInfo(
                    label: 'Entry',
                    price: entryPrice,
                    icon: Icons.arrow_downward,
                    iconColor: AppTheme.lossRed,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: _PriceInfo(
                    label: 'Exit',
                    price: exitPrice,
                    icon: Icons.arrow_upward,
                    iconColor: AppTheme.profitGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSM),
            // Quantity & Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Qty: $totalQty',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(tradeDate),
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            // Notes (if available)
            if (notes != null && notes!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingSM),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notes!,
                  style: AppTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            // Delete Button (if provided)
            if (onDelete != null) ...[
              const SizedBox(height: AppTheme.spacingSM),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppTheme.lossRed,
                  onPressed: onDelete,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatPnL(double value) {
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}

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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.labelSmall,
                ),
                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: AppTheme.numberSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
