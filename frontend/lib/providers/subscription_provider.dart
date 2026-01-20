import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';

/// Subscription Provider
/// Manages subscription state in the app
/// Handles isProUser, subscription expiry, feature access
class SubscriptionProvider with ChangeNotifier {
  SubscriptionModel? _subscription;
  bool _isLoading = false;

  SubscriptionProvider() {
    _loadSubscriptionStatus();
  }

  // Getters
  bool get isProUser => _subscription?.isValidPro ?? false;
  bool get isLoading => _isLoading;
  SubscriptionModel? get subscription => _subscription;
  String get planType => _subscription?.planType ?? 'FREE';

  /// Load subscription status from storage
  Future<void> _loadSubscriptionStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final planType = prefs.getString('planType') ?? 'FREE';
      final isActive = prefs.getBool('isActive') ?? false;
      final endDateStr = prefs.getString('endDate');

      _subscription = SubscriptionModel(
        planType: planType,
        isActive: isActive,
        endDate: endDateStr != null ? DateTime.parse(endDateStr) : null,
      );
    } catch (e) {
      // Handle error
      _subscription = SubscriptionModel(planType: 'FREE');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update subscription to PRO
  /// Called after successful payment
  Future<void> activateProSubscription({
    required DateTime endDate,
    String? orderId,
    String? paymentId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('planType', 'PRO');
      await prefs.setBool('isActive', true);
      await prefs.setString('endDate', endDate.toIso8601String());
      if (orderId != null) {
        await prefs.setString('razorpayOrderId', orderId);
      }
      if (paymentId != null) {
        await prefs.setString('razorpayPaymentId', paymentId);
      }

      _subscription = SubscriptionModel(
        planType: 'PRO',
        isActive: true,
        endDate: endDate,
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
      );
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if user can add trade (free plan limit)
  bool canAddTrade(int currentTradeCount) {
    if (isProUser) return true;
    return currentTradeCount < 10; // Free plan limit
  }

  /// Check if feature is accessible
  bool hasAccessToFeature(String feature) {
    if (isProUser) return true;

    // Define which features require PRO
    final proFeatures = [
      'advanced_analytics',
      'export_data',
      'unlimited_trades',
    ];

    return !proFeatures.contains(feature);
  }

  /// Refresh subscription status from backend
  Future<void> refreshSubscription() async {
    _isLoading = true;
    notifyListeners();

    try {
      final subscriptionService = SubscriptionService();
      final status = await subscriptionService.getStatus();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('planType', status['planType'] ?? 'FREE');
      await prefs.setBool('isActive', status['isActive'] ?? false);
      
      if (status['endDate'] != null) {
        await prefs.setString('endDate', status['endDate']);
      }

      _subscription = SubscriptionModel(
        planType: status['planType'] ?? 'FREE',
        isActive: status['isActive'] ?? false,
        endDate: status['endDate'] != null 
            ? DateTime.parse(status['endDate']) 
            : null,
      );
    } catch (e) {
      // Handle error - keep existing subscription
      print('Failed to refresh subscription: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update subscription after successful payment
  Future<void> updateAfterPayment(String planType, DateTime endDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('planType', planType);
    await prefs.setBool('isActive', true);
    await prefs.setString('endDate', endDate.toIso8601String());

    _subscription = SubscriptionModel(
      planType: planType,
      isActive: true,
      endDate: endDate,
    );

    notifyListeners();
  }
}

/// State Management Explanation:
/// 
/// **Where to Store State:**
/// - SharedPreferences: Persistent storage (survives app restarts)
/// - Provider: In-memory state (fast access, updates UI)
/// 
/// **How UI Reacts Instantly:**
/// 1. Payment success → Update SharedPreferences
/// 2. Call subscriptionProvider.activateProSubscription()
/// 3. Provider notifies listeners
/// 4. All screens using Provider rebuild
/// 5. UI immediately shows PRO features
/// 
/// **Usage in Screens:**
/// ```dart
/// final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
/// 
/// if (subscriptionProvider.isProUser) {
///   // Show PRO features
/// } else {
///   // Show upgrade prompt
/// }
/// ```
