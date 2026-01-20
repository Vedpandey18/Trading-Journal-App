import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Loading & Error Handling Pattern
/// Reusable widgets for consistent UX

/// Loading Indicator Widget
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spaceMD),
            Text(
              message!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutral700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error Display Widget
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.loss,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Text(
              'Error',
              style: AppTheme.heading3.copyWith(
                color: AppTheme.neutral700,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spaceLG),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty State Widget
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const EmptyState({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.neutral500,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Text(
              title,
              style: AppTheme.heading3.copyWith(
                color: AppTheme.neutral700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spaceSM),
              Text(
                subtitle!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Usage Pattern:
/// 
/// ```dart
/// class MyScreen extends StatefulWidget {
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
/// 
/// class _MyScreenState extends State<MyScreen> {
///   bool _isLoading = false;
///   String? _error;
///   List<TradeModel>? _trades;
/// 
///   @override
///   void initState() {
///     super.initState();
///     _loadTrades();
///   }
/// 
///   Future<void> _loadTrades() async {
///     setState(() {
///       _isLoading = true;
///       _error = null;
///     });
/// 
///     try {
///       final apiService = ApiService();
///       final trades = await apiService.getAllTrades();
///       setState(() {
///         _trades = trades;
///         _isLoading = false;
///       });
///     } catch (e) {
///       setState(() {
///         _error = e.toString();
///         _isLoading = false;
///       });
///     }
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     if (_isLoading) {
///       return LoadingIndicator(message: 'Loading trades...');
///     }
/// 
///     if (_error != null) {
///       return ErrorDisplay(
///         message: _error!,
///         onRetry: _loadTrades,
///       );
///     }
/// 
///     if (_trades == null || _trades!.isEmpty) {
///       return EmptyState(
///         title: 'No trades found',
///         subtitle: 'Add your first trade to get started',
///       );
///     }
/// 
///     return ListView.builder(
///       itemCount: _trades!.length,
///       itemBuilder: (context, index) {
///         return TradeCardWidget(trade: _trades![index]);
///       },
///     );
///   }
/// }
/// ```
