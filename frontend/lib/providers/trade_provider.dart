import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class TradeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  bool _isLoadingAnalytics = false;
  String? _error;
  List<Map<String, dynamic>> _trades = [];
  Map<String, dynamic>? _analytics;
  
  // Track if data has been fetched to prevent duplicate calls
  bool _tradesFetched = false;
  bool _analyticsFetched = false;
  
  bool get isLoading => _isLoading;
  bool get isLoadingAnalytics => _isLoadingAnalytics;
  String? get error => _error;
  List<Map<String, dynamic>> get trades => _trades;
  Map<String, dynamic>? get analytics => _analytics;
  bool get tradesFetched => _tradesFetched;
  bool get analyticsFetched => _analyticsFetched;
  
  Future<bool> addTrade(Map<String, dynamic> tradeData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final trade = await _apiService.addTrade(tradeData);
      _trades.insert(0, trade);
      _tradesFetched = true; // Mark as fetched
      _analyticsFetched = false; // Invalidate analytics to refresh
      _isLoading = false;
      notifyListeners();
      // Refresh analytics in background - don't block UI
      fetchAnalytics();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> fetchTrades() async {
    // Prevent duplicate calls if already loading or already fetched
    if (_isLoading || _tradesFetched) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final fetchedTrades = List<Map<String, dynamic>>.from(await _apiService.getAllTrades());
      // Sort by trade date (newest first) to ensure consistent order
      fetchedTrades.sort((a, b) {
        final dateA = a['tradeDate'] as String?;
        final dateB = b['tradeDate'] as String?;
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA); // Descending (newest first)
      });
      _trades = fetchedTrades;
      _tradesFetched = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Force refresh - bypasses the _tradesFetched flag
  Future<void> refreshTrades() async {
    _tradesFetched = false;
    await fetchTrades();
  }
  
  Future<void> fetchTradesByDateRange(String startDate, String endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _trades = List<Map<String, dynamic>>.from(
        await _apiService.getTradesByDateRange(startDate, endDate)
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> deleteTrade(int tradeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _apiService.deleteTrade(tradeId);
      _trades.removeWhere((trade) => trade['id'] == tradeId);
      _analyticsFetched = false; // Invalidate analytics to refresh
      _isLoading = false;
      notifyListeners();
      // Refresh analytics in background - don't block UI
      fetchAnalytics();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> fetchAnalytics() async {
    // Prevent duplicate calls if already loading or already fetched
    if (_isLoadingAnalytics || _analyticsFetched) return;
    
    _isLoadingAnalytics = true;
    _error = null;
    notifyListeners();
    
    try {
      _analytics = await _apiService.getAnalytics();
      _analyticsFetched = true;
      _isLoadingAnalytics = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingAnalytics = false;
      notifyListeners();
    }
  }
  
  // Force refresh analytics
  Future<void> refreshAnalytics() async {
    _analyticsFetched = false;
    await fetchAnalytics();
  }
}
