import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';
import '../../models/indian_instrument_model.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/trade_provider.dart';
import '../../widgets/paywall_widget.dart';

/// Professional Add Trade Screen - Indian Market
/// Modern fintech UI with auto lot → quantity calculation
/// Live P&L preview with Zerodha-style UX
class AddTradeScreenProfessional extends StatefulWidget {
  const AddTradeScreenProfessional({Key? key}) : super(key: key);

  @override
  State<AddTradeScreenProfessional> createState() => _AddTradeScreenProfessionalState();
}

class _AddTradeScreenProfessionalState extends State<AddTradeScreenProfessional> {
  final _formKey = GlobalKey<FormState>();
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _lotsController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  String? _selectedInstrument;
  String _tradeType = 'BUY';
  DateTime _selectedDate = DateTime.now();
  double? _calculatedPnL;
  int _calculatedQuantity = 0;
  int _lotSize = 1;

  final List<String> _instruments = IndianInstrument.getAllInstruments();

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(_updateCalculations);
    _exitPriceController.addListener(_updateCalculations);
    _lotsController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _lotsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Update quantity and P&L when inputs change
  void _updateCalculations() {
    // Update quantity based on lots
    final lots = int.tryParse(_lotsController.text) ?? 0;
    if (_selectedInstrument != null && lots > 0) {
      _lotSize = IndianInstrument.getLotSize(_selectedInstrument!);
      _calculatedQuantity = lots * _lotSize;
    } else {
      _calculatedQuantity = 0;
    }

    // Calculate P&L
    final entryPrice = double.tryParse(_entryPriceController.text);
    final exitPrice = double.tryParse(_exitPriceController.text);

    if (entryPrice != null && exitPrice != null && _calculatedQuantity > 0) {
      double pnl;
      if (_tradeType == 'BUY') {
        pnl = (exitPrice - entryPrice) * _calculatedQuantity;
      } else {
        pnl = (entryPrice - exitPrice) * _calculatedQuantity;
      }
      setState(() {
        _calculatedPnL = pnl;
      });
    } else {
      setState(() {
        _calculatedPnL = null;
      });
    }

    setState(() {}); // Trigger rebuild for quantity display
  }

  /// Handle instrument selection
  void _onInstrumentChanged(String? instrument) {
    setState(() {
      _selectedInstrument = instrument;
      if (instrument != null) {
        _lotSize = IndianInstrument.getLotSize(instrument);
        // Reset lots to 1 when instrument changes
        _lotsController.text = '1';
      }
    });
    _updateCalculations();
  }

  /// Handle trade type change
  void _onTradeTypeChanged(String type) {
    setState(() {
      _tradeType = type;
    });
    _updateCalculations();
  }

  /// Select trade date
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Save trade
  void _saveTrade() {
    if (!_formKey.currentState!.validate()) return;

    // Check subscription limit
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    
    final currentTradeCount = tradeProvider.trades.length;
    
    if (!subscriptionProvider.canAddTrade(currentTradeCount)) {
      PaywallHelper.showTradeLimitReached(context);
      return;
    }

    // TODO: Call API to save trade
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trade saved successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final tradeProvider = Provider.of<TradeProvider>(context);
    final currentTradeCount = tradeProvider.trades.length;
    final canAddMore = subscriptionProvider.canAddTrade(currentTradeCount);

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Add Trade'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Live P&L Preview Card (Sticky at top)
            if (_calculatedPnL != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.getPnLColor(_calculatedPnL).withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.getPnLColor(_calculatedPnL),
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Estimated P&L',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.neutral700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPnL(_calculatedPnL!),
                      style: AppTheme.heroNumber(
                        AppTheme.getPnLColor(_calculatedPnL),
                      ),
                    ),
                    if (_calculatedQuantity > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Quantity: $_calculatedQuantity',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.neutral500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Free Plan Warning
                    if (!subscriptionProvider.isProUser)
                      _FreePlanWarning(
                        currentCount: currentTradeCount,
                        canAddMore: canAddMore,
                      ),
                    if (!subscriptionProvider.isProUser)
                      const SizedBox(height: 16),

                    // Instrument Selection Card
                    _SectionCard(
                      title: 'Instrument',
                      icon: Icons.trending_up,
                      child: DropdownButtonFormField<String>(
                        value: _selectedInstrument,
                        decoration: const InputDecoration(
                          hintText: 'Select instrument',
                          border: InputBorder.none,
                        ),
                        items: _instruments.map((instrument) {
                          final hasLot = IndianInstrument.hasFixedLotSize(instrument);
                          return DropdownMenuItem(
                            value: instrument,
                            child: Row(
                              children: [
                                Text(instrument),
                                if (hasLot) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${IndianInstrument.getLotSize(instrument)}/lot',
                                      style: AppTheme.bodySmall.copyWith(
                                        color: AppTheme.primary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: _onInstrumentChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an instrument';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trade Type Card
                    _SectionCard(
                      title: 'Trade Type',
                      icon: Icons.swap_horiz,
                      child: Row(
                        children: [
                          Expanded(
                            child: _TradeTypeButton(
                              type: 'BUY',
                              icon: Icons.arrow_upward,
                              isSelected: _tradeType == 'BUY',
                              onTap: () => _onTradeTypeChanged('BUY'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TradeTypeButton(
                              type: 'SELL',
                              icon: Icons.arrow_downward,
                              isSelected: _tradeType == 'SELL',
                              onTap: () => _onTradeTypeChanged('SELL'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price Inputs Card
                    _SectionCard(
                      title: 'Price',
                      icon: Icons.attach_money,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _entryPriceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Entry Price',
                              hintText: '0.00',
                              prefixText: '₹ ',
                              prefixIcon: const Icon(Icons.arrow_downward),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Invalid price';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _exitPriceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Exit Price',
                              hintText: '0.00',
                              prefixText: '₹ ',
                              prefixIcon: const Icon(Icons.arrow_upward),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Invalid price';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lots & Quantity Card
                    _SectionCard(
                      title: 'Position Size',
                      icon: Icons.layers,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Lots Input
                          TextFormField(
                            controller: _lotsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Number of Lots',
                              hintText: '1',
                              prefixIcon: const Icon(Icons.numbers),
                              suffixText: _selectedInstrument != null &&
                                      IndianInstrument.hasFixedLotSize(
                                          _selectedInstrument!)
                                  ? '× $_lotSize = $_calculatedQuantity'
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final lots = int.tryParse(value);
                              if (lots == null || lots <= 0) {
                                return 'Must be > 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Quantity Display (Read-only)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: AppTheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Total Quantity',
                                      style: AppTheme.labelMedium.copyWith(
                                        color: AppTheme.neutral700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$_calculatedQuantity',
                                  style: AppTheme.mediumNumber(AppTheme.primary),
                                ),
                              ],
                            ),
                          ),

                          // Lot Size Info (if applicable)
                          if (_selectedInstrument != null &&
                              IndianInstrument.hasFixedLotSize(
                                  _selectedInstrument!))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: AppTheme.neutral500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_selectedInstrument}: $_lotSize qty per lot',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.neutral500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trade Date Card
                    _SectionCard(
                      title: 'Trade Date',
                      icon: Icons.calendar_today,
                      child: InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy').format(_selectedDate),
                                style: AppTheme.bodyLarge,
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes Card
                    _SectionCard(
                      title: 'Notes (Optional)',
                      icon: Icons.note,
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add any notes about this trade...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: canAddMore ? _saveTrade : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        canAddMore
                            ? 'Save Trade'
                            : 'Upgrade to Add More Trades',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPnL(double value) {
    if (value >= 0) {
      return '+₹${_formatNumber(value)}';
    }
    return '₹${_formatNumber(value)}';
  }

  String _formatNumber(double value) {
    if (value.abs() >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }
}

/// Section Card Widget
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Trade Type Button
class _TradeTypeButton extends StatelessWidget {
  final String type;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TradeTypeButton({
    required this.type,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == 'BUY' ? AppTheme.profit : AppTheme.loss;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppTheme.neutral300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppTheme.neutral700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : AppTheme.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Free Plan Warning Widget
class _FreePlanWarning extends StatelessWidget {
  final int currentCount;
  final bool canAddMore;

  const _FreePlanWarning({
    required this.currentCount,
    required this.canAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.warning),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Free Plan: $currentCount/10 trades used',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.warning,
              ),
            ),
          ),
          if (!canAddMore)
            TextButton(
              onPressed: () {
                // Navigate to subscription
              },
              child: const Text('Upgrade'),
            ),
        ],
      ),
    );
  }
}
