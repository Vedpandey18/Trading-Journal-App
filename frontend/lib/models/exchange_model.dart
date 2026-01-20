/// Exchange Model
/// Represents Indian brokers and exchanges
class ExchangeModel {
  final String id;
  final String name;
  final ExchangeType type;
  final List<AssetType> supportedAssets;
  final String? logoUrl;

  ExchangeModel({
    required this.id,
    required this.name,
    required this.type,
    required this.supportedAssets,
    this.logoUrl,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    return ExchangeModel(
      id: json['id'],
      name: json['name'],
      type: ExchangeType.values.firstWhere(
        (e) => e.toString() == 'ExchangeType.${json['type']}',
        orElse: () => ExchangeType.equity,
      ),
      supportedAssets: (json['supportedAssets'] as List)
          .map((e) => AssetType.values.firstWhere(
                (a) => a.toString() == 'AssetType.$e',
                orElse: () => AssetType.equity,
              ))
          .toList(),
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'supportedAssets': supportedAssets
          .map((a) => a.toString().split('.').last)
          .toList(),
      'logoUrl': logoUrl,
    };
  }
}

/// Exchange Type
enum ExchangeType {
  equity,      // Equity/Derivatives brokers (Zerodha, Groww, etc.)
  crypto,      // Crypto exchanges (WazirX, CoinDCX, etc.)
  commodity,   // MCX for Gold
}

/// Asset Type
enum AssetType {
  equity,
  derivatives,
  btc,
  gold,
  digitalGold,
}

/// Indian Exchanges & Brokers
class IndianExchanges {
  // Equity/Derivatives Brokers
  static final List<ExchangeModel> equityBrokers = [
    ExchangeModel(
      id: 'zerodha',
      name: 'Zerodha',
      type: ExchangeType.equity,
      supportedAssets: [AssetType.equity, AssetType.derivatives],
    ),
    ExchangeModel(
      id: 'groww',
      name: 'Groww',
      type: ExchangeType.equity,
      supportedAssets: [AssetType.equity, AssetType.derivatives],
    ),
    ExchangeModel(
      id: 'dhan',
      name: 'Dhan',
      type: ExchangeType.equity,
      supportedAssets: [AssetType.equity, AssetType.derivatives],
    ),
    ExchangeModel(
      id: 'angel_one',
      name: 'Angel One',
      type: ExchangeType.equity,
      supportedAssets: [AssetType.equity, AssetType.derivatives],
    ),
    ExchangeModel(
      id: 'upstox',
      name: 'Upstox',
      type: ExchangeType.equity,
      supportedAssets: [AssetType.equity, AssetType.derivatives],
    ),
  ];

  // Crypto Exchanges
  static final List<ExchangeModel> cryptoExchanges = [
    ExchangeModel(
      id: 'wazirx',
      name: 'WazirX',
      type: ExchangeType.crypto,
      supportedAssets: [AssetType.btc],
    ),
    ExchangeModel(
      id: 'coindcx',
      name: 'CoinDCX',
      type: ExchangeType.crypto,
      supportedAssets: [AssetType.btc],
    ),
    ExchangeModel(
      id: 'delta',
      name: 'Delta Exchange',
      type: ExchangeType.crypto,
      supportedAssets: [AssetType.btc], // Crypto derivatives
    ),
  ];

  // Commodity Exchanges
  static final List<ExchangeModel> commodityExchanges = [
    ExchangeModel(
      id: 'mcx',
      name: 'MCX',
      type: ExchangeType.commodity,
      supportedAssets: [AssetType.gold],
    ),
  ];

  // Digital Gold Providers
  static final List<ExchangeModel> digitalGoldProviders = [
    ExchangeModel(
      id: 'digital_gold',
      name: 'Digital Gold',
      type: ExchangeType.commodity,
      supportedAssets: [AssetType.digitalGold],
    ),
  ];

  static List<ExchangeModel> getAllExchanges() {
    return [
      ...equityBrokers,
      ...cryptoExchanges,
      ...commodityExchanges,
      ...digitalGoldProviders,
    ];
  }

  static List<ExchangeModel> getExchangesForAsset(AssetType asset) {
    return getAllExchanges()
        .where((exchange) => exchange.supportedAssets.contains(asset))
        .toList();
  }
}
