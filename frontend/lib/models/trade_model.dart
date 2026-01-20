import 'package:intl/intl.dart';

/// Trade Model
/// Represents a single trade entry
class TradeModel {
  final int? id;
  final String instrument;
  final String tradeType; // "BUY" or "SELL"
  final double entryPrice;
  final double exitPrice;
  final int quantity;
  final int lotSize;
  final DateTime tradeDate;
  final String? notes;
  final double? profitLoss;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TradeModel({
    this.id,
    required this.instrument,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.quantity,
    this.lotSize = 1,
    required this.tradeDate,
    this.notes,
    this.profitLoss,
    this.createdAt,
    this.updatedAt,
  });

  /// Calculate total quantity (quantity * lot size)
  int get totalQuantity => quantity * lotSize;

  /// Check if trade is profitable
  bool get isProfit => profitLoss != null && profitLoss! > 0;

  /// Format trade date
  String get formattedDate => DateFormat('MMM dd, yyyy').format(tradeDate);

  /// Format P&L as currency
  String get formattedPnL {
    if (profitLoss == null) return '--';
    if (profitLoss! >= 0) {
      return '+₹${profitLoss!.toStringAsFixed(2)}';
    }
    return '₹${profitLoss!.toStringAsFixed(2)}';
  }

  /// Create from JSON (for API integration)
  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      id: json['id'],
      instrument: json['instrument'],
      tradeType: json['tradeType'],
      entryPrice: (json['entryPrice'] as num).toDouble(),
      exitPrice: (json['exitPrice'] as num).toDouble(),
      quantity: json['quantity'],
      lotSize: json['lotSize'] ?? 1,
      tradeDate: DateTime.parse(json['tradeDate']),
      notes: json['notes'],
      profitLoss: json['profitLoss'] != null
          ? (json['profitLoss'] as num).toDouble()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instrument': instrument,
      'tradeType': tradeType,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'quantity': quantity,
      'lotSize': lotSize,
      'tradeDate': tradeDate.toIso8601String().split('T')[0],
      'notes': notes,
      'profitLoss': profitLoss,
    };
  }
}
