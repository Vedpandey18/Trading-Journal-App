import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();
  late Razorpay _razorpay;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<Map<String, dynamic>> createOrder(double amount) async {
    return await _apiService.createPaymentOrder(amount);
  }

  Future<void> openCheckout(
    BuildContext context,
    Map<String, dynamic> orderData,
    String name,
    String email,
  ) async {
    final options = {
      'key': 'your-razorpay-key-id', // Replace with your Razorpay key
      'amount': (orderData['amount'] as int).toString(),
      'name': 'Trading Journal',
      'description': 'PRO Subscription',
      'prefill': {
        'contact': '',
        'email': email,
        'name': name,
      },
      'external': {
        'wallets': ['paytm']
      },
      'order_id': orderData['id'],
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      throw Exception('Failed to open payment gateway: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success - verify payment on backend
    _verifyPayment(
      response.orderId ?? '',
      response.paymentId ?? '',
      response.signature ?? '',
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    debugPrint('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    debugPrint('External Wallet: ${response.walletName}');
  }

  Future<void> _verifyPayment(
    String orderId,
    String paymentId,
    String signature,
  ) async {
    try {
      await _apiService.verifyPayment(orderId, paymentId, signature);
      // Payment verified - subscription activated
      // Refresh user data to get updated plan type
    } catch (e) {
      throw Exception('Payment verification failed: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
