/// API Service Structure
/// Skeleton for backend integration
/// 
/// This file shows the structure - actual implementation will connect to your Spring Boot backend

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trade_model.dart';

/// API Service Class
/// Handles all HTTP requests to backend
class ApiService {
  // Base URL - Update this to your backend URL
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // For physical device: 'http://YOUR_IP:8080/api'
  
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    // Interceptor for adding JWT token to requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle 401 unauthorized
        if (error.response?.statusCode == 401) {
          // Clear token and redirect to login
          _clearAuthToken();
        }
        return handler.next(error);
      },
    ));
  }
  
  // ==================== AUTHENTICATION ====================
  
  /// Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Login user
  Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== TRADES ====================
  
  /// Get all trades for current user
  Future<List<TradeModel>> getAllTrades() async {
    try {
      final response = await _dio.get('/trades');
      final List<dynamic> data = response.data;
      return data.map((json) => TradeModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Get trades by date range
  Future<List<TradeModel>> getTradesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get('/trades/date-range', queryParameters: {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      });
      final List<dynamic> data = response.data;
      return data.map((json) => TradeModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Add new trade
  Future<TradeModel> addTrade(TradeModel trade) async {
    try {
      final response = await _dio.post('/trades', data: trade.toJson());
      return TradeModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Delete trade
  Future<void> deleteTrade(int tradeId) async {
    try {
      await _dio.delete('/trades/$tradeId');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== ANALYTICS ====================
  
  /// Get dashboard analytics
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== PAYMENT ====================
  
  /// Create payment order
  Future<Map<String, dynamic>> createPaymentOrder(double amount) async {
    try {
      final response = await _dio.post('/payment/create-order', data: {
        'amount': amount,
        'currency': 'INR',
      });
      return json.decode(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Verify payment
  Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      await _dio.post('/payment/verify', data: {
        'razorpayOrderId': orderId,
        'razorpayPaymentId': paymentId,
        'razorpaySignature': signature,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== HELPER METHODS ====================
  
  /// Handle API errors
  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'];
        }
        return 'Server error: ${error.response?.statusCode}';
      } else {
        return 'Network error: ${error.message}';
      }
    }
    return 'An unexpected error occurred';
  }
  
  /// Clear authentication token
  Future<void> _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

/// Data Flow Explanation:
/// 
/// UI → API Service → Backend → API Service → UI
/// 
/// 1. **UI Layer** (Screens):
///    - User interacts with UI
///    - Calls methods on API Service
///    - Shows loading states
///    - Displays data or errors
/// 
/// 2. **API Service Layer**:
///    - Makes HTTP requests
///    - Adds JWT token to headers
///    - Handles errors
///    - Converts JSON to models
/// 
/// 3. **Backend** (Spring Boot):
///    - Processes requests
///    - Returns JSON responses
/// 
/// 4. **Models**:
///    - TradeModel.fromJson() - Convert JSON to model
///    - TradeModel.toJson() - Convert model to JSON
/// 
/// Example Usage:
/// ```dart
/// final apiService = ApiService();
/// 
/// // Get all trades
/// final trades = await apiService.getAllTrades();
/// 
/// // Add trade
/// final newTrade = TradeModel(...);
/// final savedTrade = await apiService.addTrade(newTrade);
/// 
/// // Get analytics
/// final analytics = await apiService.getAnalytics();
/// ```
