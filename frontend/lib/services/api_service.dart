import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use localhost for web (Chrome), 10.0.2.2 for Android emulator
  static const String baseUrl = 'http://localhost:8081/api'; // Web (Chrome) - Match backend port
  // For Android emulator: 'http://10.0.2.2:8081/api'
  // For physical device: 'http://YOUR_IP:8081/api'
  
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5), // Faster timeout
      receiveTimeout: const Duration(seconds: 5), // Faster timeout
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status! < 500; // Don't throw on 4xx errors
      },
    ));
    
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
        // Better error handling
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: 'Connection timeout. Please check if backend is running on port 8081.',
            type: DioExceptionType.connectionTimeout,
          ));
        }
        if (error.type == DioExceptionType.connectionError) {
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: 'Cannot connect to backend. Please ensure backend is running on http://localhost:8081',
            type: DioExceptionType.connectionError,
          ));
        }
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - clear token and redirect to login
        }
        return handler.next(error);
      },
    ));
  }
  
  // Test backend connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/auth/test', 
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return response.statusCode != null;
    } catch (e) {
      return false;
    }
  }
  
  // Auth APIs
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
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
  
  Future<Map<String, dynamic>> login(String usernameOrEmail, String password) async {
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
  
  // Trade APIs
  Future<Map<String, dynamic>> addTrade(Map<String, dynamic> tradeData) async {
    try {
      final response = await _dio.post('/trades', data: tradeData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<dynamic>> getAllTrades() async {
    try {
      final response = await _dio.get('/trades');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<dynamic>> getTradesByDateRange(String startDate, String endDate) async {
    try {
      final response = await _dio.get('/trades/date-range', queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> deleteTrade(int tradeId) async {
    try {
      await _dio.delete('/trades/$tradeId');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Analytics APIs
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Payment APIs
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
  
  Future<void> verifyPayment(String orderId, String paymentId, String signature) async {
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
  
  String _handleError(dynamic error) {
    if (error is DioException) {
      // Handle connection errors specifically
      if (error.type == DioExceptionType.connectionError) {
        return 'Cannot connect to backend. Please ensure:\n1. Backend is running on port 8081\n2. MySQL is running\n3. Check backend logs for errors';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Backend may be slow or not responding.';
      }
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'] as String;
        }
        return 'Server error: ${error.response?.statusCode}';
      } else {
        // More specific error messages
        if (error.message != null) {
          return error.message.toString();
        }
        return 'Network error: Unable to reach backend server';
      }
    }
    return 'An unexpected error occurred: ${error.toString()}';
  }
}
