import 'package:intl/intl.dart';
import 'exchange_model.dart';

/// Indian Market Trade Model
/// Supports BTC, Gold (MCX), and Digital Gold
class IndianTradeModel {
  final int? id;
  final AssetType assetType;
  final ExchangeModel exchange;
  final String tradeType; // "BUY" or "SELL"
  final double entryPrice; // INR
  final double exitPrice; // INR
  final DateTime tradeDate;
  final DateTime? tradeTime;
  final String? notes;
  final double? profitLoss; // INR
  final double? fees; // INR (for BTC)
  final double? leverage; // For crypto derivatives (Delta Exchange)

  // BTC-specific
  final double? btcQuantity; // BTC amount (fractional allowed)

  // Gold-specific
  final GoldTradeType? goldTradeType; // MCX or Digital Gold
  final int? lotSize; // For MCX Gold (e.g., 100 grams per lot)
  final int? numberOfLots; // For MCX Gold
  final double? goldQuantity; // For Digital Gold (grams)

  final DateTime? createdAt;
  final DateTime? updatedAt;

  IndianTradeModel({
    this.id,
    required this.assetType,
    required this.exchange,
    required this.tradeType,
    required this.entryPrice,
    required this.exitPrice,
    required this.tradeDate,
    this.tradeTime,
    this.notes,
    this.profitLoss,
    this.fees,
    this.leverage,
    this.btcQuantity,
    this.goldTradeType,
    this.lotSize,
    this.numberOfLots,
    this.goldQuantity,
    this.createdAt,
    this.updatedAt,
  });

  /// Get total quantity based on asset type
  double get totalQuantity {
    switch (assetType) {
      case AssetType.btc:
        return btcQuantity ?? 0.0;
      case AssetType.gold:
        if (goldTradeType == GoldTradeType.mcx) {
          // MCX: Total quantity = Lot Size × Number of Lots
          return (lotSize ?? 0) * (numberOfLots ?? 0).toDouble();
        } else {
          // Digital Gold: Quantity in grams
          return goldQuantity ?? 0.0;
        }
      default:
        return 0.0;
    }
  }

  /// Check if trade is profitable
  bool get isProfit => profitLoss != null && profitLoss! > 0;

  /// Format trade date
  String get formattedDate => DateFormat('MMM dd, yyyy').format(tradeDate);

  /// Format P&L as currency (INR)
  String get formattedPnL {
    if (profitLoss == null) return '--';
    if (profitLoss! >= 0) {
      return '+₹${profitLoss!.toStringAsFixed(2)}';
    }
    return '₹${profitLoss!.toStringAsFixed(2)}';
  }

  /// Calculate P&L based on asset type
  double calculatePnL() {
    double pnl = 0.0;

    switch (assetType) {
      case AssetType.btc:
        // BTC: P&L = (Exit Price - Entry Price) × Quantity - Fees
        if (btcQuantity != null) {
          pnl = (exitPrice - entryPrice) * btcQuantity!;
          if (fees != null) {
            pnl -= fees!;
          }
        }
        break;

      case AssetType.gold:
        if (goldTradeType == GoldTradeType.mcx) {
          // MCX Gold: P&L = (Exit Price - Entry Price) × Lot Size × No. of Lots
          if (lotSize != null && numberOfLots != null) {
            pnl = (exitPrice - entryPrice) * lotSize! * numberOfLots!;
          }
        } else {
          // Digital Gold: P&L = (Exit Price - Entry Price) × Grams
          if (goldQuantity != null) {
            pnl = (exitPrice - entryPrice) * goldQuantity!;
          }
        }
        break;

      default:
        pnl = 0.0;
    }

    // Adjust for trade type (BUY/SELL)
    if (tradeType == 'SELL') {
      pnl = -pnl; // Reverse for SELL
    }

    return pnl;
  }

  factory IndianTradeModel.fromJson(Map<String, dynamic> json) {
    return IndianTradeModel(
      id: json['id'],
      assetType: AssetType.values.firstWhere(
        (e) => e.toString() == 'AssetType.${json['assetType']}',
        orElse: () => AssetType.equity,
      ),
      exchange: ExchangeModel.fromJson(json['exchange']),
      tradeType: json['tradeType'],
      entryPrice: (json['entryPrice'] as num).toDouble(),
      exitPrice: (json['exitPrice'] as num).toDouble(),
      tradeDate: DateTime.parse(json['tradeDate']),
      tradeTime: json['tradeTime'] != null
          ? DateTime.parse(json['tradeTime'])
          : null,
      notes: json['notes'],
      profitLoss: json['profitLoss'] != null
          ? (json['profitLoss'] as num).toDouble()
          : null,
      fees: json['fees'] != null ? (json['fees'] as num).toDouble() : null,
      leverage: json['leverage'] != null
          ? (json['leverage'] as num).toDouble()
          : null,
      btcQuantity: json['btcQuantity'] != null
          ? (json['btcQuantity'] as num).toDouble()
          : null,
      goldTradeType: json['goldTradeType'] != null
          ? GoldTradeType.values.firstWhere(
              (e) => e.toString() == 'GoldTradeType.${json['goldTradeType']}',
            )
          : null,
      lotSize: json['lotSize'],
      numberOfLots: json['numberOfLots'],
      goldQuantity: json['goldQuantity'] != null
          ? (json['goldQuantity'] as num).toDouble()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetType': assetType.toString().split('.').last,
      'exchange': exchange.toJson(),
      'tradeType': tradeType,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'tradeDate': tradeDate.toIso8601String().split('T')[0],
      'tradeTime': tradeTime?.toIso8601String(),
      'notes': notes,
      'profitLoss': profitLoss,
      'fees': fees,
      'leverage': leverage,
      'btcQuantity': btcQuantity,
      'goldTradeType': goldTradeType?.toString().split('.').last,
      'lotSize': lotSize,
      'numberOfLots': numberOfLots,
      'goldQuantity': goldQuantity,
    };
  }
}

/// Gold Trade Type
enum GoldTradeType {
  mcx,         // MCX Gold Futures
  digitalGold, // Digital Gold (grams)
}

/// P&L Result Model
class PnLResult {
  final double totalPnL; // INR
  final double btcPnL; // INR
  final double goldPnL; // INR
  final Map<String, double> exchangeWisePnL; // Exchange -> P&L
  final Map<AssetType, double> assetWisePnL; // Asset -> P&L

  PnLResult({
    required this.totalPnL,
    required this.btcPnL,
    required this.goldPnL,
    required this.exchangeWisePnL,
    required this.assetWisePnL,
  });

  factory PnLResult.fromJson(Map<String, dynamic> json) {
    return PnLResult(
      totalPnL: (json['totalPnL'] as num).toDouble(),
      btcPnL: (json['btcPnL'] as num).toDouble(),
      goldPnL: (json['goldPnL'] as num).toDouble(),
      exchangeWisePnL: Map<String, double>.from(json['exchangeWisePnL'] ?? {}),
      assetWisePnL: (json['assetWisePnL'] as Map).map(
        (key, value) => MapEntry(
          AssetType.values.firstWhere(
            (e) => e.toString() == 'AssetType.$key',
          ),
          (value as num).toDouble(),
        ),
      ),
    );
  }
}
