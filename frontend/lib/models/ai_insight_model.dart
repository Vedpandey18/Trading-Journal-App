/// AI Insight Model
/// Represents a single insight about trading behavior
/// Descriptive only - no advice or predictions
class AIInsightModel {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final InsightSeverity severity;
  final Map<String, dynamic>? supportingData;
  final DateTime? detectedAt;

  AIInsightModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    this.supportingData,
    this.detectedAt,
  });

  factory AIInsightModel.fromJson(Map<String, dynamic> json) {
    return AIInsightModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: InsightType.values.firstWhere(
        (e) => e.toString() == 'InsightType.${json['type']}',
        orElse: () => InsightType.pattern,
      ),
      severity: InsightSeverity.values.firstWhere(
        (e) => e.toString() == 'InsightSeverity.${json['severity']}',
        orElse: () => InsightSeverity.neutral,
      ),
      supportingData: json['supportingData'],
      detectedAt: json['detectedAt'] != null
          ? DateTime.parse(json['detectedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'severity': severity.toString().split('.').last,
      'supportingData': supportingData,
      'detectedAt': detectedAt?.toIso8601String(),
    };
  }
}

enum InsightType {
  pattern,      // Loss patterns, win patterns
  timing,       // Time-based insights
  instrument,   // Instrument-specific
  psychology,   // Emotional patterns
  consistency,  // Consistency metrics
}

enum InsightSeverity {
  positive,     // Good pattern
  neutral,      // Informational
  warning,      // Needs attention
  critical,     // Strong pattern to be aware of
}
