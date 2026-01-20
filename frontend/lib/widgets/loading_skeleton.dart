import 'package:flutter/material.dart';

/// Loading Skeleton Widgets
/// Show placeholders while data loads
/// Provides smooth UX during API calls

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: const ShimmerEffect(),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simplified shimmer - no animation for better performance
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }
}

/// Dashboard Loading Skeleton
class DashboardLoadingSkeleton extends StatelessWidget {
  const DashboardLoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero P&L Card Skeleton
          const LoadingSkeleton(
            width: double.infinity,
            height: 120,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 16),
          // Metrics Row 1
          Row(
            children: [
              Expanded(
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 100,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 100,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Metrics Row 2
          Row(
            children: [
              Expanded(
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 100,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 100,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart Skeleton
          const LoadingSkeleton(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 24),
          // Recent Trades Skeleton
          ...List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 80,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              )),
        ],
      ),
    );
  }
}

/// Trade List Loading Skeleton
class TradeListLoadingSkeleton extends StatelessWidget {
  const TradeListLoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LoadingSkeleton(
            width: double.infinity,
            height: 100,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        );
      },
    );
  }
}
