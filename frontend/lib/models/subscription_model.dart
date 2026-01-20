/// Subscription Model
/// Represents user subscription status
class SubscriptionModel {
  final String planType; // "FREE" or "PRO"
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;

  SubscriptionModel({
    required this.planType,
    this.startDate,
    this.endDate,
    this.isActive = false,
    this.razorpayOrderId,
    this.razorpayPaymentId,
  });

  bool get isPro => planType == 'PRO' && isActive;
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  bool get isValidPro => isPro && !isExpired;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      planType: json['planType'] ?? 'FREE',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      isActive: json['isActive'] ?? false,
      razorpayOrderId: json['razorpayOrderId'],
      razorpayPaymentId: json['razorpayPaymentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planType': planType,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
    };
  }
}
