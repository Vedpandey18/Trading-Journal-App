import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trade_card.dart';
import '../../widgets/date_range_selector.dart';
import '../../providers/trade_provider.dart';
import 'package:intl/intl.dart';

/// Trades List Screen
/// Displays all trades in a clean, filterable list
/// Mobile-friendly card-based design (instead of table)
class TradesListScreen extends StatefulWidget {
  const TradesListScreen({Key? key}) : super(key: key);

  @override
  State<TradesListScreen> createState() => _TradesListScreenState();
}

class _TradesListScreenState extends State<TradesListScreen> {
  DateRange _selectedRange = DateRange.all;
  String? _selectedInstrument;
  String? _selectedPnLFilter; // "profit", "loss", null = all

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

  List<Map<String, dynamic>> get _filteredTrades {
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    final allTrades = tradeProvider.trades;
    
    return allTrades.where((trade) {
      // Date filter
      final tradeDateStr = trade['tradeDate'] as String?;
      if (tradeDateStr == null) return false;
      final tradeDate = DateTime.parse(tradeDateStr);
      final now = DateTime.now();
      switch (_selectedRange) {
        case DateRange.today:
          if (tradeDate.day != now.day ||
              tradeDate.month != now.month ||
              tradeDate.year != now.year) return false;
          break;
        case DateRange.week:
          if (tradeDate.isBefore(now.subtract(const Duration(days: 7)))) {
            return false;
          }
          break;
        case DateRange.month:
          if (tradeDate.isBefore(now.subtract(const Duration(days: 30)))) {
            return false;
          }
          break;
        case DateRange.all:
          break;
      }

      // Instrument filter
      if (_selectedInstrument != null &&
          trade['instrument'] != _selectedInstrument) {
        return false;
      }

      // P&L filter
      if (_selectedPnLFilter != null) {
        final pnl = trade['profitLoss'] as double;
        if (_selectedPnLFilter == 'profit' && pnl <= 0) return false;
        if (_selectedPnLFilter == 'loss' && pnl >= 0) return false;
      }

      return true;
    }).toList();
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
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('My Trades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Selector
          Container(
            color: AppTheme.backgroundWhite,
            padding: AppTheme.screenPaddingHorizontal,
            child: DateRangeSelector(
              initialRange: _selectedRange,
              onRangeChanged: (range) {
                setState(() {
                  _selectedRange = range;
                });
              },
            ),
          ),

          // Active Filters (if any)
          if (_selectedInstrument != null || _selectedPnLFilter != null)
            Container(
              color: AppTheme.backgroundWhite,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
                vertical: AppTheme.spacingSM,
              ),
              child: Row(
                children: [
                  if (_selectedInstrument != null)
                    _FilterChip(
                      label: _selectedInstrument!,
                      onDeleted: () {
                        setState(() {
                          _selectedInstrument = null;
                        });
                      },
                    ),
                  if (_selectedPnLFilter != null) ...[
                    const SizedBox(width: AppTheme.spacingSM),
                    _FilterChip(
                      label: _selectedPnLFilter == 'profit'
                          ? 'Profit Only'
                          : 'Loss Only',
                      onDeleted: () {
                        setState(() {
                          _selectedPnLFilter = null;
                        });
                      },
                    ),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedInstrument = null;
                        _selectedPnLFilter = null;
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
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
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () => tradeProvider.fetchTrades(),
                  child: ListView.builder(
                    padding: AppTheme.screenPadding,
                    itemCount: filteredTrades.length,
                    itemBuilder: (context, index) {
                      final trade = filteredTrades[index];
                      final tradeDate = trade['tradeDate'] != null
                          ? DateTime.parse(trade['tradeDate'])
                          : DateTime.now();
                      
                      return TradeCard(
                        instrument: trade['instrument'] ?? '',
                        tradeType: trade['tradeType'] ?? 'BUY',
                        entryPrice: (trade['entryPrice'] as num?)?.toDouble() ?? 0.0,
                        exitPrice: (trade['exitPrice'] as num?)?.toDouble() ?? 0.0,
                        quantity: (trade['quantity'] as num?)?.toInt() ?? 0,
                        lotSize: (trade['lotSize'] as num?)?.toInt() ?? 1,
                        profitLoss: (trade['profitLoss'] as num?)?.toDouble() ?? 0.0,
                        tradeDate: tradeDate,
                        notes: trade['notes'],
                        onDelete: () {
                          _showDeleteConfirmation(trade, tradeProvider);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            'No trades found',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            'Try adjusting your filters',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: AppTheme.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Trades',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppTheme.spacingLG),
            // Instrument Filter
            Text(
              'Instrument',
              style: AppTheme.labelMedium,
            ),
            const SizedBox(height: AppTheme.spacingSM),
            Wrap(
              spacing: AppTheme.spacingSM,
              children: [
                _buildFilterOption(
                  'All',
                  _selectedInstrument == null,
                  () {
                    setState(() {
                      _selectedInstrument = null;
                    });
                    Navigator.pop(context);
                  },
                ),
                ..._uniqueInstruments.map((instrument) =>
                    _buildFilterOption(
                      instrument,
                      _selectedInstrument == instrument,
                      () {
                        setState(() {
                          _selectedInstrument = instrument;
                        });
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLG),
            // P&L Filter
            Text(
              'Profit/Loss',
              style: AppTheme.labelMedium,
            ),
            const SizedBox(height: AppTheme.spacingSM),
            Wrap(
              spacing: AppTheme.spacingSM,
              children: [
                _buildFilterOption(
                  'All',
                  _selectedPnLFilter == null,
                  () {
                    setState(() {
                      _selectedPnLFilter = null;
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildFilterOption(
                  'Profit Only',
                  _selectedPnLFilter == 'profit',
                  () {
                    setState(() {
                      _selectedPnLFilter = 'profit';
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildFilterOption(
                  'Loss Only',
                  _selectedPnLFilter == 'loss',
                  () {
                    setState(() {
                      _selectedPnLFilter = 'loss';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLG),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    Map<String, dynamic> trade,
    TradeProvider tradeProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trade'),
        content: Text(
          'Are you sure you want to delete this ${trade['instrument']} trade?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.lossRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final tradeId = trade['id'] as int?;
      if (tradeId != null) {
        final success = await tradeProvider.deleteTrade(tradeId);
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
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              size: 16,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
