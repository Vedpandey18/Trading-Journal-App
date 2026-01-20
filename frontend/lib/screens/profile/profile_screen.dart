import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/premium_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/premium_login_screen.dart';
import '../subscription/subscription_plans_screen.dart';

/// Premium Profile & Settings Screen
/// User info, subscription, export, logout with premium UI
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brightness = themeProvider.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    final theme = brightness == Brightness.light ? PremiumTheme.lightTheme : PremiumTheme.darkTheme;
    
    final user = authProvider.user;
    final username = user?['username'] ?? 'User';
    final email = user?['email'] ?? '';
    final planType = user?['planType'] ?? 'FREE';
    final isPro = planType == 'PRO' || planType == 'PRO_MONTHLY' || planType == 'PRO_YEARLY';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Account', style: PremiumTheme.heading3(brightness)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              brightness == Brightness.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: theme.iconTheme.color,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PremiumTheme.spaceMD),
        child: Column(
          children: [
            // User Info Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: PremiumTheme.cardPaddingLarge,
              decoration: PremiumTheme.cardDecoration(brightness),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          PremiumTheme.lightPrimary,
                          PremiumTheme.lightPrimaryLight,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: PremiumTheme.shadowMD(brightness),
                    ),
                    child: Center(
                      child: Text(
                        username[0].toUpperCase(),
                        style: PremiumTheme.heroNumber(Colors.white, brightness).copyWith(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: PremiumTheme.spaceMD),
                  Text(
                    username,
                    style: PremiumTheme.heading2(brightness),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: PremiumTheme.bodyMedium(brightness).copyWith(
                      color: brightness == Brightness.light 
                          ? PremiumTheme.lightTextSecondary 
                          : PremiumTheme.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: PremiumTheme.spaceMD),
                  // Plan Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PremiumTheme.spaceMD,
                      vertical: PremiumTheme.spaceSM,
                    ),
                    decoration: BoxDecoration(
                      color: isPro
                          ? PremiumTheme.profitGreen.withOpacity(0.1)
                          : PremiumTheme.neutralGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(PremiumTheme.radiusLG),
                      border: Border.all(
                        color: isPro
                            ? PremiumTheme.profitGreen
                            : PremiumTheme.neutralGrey,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPro ? Icons.star : Icons.star_border,
                          size: 18,
                          color: isPro
                              ? PremiumTheme.profitGreen
                              : PremiumTheme.neutralGrey,
                        ),
                        const SizedBox(width: PremiumTheme.spaceSM),
                        Text(
                          planType,
                          style: PremiumTheme.labelMedium(brightness).copyWith(
                            fontWeight: FontWeight.bold,
                            color: isPro
                                ? PremiumTheme.profitGreen
                                : PremiumTheme.neutralGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PremiumTheme.spaceLG),

            // Subscription Card (if Free)
            if (!isPro)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: PremiumTheme.cardPadding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PremiumTheme.lightPrimary.withOpacity(0.1),
                      PremiumTheme.lightPrimaryLight.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusMD),
                  border: Border.all(
                    color: PremiumTheme.lightPrimary,
                    width: 2,
                  ),
                  boxShadow: PremiumTheme.shadowMD(brightness),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: PremiumTheme.lightPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: PremiumTheme.spaceSM),
                        Text(
                          'Upgrade to PRO',
                          style: PremiumTheme.heading3(brightness).copyWith(
                            color: PremiumTheme.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),
                    _buildFeatureItem('Unlimited trades', brightness),
                    _buildFeatureItem('Advanced analytics', brightness),
                    _buildFeatureItem('Export data', brightness),
                    _buildFeatureItem('Priority support', brightness),
                    const SizedBox(height: PremiumTheme.spaceMD),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionPlansScreen(),
                            ),
                          );
                        },
                        style: PremiumTheme.elevatedButtonTheme.style,
                        child: const Text('Upgrade Now - ₹299/month'),
                      ),
                    ),
                  ],
                ),
              ),
            if (!isPro) const SizedBox(height: PremiumTheme.spaceLG),

            // Settings Options
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: PremiumTheme.cardDecoration(brightness),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.download,
                    title: 'Export Trades',
                    subtitle: 'Download your trading data',
                    brightness: brightness,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Export feature coming soon!'),
                          backgroundColor: PremiumTheme.lightPrimary,
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: brightness == Brightness.light 
                        ? PremiumTheme.lightBorderColor 
                        : PremiumTheme.darkBorderColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    brightness: brightness,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notifications settings coming soon!'),
                          backgroundColor: PremiumTheme.lightPrimary,
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: brightness == Brightness.light 
                        ? PremiumTheme.lightBorderColor 
                        : PremiumTheme.darkBorderColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    brightness: brightness,
                    onTap: () {
                      _showAboutDialog(brightness);
                    },
                  ),
                  Divider(
                    height: 1,
                    color: brightness == Brightness.light 
                        ? PremiumTheme.lightBorderColor 
                        : PremiumTheme.darkBorderColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and info',
                    brightness: brightness,
                    onTap: () {
                      _showAboutDialog(brightness);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: PremiumTheme.spaceLG),

            // Disclaimer Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: PremiumTheme.cardPadding,
              decoration: PremiumTheme.cardDecoration(brightness),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disclaimer',
                    style: PremiumTheme.heading3(brightness),
                  ),
                  const SizedBox(height: PremiumTheme.spaceSM),
                  Text(
                    'This app is for educational and tracking purposes only. '
                    'It does not provide trading tips or guarantee profits. '
                    'Trading involves risk, and you should only trade with '
                    'money you can afford to lose.',
                    style: PremiumTheme.bodySmall(brightness).copyWith(
                      color: brightness == Brightness.light 
                          ? PremiumTheme.lightTextSecondary 
                          : PremiumTheme.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PremiumTheme.spaceLG),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutConfirmation(brightness);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: PremiumTheme.lossRed,
                  side: const BorderSide(color: PremiumTheme.lossRed, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PremiumTheme.radiusMD),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: PremiumTheme.bodyLarge(brightness).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: PremiumTheme.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PremiumTheme.spaceSM),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: PremiumTheme.profitGreen,
          ),
          const SizedBox(width: PremiumTheme.spaceSM),
          Text(
            text,
            style: PremiumTheme.bodyMedium(brightness),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Brightness brightness,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: PremiumTheme.lightPrimary,
      ),
      title: Text(
        title,
        style: PremiumTheme.bodyLarge(brightness),
      ),
      subtitle: Text(
        subtitle,
        style: PremiumTheme.bodySmall(brightness).copyWith(
          color: brightness == Brightness.light 
              ? PremiumTheme.lightTextSecondary 
              : PremiumTheme.darkTextSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: brightness == Brightness.light 
            ? PremiumTheme.lightTextTertiary 
            : PremiumTheme.darkTextTertiary,
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog(Brightness brightness) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brightness == Brightness.light 
            ? PremiumTheme.lightCard 
            : PremiumTheme.darkCard,
        title: Text(
          'About Trading Journal',
          style: PremiumTheme.heading3(brightness),
        ),
        content: Text(
          'Version 1.0.0\n\n'
          'Professional Trading Journal Mobile App\n\n'
          'Track your trades, analyze performance, and improve your trading discipline.',
          style: PremiumTheme.bodyMedium(brightness),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: PremiumTheme.labelMedium(brightness).copyWith(
                color: PremiumTheme.lightPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmation(Brightness brightness) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brightness == Brightness.light 
            ? PremiumTheme.lightCard 
            : PremiumTheme.darkCard,
        title: Text(
          'Logout',
          style: PremiumTheme.heading3(brightness),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: PremiumTheme.bodyMedium(brightness),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: PremiumTheme.labelMedium(brightness).copyWith(
                color: brightness == Brightness.light 
                    ? PremiumTheme.lightTextSecondary 
                    : PremiumTheme.darkTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: PremiumTheme.lossRed,
            ),
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
          MaterialPageRoute(builder: (_) => const PremiumLoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
