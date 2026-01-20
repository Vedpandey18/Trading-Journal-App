import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Payment Success Screen
/// Shown after successful payment
/// Updates UI to PRO status immediately
class PaymentSuccessScreen extends StatefulWidget {
  final String paymentId;
  final String orderId;

  const PaymentSuccessScreen({
    Key? key,
    required this.paymentId,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isVerifying = true;

  @override
  void initState() {
    super.initState();
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    // Verify payment with backend
    try {
      // TODO: Call backend API to verify payment
      // await apiService.verifyPayment(
      //   orderId: widget.orderId,
      //   paymentId: widget.paymentId,
      //   signature: signature,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update subscription status in local storage
      await _updateSubscriptionStatus();

      setState(() {
        _isVerifying = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription activated! Welcome to PRO!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment verification failed: ${e.toString()}'),
            backgroundColor: AppTheme.loss,
          ),
        );
      }
    }
  }

  Future<void> _updateSubscriptionStatus() async {
    // TODO: Update subscription status in SharedPreferences or state management
    // This will trigger UI update to show PRO features
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('planType', 'PRO');
    // await prefs.setBool('isProUser', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isVerifying) ...[
                // Verifying State
                const CircularProgressIndicator(
                  color: AppTheme.primary,
                ),
                const SizedBox(height: AppTheme.spaceLG),
                Text(
                  'Verifying Payment...',
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  'Please wait while we activate your subscription',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.neutral700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                // Success State
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.profit.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppTheme.profit,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceLG),
                Text(
                  'Payment Successful!',
                  style: AppTheme.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  'Your PRO subscription has been activated',
                  style: AppTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spaceXL),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment ID',
                            style: AppTheme.labelMedium,
                          ),
                          Text(
                            widget.paymentId.substring(0, 12) + '...',
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceSM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID',
                            style: AppTheme.labelMedium,
                          ),
                          Text(
                            widget.orderId.substring(0, 12) + '...',
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spaceXL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to dashboard
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Start Using PRO'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
