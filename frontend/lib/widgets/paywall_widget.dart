import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Paywall Widget
/// Reusable widget for showing upgrade prompts
/// Used when free users hit limits or try to access Pro features

/// Paywall Bottom Sheet
/// Shows upgrade prompt as bottom sheet (less intrusive)
class PaywallBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String? featureName; // e.g., "Add Trade", "Advanced Analytics"

  const PaywallBottomSheet({
    Key? key,
    required this.title,
    required this.message,
    this.featureName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icon
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: AppTheme.primary,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Title
          Text(
            title,
            style: AppTheme.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceSM),

          // Message
          Text(
            message,
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // Pro Features Preview
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: BoxDecoration(
              color: AppTheme.neutral100,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Column(
              children: [
                _FeaturePreview('Unlimited trades'),
                _FeaturePreview('Advanced analytics'),
                _FeaturePreview('Export data'),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // Upgrade Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close bottom sheet
                // Navigate to subscription plans
                Navigator.pushNamed(context, '/subscription');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Upgrade to PRO - ₹299/month'),
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe Later'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePreview extends StatelessWidget {
  final String feature;

  const _FeaturePreview(this.feature);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppTheme.profit,
          ),
          const SizedBox(width: 8),
          Text(
            feature,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Paywall Dialog
/// Shows upgrade prompt as dialog (more prominent)
class PaywallDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? featureName;

  const PaywallDialog({
    Key? key,
    required this.title,
    required this.message,
    this.featureName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: AppTheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMD),

            // Title
            Text(
              title,
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceSM),

            // Message
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Upgrade Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Navigate to subscription plans
                  Navigator.pushNamed(context, '/subscription');
                },
                child: const Text('Upgrade to PRO'),
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show paywall dialog
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? featureName,
  }) {
    showDialog(
      context: context,
      builder: (context) => PaywallDialog(
        title: title,
        message: message,
        featureName: featureName,
      ),
    );
  }
}

/// Paywall Helper Functions
class PaywallHelper {
  /// Show paywall when trade limit reached
  static void showTradeLimitReached(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaywallBottomSheet(
        title: 'Trade Limit Reached',
        message:
            'You\'ve reached the free plan limit of 10 trades. Upgrade to PRO for unlimited trades.',
        featureName: 'Add Trade',
      ),
    );
  }

  /// Show paywall for Pro feature access
  static void showProFeatureRequired(
    BuildContext context, {
    required String featureName,
  }) {
    PaywallDialog.show(
      context,
      title: 'Pro Feature',
      message: '$featureName is available for PRO users only. Upgrade to unlock this feature.',
      featureName: featureName,
    );
  }

  /// Show paywall for analytics access
  static void showAnalyticsPaywall(BuildContext context) {
    PaywallDialog.show(
      context,
      title: 'Advanced Analytics',
      message:
          'Advanced analytics and detailed charts are available for PRO users. Upgrade to unlock.',
      featureName: 'Analytics',
    );
  }
}
