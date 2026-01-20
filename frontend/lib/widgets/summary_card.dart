import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Professional Summary Card Widget
/// Used for displaying key metrics (P&L, Trades, Win Rate, etc.)
class SummaryCard extends StatelessWidget {
  final String title;
  final String? value;
  final double? numericValue; // For P&L calculations
  final IconData? icon;
  final Color? iconColor;
  final bool isPnL; // If true, applies P&L color rules
  final VoidCallback? onTap;

  const SummaryCard({
    Key? key,
    required this.title,
    this.value,
    this.numericValue,
    this.icon,
    this.iconColor,
    this.isPnL = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? _formatNumber(numericValue);
    final textColor = isPnL ? AppTheme.getPnLColor(numericValue) : AppTheme.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppTheme.cardPadding,
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTheme.labelMedium,
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? AppTheme.textSecondary,
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSM),
            // Value
            Text(
              displayValue ?? '--',
              style: isPnL
                  ? AppTheme.getPnLTextStyle(numericValue, fontSize: 24)
                  : AppTheme.numberMedium.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double? value) {
    if (value == null) return '--';
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}
