import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/auth_provider.dart';
import '../subscription/subscription_plans_screen.dart';
import '../auth/login_screen.dart';

/// Profile & Settings Screen
/// Updated to show subscription status and management
class ProfileScreenV2 extends StatefulWidget {
  const ProfileScreenV2({Key? key}) : super(key: key);

  @override
  State<ProfileScreenV2> createState() => _ProfileScreenV2State();
}

class _ProfileScreenV2State extends State<ProfileScreenV2> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final user = authProvider.user;
    final username = user?['username'] ?? 'User';
    final email = user?['email'] ?? '';
    final isPro = subscriptionProvider.isProUser;
    final subscription = subscriptionProvider.subscription;

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          children: [
            // User Info Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        username[0].toUpperCase(),
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  Text(
                    username,
                    style: AppTheme.heading2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.neutral700,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  // Plan Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isPro
                          ? AppTheme.profit.withOpacity(0.1)
                          : AppTheme.neutral500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isPro ? AppTheme.profit : AppTheme.neutral500,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPro ? Icons.star : Icons.star_border,
                          size: 16,
                          color: isPro ? AppTheme.profit : AppTheme.neutral500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subscriptionProvider.planType,
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isPro ? AppTheme.profit : AppTheme.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Subscription Status Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscription',
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  if (isPro) ...[
                    // PRO User
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.profit),
                        const SizedBox(width: 8),
                        Text(
                          'PRO Subscription Active',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.profit,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (subscription?.endDate != null) ...[
                      const SizedBox(height: AppTheme.spaceSM),
                      Text(
                        'Renews on: ${DateFormat('MMM dd, yyyy').format(subscription!.endDate!)}',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: AppTheme.spaceMD),
                    OutlinedButton(
                      onPressed: () {
                        // Manage subscription
                        _showManageSubscription();
                      },
                      child: const Text('Manage Subscription'),
                    ),
                  ] else ...[
                    // FREE User
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.neutral700),
                        const SizedBox(width: 8),
                        Text(
                          'Free Plan',
                          style: AppTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceSM),
                    Text(
                      'Upgrade to PRO for unlimited trades and advanced features',
                      style: AppTheme.bodySmall,
                    ),
                    const SizedBox(height: AppTheme.spaceMD),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionPlansScreen(),
                            ),
                          );
                        },
                        child: const Text('Upgrade to PRO'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Settings Options
            Container(
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.download,
                    title: 'Export Trades',
                    subtitle: isPro ? 'Download your trading data' : 'PRO feature',
                    isProFeature: !isPro,
                    onTap: isPro
                        ? () {
                            // Export trades
                          }
                        : () {
                            // Show paywall
                          },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    onTap: () {
                      // Open notifications
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () {
                      // Open help
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and info',
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Disclaimer Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disclaimer',
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  Text(
                    'This app is for educational and tracking purposes only. '
                    'It does not provide trading tips or guarantee profits. '
                    'Trading involves risk, and you should only trade with '
                    'money you can afford to lose.',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutConfirmation();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.loss,
                  side: const BorderSide(color: AppTheme.loss),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: AppTheme.spaceXL),
          ],
        ),
      ),
    );
  }

  void _showManageSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Subscription'),
        content: const Text(
          'Subscription management features:\n\n'
          '• View renewal date\n'
          '• Cancel subscription\n'
          '• Update payment method\n\n'
          'Coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Trading Journal'),
        content: const Text(
          'Version 1.0.0\n\n'
          'Professional Trading Journal Mobile App\n\n'
          'Track your trades, analyze performance, and improve your trading discipline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.loss),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isProFeature;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isProFeature = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isProFeature ? AppTheme.neutral500 : AppTheme.primary,
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: isProFeature ? AppTheme.neutral500 : AppTheme.neutral900,
        ),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: AppTheme.bodySmall,
            ),
          ),
          if (isProFeature)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'PRO',
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isProFeature ? AppTheme.neutral500 : AppTheme.neutral500,
      ),
      onTap: onTap,
    );
  }
}
