import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../theme/theme.dart';

/// Razorpay Service
/// Handles Razorpay payment integration
/// Frontend-only implementation
class RazorpayService {
  late Razorpay _razorpay;
  
  // Replace with your Razorpay Key ID
  static const String razorpayKeyId = 'your-razorpay-key-id';
  
  // Callbacks
  Function(Map<String, dynamic>)? onPaymentSuccess;
  Function(String)? onPaymentError;
  VoidCallback? onPaymentCancel;

  RazorpayService() {
    _razorpay = Razorpay();
    _setupEventHandlers();
  }

  void _setupEventHandlers() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Open Razorpay Checkout
  /// 
  /// Parameters:
  /// - amount: Payment amount in rupees
  /// - orderId: Order ID from backend
  /// - name: User name
  /// - description: Payment description
  /// - email: User email
  Future<void> openCheckout({
    required double amount,
    required String orderId,
    required String name,
    required String description,
    required String email,
  }) async {
    final options = {
      'key': razorpayKeyId,
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': 'Trading Journal',
      'description': description,
      'prefill': {
        'contact': '',
        'email': email,
        'name': name,
      },
      'external': {
        'wallets': ['paytm']
      },
      'order_id': orderId,
      'theme': {
        'color': '#1E40AF' // Primary blue
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      throw Exception('Failed to open payment gateway: $e');
    }
  }

  /// Handle Payment Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final paymentData = {
      'razorpay_payment_id': response.paymentId,
      'razorpay_order_id': response.orderId,
      'razorpay_signature': response.signature,
    };

    if (onPaymentSuccess != null) {
      onPaymentSuccess!(paymentData);
    }
  }

  /// Handle Payment Error
  void _handlePaymentError(PaymentFailureResponse response) {
    final errorMessage = response.message ?? 'Payment failed';
    
    if (onPaymentError != null) {
      onPaymentError!(errorMessage);
    }
  }

  /// Handle External Wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    // User selected external wallet (e.g., Paytm)
    // Payment will continue in external app
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

/// Payment Flow Explanation:
/// 
/// 1. User clicks "Upgrade to PRO"
/// 2. Frontend calls backend to create order
/// 3. Backend returns order_id
/// 4. Frontend opens Razorpay checkout with order_id
/// 5. User completes payment in Razorpay
/// 6. Razorpay returns payment_id and signature
/// 7. Frontend sends payment_id, order_id, signature to backend
/// 8. Backend verifies payment and activates subscription
/// 9. Frontend updates UI to show PRO status
