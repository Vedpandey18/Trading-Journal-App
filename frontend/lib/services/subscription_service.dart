import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// Subscription Service
/// Handles subscription-related API calls
class SubscriptionService {
  final ApiService _apiService = ApiService();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiService.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  /// Get available subscription plans
  Future<List<Map<String, dynamic>>> getPlans() async {
    try {
      final response = await _dio.get('/subscription/plans');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw 'Failed to fetch subscription plans: ${e.toString()}';
    }
  }

  /// Get current user subscription status
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await _dio.get(
        '/subscription/status',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } catch (e) {
      throw 'Failed to fetch subscription status: ${e.toString()}';
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      await _dio.post(
        '/subscription/cancel',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw 'Failed to cancel subscription: ${e.toString()}';
    }
  }
}
