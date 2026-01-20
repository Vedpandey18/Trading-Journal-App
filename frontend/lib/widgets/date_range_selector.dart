import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Date Range Selector Widget
/// Allows traders to quickly filter by time period
enum DateRange {
  today,
  week,
  month,
  all,
}

class DateRangeSelector extends StatefulWidget {
  final DateRange initialRange;
  final Function(DateRange) onRangeChanged;

  const DateRangeSelector({
    Key? key,
    this.initialRange = DateRange.month,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late DateRange _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      child: Row(
        children: [
          _buildRangeButton('Today', DateRange.today),
          const SizedBox(width: AppTheme.spacingSM),
          _buildRangeButton('7D', DateRange.week),
          const SizedBox(width: AppTheme.spacingSM),
          _buildRangeButton('30D', DateRange.month),
          const SizedBox(width: AppTheme.spacingSM),
          _buildRangeButton('All', DateRange.all),
        ],
      ),
    );
  }

  Widget _buildRangeButton(String label, DateRange range) {
    final isSelected = _selectedRange == range;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRange = range;
          });
          widget.onRangeChanged(range);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
