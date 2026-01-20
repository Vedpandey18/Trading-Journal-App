/// Indian Market Instrument Configuration
/// Defines lot sizes for Indian derivatives
class IndianInstrument {
  final String name;
  final int lotSize; // Quantity per lot

  const IndianInstrument({
    required this.name,
    required this.lotSize,
  });

  /// Get lot size for an instrument
  static int getLotSize(String instrument) {
    switch (instrument.toUpperCase()) {
      case 'NIFTY':
        return 65;
      case 'BANKNIFTY':
        return 15;
      case 'SENSEX':
        return 10;
      case 'FINNIFTY':
        return 40;
      case 'MIDCPNIFTY':
        return 75;
      default:
        return 1; // Default for stocks/other instruments
    }
  }

  /// Check if instrument has fixed lot size
  static bool hasFixedLotSize(String instrument) {
    final upper = instrument.toUpperCase();
    return upper == 'NIFTY' ||
        upper == 'BANKNIFTY' ||
        upper == 'SENSEX' ||
        upper == 'FINNIFTY' ||
        upper == 'MIDCPNIFTY';
  }

  /// Get all Indian derivatives
  static List<String> getIndianDerivatives() {
    return ['NIFTY', 'BANKNIFTY', 'SENSEX', 'FINNIFTY', 'MIDCPNIFTY'];
  }

  /// Get all instruments (derivatives + stocks)
  static List<String> getAllInstruments() {
    return [
      'NIFTY',
      'BANKNIFTY',
      'SENSEX',
      'FINNIFTY',
      'MIDCPNIFTY',
      'RELIANCE',
      'TCS',
      'INFY',
      'HDFC',
      'ICICIBANK',
      'HDFCBANK',
      'SBIN',
      'BHARTIARTL',
      'ITC',
      'Other',
    ];
  }
}
