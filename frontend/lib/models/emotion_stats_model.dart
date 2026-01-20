/// Emotion Stats Model
/// Tracks emotional states during trades
/// For self-analysis and pattern recognition
class EmotionStatsModel {
  final Map<String, int> emotionCounts; // emotion -> count
  final Map<String, double> emotionPnL; // emotion -> avg P&L
  final String? dominantEmotion;
  final String? mostProfitableEmotion;
  final String? leastProfitableEmotion;

  EmotionStatsModel({
    required this.emotionCounts,
    required this.emotionPnL,
    this.dominantEmotion,
    this.mostProfitableEmotion,
    this.leastProfitableEmotion,
  });

  factory EmotionStatsModel.fromJson(Map<String, dynamic> json) {
    return EmotionStatsModel(
      emotionCounts: Map<String, int>.from(json['emotionCounts'] ?? {}),
      emotionPnL: Map<String, double>.from(json['emotionPnL'] ?? {}),
      dominantEmotion: json['dominantEmotion'],
      mostProfitableEmotion: json['mostProfitableEmotion'],
      leastProfitableEmotion: json['leastProfitableEmotion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotionCounts': emotionCounts,
      'emotionPnL': emotionPnL,
      'dominantEmotion': dominantEmotion,
      'mostProfitableEmotion': mostProfitableEmotion,
      'leastProfitableEmotion': leastProfitableEmotion,
    };
  }
}

/// Emotion Types
enum EmotionType {
  calm,
  fear,
  greed,
  revenge,
  fomo, // Fear of Missing Out
  confident,
  anxious,
  disciplined,
}

extension EmotionTypeExtension on EmotionType {
  String get label {
    switch (this) {
      case EmotionType.calm:
        return 'Calm';
      case EmotionType.fear:
        return 'Fear';
      case EmotionType.greed:
        return 'Greed';
      case EmotionType.revenge:
        return 'Revenge';
      case EmotionType.fomo:
        return 'FOMO';
      case EmotionType.confident:
        return 'Confident';
      case EmotionType.anxious:
        return 'Anxious';
      case EmotionType.disciplined:
        return 'Disciplined';
    }
  }

  String get emoji {
    switch (this) {
      case EmotionType.calm:
        return '😌';
      case EmotionType.fear:
        return '😨';
      case EmotionType.greed:
        return '💰';
      case EmotionType.revenge:
        return '😤';
      case EmotionType.fomo:
        return '😰';
      case EmotionType.confident:
        return '😊';
      case EmotionType.anxious:
        return '😟';
      case EmotionType.disciplined:
        return '🎯';
    }
  }
}
