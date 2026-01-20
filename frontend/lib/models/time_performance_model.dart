/// Time Performance Model
/// Analyzes performance by time of day
/// Descriptive only - shows patterns, not advice
class TimePerformanceModel {
  final Map<String, double> hourlyPnL; // hour -> avg P&L
  final String? bestHour;
  final String? worstHour;
  final Map<String, int> hourlyTradeCount; // hour -> trade count

  TimePerformanceModel({
    required this.hourlyPnL,
    this.bestHour,
    this.worstHour,
    required this.hourlyTradeCount,
  });

  factory TimePerformanceModel.fromJson(Map<String, dynamic> json) {
    return TimePerformanceModel(
      hourlyPnL: Map<String, double>.from(json['hourlyPnL'] ?? {}),
      bestHour: json['bestHour'],
      worstHour: json['worstHour'],
      hourlyTradeCount: Map<String, int>.from(json['hourlyTradeCount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hourlyPnL': hourlyPnL,
      'bestHour': bestHour,
      'worstHour': worstHour,
      'hourlyTradeCount': hourlyTradeCount,
    };
  }
}

/// Instrument Performance Model
class InstrumentPerformanceModel {
  final Map<String, double> instrumentPnL; // instrument -> total P&L
  final Map<String, int> instrumentTradeCount; // instrument -> count
  final String? bestInstrument;
  final String? worstInstrument;

  InstrumentPerformanceModel({
    required this.instrumentPnL,
    required this.instrumentTradeCount,
    this.bestInstrument,
    this.worstInstrument,
  });

  factory InstrumentPerformanceModel.fromJson(Map<String, dynamic> json) {
    return InstrumentPerformanceModel(
      instrumentPnL: Map<String, double>.from(json['instrumentPnL'] ?? {}),
      instrumentTradeCount:
          Map<String, int>.from(json['instrumentTradeCount'] ?? {}),
      bestInstrument: json['bestInstrument'],
      worstInstrument: json['worstInstrument'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instrumentPnL': instrumentPnL,
      'instrumentTradeCount': instrumentTradeCount,
      'bestInstrument': bestInstrument,
      'worstInstrument': worstInstrument,
    };
  }
}
