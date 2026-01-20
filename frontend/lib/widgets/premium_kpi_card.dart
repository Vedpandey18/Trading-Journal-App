import 'package:flutter/material.dart';
import '../theme/premium_theme.dart';

/// Premium Glassmorphic KPI Card Widget
/// Displays key performance indicators with glassmorphism, animations, and gradient accents
class PremiumKPICard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onTap;

  const PremiumKPICard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  State<PremiumKPICard> createState() => _PremiumKPICardState();
}

class _PremiumKPICardState extends State<PremiumKPICard> {
  @override
  Widget build(BuildContext context) {
    // Use dark mode only as per requirements
    final effectiveBrightness = Brightness.dark;
    
    final cardColor = widget.color ?? PremiumTheme.darkPrimary;
    final iconBgColor = widget.iconColor ?? cardColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusLG),
        child: Container(
          padding: const EdgeInsets.all(PremiumTheme.spaceLG),
          decoration: PremiumTheme.glassmorphicCard(
            effectiveBrightness,
            gradientColor: cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with gradient background
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconBgColor.withOpacity(0.2),
                      iconBgColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                  border: Border.all(
                    color: iconBgColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: iconBgColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: PremiumTheme.spaceMD),
              
              // Value with large typography
              Text(
                widget.value,
                style: PremiumTheme.heroNumber(
                  PremiumTheme.darkTextPrimary,
                  effectiveBrightness,
                ).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: PremiumTheme.spaceXS),
              
              // Title with muted color
              Text(
                widget.title,
                style: PremiumTheme.labelMedium(effectiveBrightness).copyWith(
                  color: PremiumTheme.darkTextSecondary,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// P&L KPI Card (Special variant with color coding and gradient accent)
class PremiumPnLKPICard extends StatefulWidget {
  final String title;
  final double? value;
  final IconData icon;
  final VoidCallback? onTap;

  const PremiumPnLKPICard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  State<PremiumPnLKPICard> createState() => _PremiumPnLKPICardState();
}

class _PremiumPnLKPICardState extends State<PremiumPnLKPICard> {
  @override
  Widget build(BuildContext context) {
    // Use dark mode only as per requirements
    final effectiveBrightness = Brightness.dark;
    
    final pnlColor = PremiumTheme.getPnLColor(widget.value, effectiveBrightness);
    final formattedValue = widget.value != null
        ? '₹${widget.value!.toStringAsFixed(2)}'
        : '₹0.00';
    
    // Determine gradient based on P&L
    final isProfit = widget.value != null && widget.value! > 0;
    final isLoss = widget.value != null && widget.value! < 0;
    final accentColor = isProfit
        ? PremiumTheme.darkProfit
        : isLoss
            ? PremiumTheme.darkLoss
            : PremiumTheme.darkPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusLG),
        child: Container(
          padding: const EdgeInsets.all(PremiumTheme.spaceLG),
          decoration: PremiumTheme.glassmorphicCardWithAccent(
            effectiveBrightness,
            accentColor,
            topAccent: true,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with gradient background
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      pnlColor.withOpacity(0.2),
                      pnlColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                  border: Border.all(
                    color: pnlColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: pnlColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: PremiumTheme.spaceMD),
              
              // Value with color-coded typography
              Text(
                formattedValue,
                style: PremiumTheme.heroNumber(
                  pnlColor,
                  effectiveBrightness,
                ).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  shadows: [
                    Shadow(
                      color: pnlColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: PremiumTheme.spaceXS),
              
              // Title with muted color
              Text(
                widget.title,
                style: PremiumTheme.labelMedium(effectiveBrightness).copyWith(
                  color: PremiumTheme.darkTextSecondary,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
