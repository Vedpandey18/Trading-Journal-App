import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../widgets/trade_card_widget.dart';
import '../../models/trade_model.dart';
import '../../providers/trade_provider.dart';
import 'package:intl/intl.dart';

/// Trades List Screen
/// Card-based list (mobile-friendly alternative to tables)
/// Includes filtering by date, instrument, and P&L
class TradesListScreenV2 extends StatefulWidget {
  const TradesListScreenV2({Key? key}) : super(key: key);

  @override
  State<TradesListScreenV2> createState() => _TradesListScreenV2State();
}

class _TradesListScreenV2State extends State<TradesListScreenV2> {
  DateRange _selectedRange = DateRange.all;
  String? _selectedInstrument;
  PnLFilter? _selectedPnLFilter;

  @override
  void initState() {
    super.initState();
    // Fetch trades from API on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      if (tradeProvider.trades.isEmpty) {
        tradeProvider.fetchTrades();
      }
    });
  }

  List<TradeModel> get _filteredTrades {
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    final allTrades = tradeProvider.trades.map((trade) {
      return TradeModel(
        id: trade['id'] as int?,
        instrument: trade['instrument'] ?? '',
        tradeType: trade['tradeType'] ?? 'BUY',
        entryPrice: (trade['entryPrice'] as num?)?.toDouble() ?? 0.0,
        exitPrice: (trade['exitPrice'] as num?)?.toDouble() ?? 0.0,
        quantity: (trade['quantity'] as num?)?.toInt() ?? 0,
        lotSize: (trade['lotSize'] as num?)?.toInt() ?? 1,
        tradeDate: trade['tradeDate'] != null
            ? DateTime.parse(trade['tradeDate'])
            : DateTime.now(),
        profitLoss: (trade['profitLoss'] as num?)?.toDouble(),
        notes: trade['notes'],
      );
    }).toList();
    
    return allTrades.where((trade) {
      // Date filter
      if (!_matchesDateRange(trade.tradeDate)) return false;

      // Instrument filter
      if (_selectedInstrument != null &&
          trade.instrument != _selectedInstrument) {
        return false;
      }

      // P&L filter
      if (_selectedPnLFilter != null) {
        if (_selectedPnLFilter == PnLFilter.profitOnly &&
            (trade.profitLoss == null || trade.profitLoss! <= 0)) {
          return false;
        }
        if (_selectedPnLFilter == PnLFilter.lossOnly &&
            (trade.profitLoss == null || trade.profitLoss! >= 0)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool _matchesDateRange(DateTime date) {
    final now = DateTime.now();
    switch (_selectedRange) {
      case DateRange.today:
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case DateRange.week:
        return date.isAfter(now.subtract(const Duration(days: 7)));
      case DateRange.month:
        return date.isAfter(now.subtract(const Duration(days: 30)));
      case DateRange.all:
        return true;
    }
  }

  List<String> get _uniqueInstruments {
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    return tradeProvider.trades
        .map((t) => t['instrument'] as String? ?? '')
        .where((instrument) => instrument.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('My Trades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Selector
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMD,
              vertical: AppTheme.spaceSM,
            ),
            child: _DateRangeSelector(
              selectedRange: _selectedRange,
              onRangeChanged: (range) {
                setState(() {
                  _selectedRange = range;
                });
              },
            ),
          ),

          // Active Filters
          if (_selectedInstrument != null || _selectedPnLFilter != null)
            Container(
              color: AppTheme.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceMD,
                vertical: AppTheme.spaceSM,
              ),
              child: _ActiveFilters(
                selectedInstrument: _selectedInstrument,
                selectedPnLFilter: _selectedPnLFilter,
                onClearInstrument: () {
                  setState(() {
                    _selectedInstrument = null;
                  });
                },
                onClearPnL: () {
                  setState(() {
                    _selectedPnLFilter = null;
                  });
                },
                onClearAll: () {
                  setState(() {
                    _selectedInstrument = null;
                    _selectedPnLFilter = null;
                  });
                },
              ),
            ),

          // Trades List
          Expanded(
            child: Consumer<TradeProvider>(
              builder: (context, tradeProvider, _) {
                if (tradeProvider.isLoading && tradeProvider.trades.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final filteredTrades = _filteredTrades;
                
                if (filteredTrades.isEmpty) {
                  return _EmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () => tradeProvider.fetchTrades(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spaceMD),
                    itemCount: filteredTrades.length,
                    itemBuilder: (context, index) {
                      return TradeCardWidget(
                        trade: filteredTrades[index],
                        onDelete: () {
                          _showDeleteConfirmation(filteredTrades[index], tradeProvider);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterSheet(
        uniqueInstruments: _uniqueInstruments,
        selectedInstrument: _selectedInstrument,
        selectedPnLFilter: _selectedPnLFilter,
        onInstrumentSelected: (instrument) {
          setState(() {
            _selectedInstrument = instrument;
          });
          Navigator.pop(context);
        },
        onPnLFilterSelected: (filter) {
          setState(() {
            _selectedPnLFilter = filter;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    TradeModel trade,
    TradeProvider tradeProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trade'),
        content: Text('Delete ${trade.instrument} trade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.loss),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && trade.id != null && mounted) {
      final success = await tradeProvider.deleteTrade(trade.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Trade deleted successfully'
                : tradeProvider.error ?? 'Failed to delete trade'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}

enum PnLFilter { profitOnly, lossOnly }

class _DateRangeSelector extends StatelessWidget {
  final DateRange selectedRange;
  final Function(DateRange) onRangeChanged;

  const _DateRangeSelector({
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      child: Row(
        children: [
          _buildButton('Today', DateRange.today),
          const SizedBox(width: 4),
          _buildButton('7D', DateRange.week),
          const SizedBox(width: 4),
          _buildButton('30D', DateRange.month),
          const SizedBox(width: 4),
          _buildButton('All', DateRange.all),
        ],
      ),
    );
  }

  Widget _buildButton(String label, DateRange range) {
    final isSelected = selectedRange == range;
    return Expanded(
      child: GestureDetector(
        onTap: () => onRangeChanged(range),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.white : AppTheme.neutral700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveFilters extends StatelessWidget {
  final String? selectedInstrument;
  final PnLFilter? selectedPnLFilter;
  final VoidCallback onClearInstrument;
  final VoidCallback onClearPnL;
  final VoidCallback onClearAll;

  const _ActiveFilters({
    required this.selectedInstrument,
    required this.selectedPnLFilter,
    required this.onClearInstrument,
    required this.onClearPnL,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (selectedInstrument != null)
          _FilterChip(
            label: selectedInstrument!,
            onDeleted: onClearInstrument,
          ),
        if (selectedPnLFilter != null) ...[
          if (selectedInstrument != null) const SizedBox(width: AppTheme.spaceSM),
          _FilterChip(
            label: selectedPnLFilter == PnLFilter.profitOnly
                ? 'Profit Only'
                : 'Loss Only',
            onDeleted: onClearPnL,
          ),
        ],
        const Spacer(),
        if (selectedInstrument != null || selectedPnLFilter != null)
          TextButton(
            onPressed: onClearAll,
            child: const Text('Clear All'),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _FilterChip({
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              size: 16,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final List<String> uniqueInstruments;
  final String? selectedInstrument;
  final PnLFilter? selectedPnLFilter;
  final Function(String?) onInstrumentSelected;
  final Function(PnLFilter?) onPnLFilterSelected;

  const _FilterSheet({
    required this.uniqueInstruments,
    required this.selectedInstrument,
    required this.selectedPnLFilter,
    required this.onInstrumentSelected,
    required this.onPnLFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Trades',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppTheme.spaceLG),
          // Instrument Filter
          Text(
            'Instrument',
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Wrap(
            spacing: AppTheme.spaceSM,
            runSpacing: AppTheme.spaceSM,
            children: [
              _FilterOption(
                'All',
                selectedInstrument == null,
                () => onInstrumentSelected(null),
              ),
              ...uniqueInstruments.map((instrument) => _FilterOption(
                    instrument,
                    selectedInstrument == instrument,
                    () => onInstrumentSelected(instrument),
                  )),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),
          // P&L Filter
          Text(
            'Profit/Loss',
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Wrap(
            spacing: AppTheme.spaceSM,
            runSpacing: AppTheme.spaceSM,
            children: [
              _FilterOption(
                'All',
                selectedPnLFilter == null,
                () => onPnLFilterSelected(null),
              ),
              _FilterOption(
                'Profit Only',
                selectedPnLFilter == PnLFilter.profitOnly,
                () => onPnLFilterSelected(PnLFilter.profitOnly),
              ),
              _FilterOption(
                'Loss Only',
                selectedPnLFilter == PnLFilter.lossOnly,
                () => onPnLFilterSelected(PnLFilter.lossOnly),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption(
    this.label,
    this.isSelected,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.neutral300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            color: isSelected ? AppTheme.white : AppTheme.neutral900,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppTheme.neutral500,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'No trades found',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.neutral700,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Try adjusting your filters',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
