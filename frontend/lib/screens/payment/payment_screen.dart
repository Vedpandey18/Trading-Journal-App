import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../services/razorpay_service.dart';

/// Payment Screen
/// Handles Razorpay checkout flow
/// Shows payment processing and handles callbacks
class PaymentScreen extends StatefulWidget {
  final double amount;

  const PaymentScreen({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final RazorpayService _razorpayService = RazorpayService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _setupRazorpayCallbacks();
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  void _setupRazorpayCallbacks() {
    _razorpayService.onPaymentSuccess = _handlePaymentSuccess;
    _razorpayService.onPaymentError = _handlePaymentError;
    _razorpayService.onPaymentCancel = _handlePaymentCancel;
  }

  Future<void> _initiatePayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Create order on backend first
      // For now, using dummy order ID
      final orderId = await _createOrder();

      // Open Razorpay checkout
      await _razorpayService.openCheckout(
        amount: widget.amount,
        orderId: orderId,
        name: 'Trading Journal PRO',
        description: 'PRO Subscription',
        email: 'user@example.com', // Get from user profile
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: AppTheme.loss,
          ),
        );
      }
    }
  }

  Future<String> _createOrder() async {
    // TODO: Call backend API to create order
    // For now, return dummy order ID
    await Future.delayed(const Duration(seconds: 1));
    return 'order_dummy_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    setState(() {
      _isProcessing = false;
    });

    // Navigate to success screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          paymentId: response['razorpay_payment_id'],
          orderId: response['razorpay_order_id'],
        ),
      ),
    );
  }

  void _handlePaymentError(String error) {
    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $error'),
          backgroundColor: AppTheme.loss,
        ),
      );
    }
  }

  void _handlePaymentCancel() {
    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment cancelled'),
          backgroundColor: AppTheme.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Payment Summary Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  Text(
                    'Payment Summary',
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: AppTheme.spaceLG),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PRO Subscription',
                        style: AppTheme.bodyLarge,
                      ),
                      Text(
                        '₹${widget.amount.toStringAsFixed(0)}',
                        style: AppTheme.numberMedium(AppTheme.neutral900),
                      ),
                    ],
                  ),
                  const Divider(height: AppTheme.spaceXL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTheme.heading3,
                      ),
                      Text(
                        '₹${widget.amount.toStringAsFixed(0)}',
                        style: AppTheme.heroNumber(AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Security Info
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.profit.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: AppTheme.profit, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment is secured by Razorpay',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.profit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceXL),

            // Pay Button
            ElevatedButton(
              onPressed: _isProcessing ? null : _initiatePayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                    )
                  : const Text('Pay ₹${widget.amount.toStringAsFixed(0)}'),
            ),
            const SizedBox(height: AppTheme.spaceMD),

            // Cancel Button
            TextButton(
              onPressed: _isProcessing
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
