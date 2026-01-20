import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../screens/subscription/subscription_plans_screen.dart';
import '../theme/app_theme.dart';

/// Feature Gate Widget
/// Shows upgrade prompt for Pro features
class FeatureGateWidget extends StatelessWidget {
  final Widget child;
  final String featureName;
  final String? upgradeMessage;

  const FeatureGateWidget({
    Key? key,
    required this.child,
    required this.featureName,
    this.upgradeMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        if (subscriptionProvider.hasAccessToFeature(featureName)) {
          return child;
        }

        return _UpgradePrompt(
          featureName: featureName,
          upgradeMessage: upgradeMessage,
        );
      },
    );
  }
}

class _UpgradePrompt extends StatelessWidget {
  final String featureName;
  final String? upgradeMessage;

  const _UpgradePrompt({
    required this.featureName,
    this.upgradeMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 48,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'Pro Feature',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            upgradeMessage ?? 
            'This feature is available in Pro plan. Upgrade to unlock!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionPlansScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Upgrade to Pro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
/// FeatureGateWidget(
///   featureName: 'advanced_analytics',
///   upgradeMessage: 'Unlock advanced analytics with Pro',
///   child: AdvancedAnalyticsWidget(),
/// )
/// ```
