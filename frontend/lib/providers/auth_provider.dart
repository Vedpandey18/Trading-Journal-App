import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  String? _token;
  Map<String, dynamic>? _user;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.register(username, email, password);
      _token = response['token'];
      _user = {
        'userId': response['userId'],
        'username': response['username'],
        'email': response['email'],
        'planType': response['planType'],
      };
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('username', _user!['username']);
      await prefs.setString('email', _user!['email'] ?? '');
      await prefs.setString('planType', _user!['planType']);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> login(String usernameOrEmail, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.login(usernameOrEmail, password);
      _token = response['token'];
      _user = {
        'userId': response['userId'],
        'username': response['username'],
        'email': response['email'],
        'planType': response['planType'],
      };
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('username', _user!['username']);
      await prefs.setString('email', _user!['email'] ?? '');
      await prefs.setString('planType', _user!['planType']);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('planType');
    
    _token = null;
    _user = null;
    notifyListeners();
  }
  
  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final planType = prefs.getString('planType');
    
    if (_token != null && username != null) {
      _user = {
        'username': username,
        'email': email ?? '',
        'planType': planType ?? 'FREE',
      };
      notifyListeners();
    }
  }
  
  bool isProUser() {
    return _user?['planType'] == 'PRO';
  }
}
