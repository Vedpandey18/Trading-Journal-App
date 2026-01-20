/// Discipline Score Model
/// Measures trading discipline based on behavior patterns
/// Score 0-100, higher is better
class DisciplineScoreModel {
  final int score; // 0-100
  final String level; // "Excellent", "Good", "Needs Improvement", "Poor"
  final Map<String, double> factors; // Breakdown of factors
  final String? feedback;

  DisciplineScoreModel({
    required this.score,
    required this.level,
    required this.factors,
    this.feedback,
  });

  factory DisciplineScoreModel.fromJson(Map<String, dynamic> json) {
    return DisciplineScoreModel(
      score: json['score'],
      level: json['level'],
      factors: Map<String, double>.from(json['factors'] ?? {}),
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level,
      'factors': factors,
      'feedback': feedback,
    };
  }
}

/// Consistency Badge Model
enum ConsistencyLevel {
  poor,
  average,
  strong,
  excellent,
}

extension ConsistencyLevelExtension on ConsistencyLevel {
  String get label {
    switch (this) {
      case ConsistencyLevel.poor:
        return 'Poor';
      case ConsistencyLevel.average:
        return 'Average';
      case ConsistencyLevel.strong:
        return 'Strong';
      case ConsistencyLevel.excellent:
        return 'Excellent';
    }
  }

  String get description {
    switch (this) {
      case ConsistencyLevel.poor:
        return 'High variance in performance';
      case ConsistencyLevel.average:
        return 'Moderate consistency';
      case ConsistencyLevel.strong:
        return 'Good consistency in trading';
      case ConsistencyLevel.excellent:
        return 'Very consistent performance';
    }
  }
}
