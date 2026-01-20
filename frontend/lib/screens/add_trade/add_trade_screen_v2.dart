import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/trade_provider.dart';
import '../../widgets/paywall_widget.dart';

/// Add Trade Screen
/// Updated with subscription limit checking
/// Shows paywall when free user reaches limit
class AddTradeScreenV2 extends StatefulWidget {
  const AddTradeScreenV2({Key? key}) : super(key: key);

  @override
  State<AddTradeScreenV2> createState() => _AddTradeScreenV2State();
}

class _AddTradeScreenV2State extends State<AddTradeScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final _instrumentController = TextEditingController();
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lotSizeController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  String _tradeType = 'BUY';
  DateTime _selectedDate = DateTime.now();
  double? _calculatedPnL;

  final List<String> _instruments = [
    'NIFTY',
    'BANKNIFTY',
    'FINNIFTY',
    'RELIANCE',
    'TCS',
    'INFY',
    'HDFC',
    'ICICIBANK',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(_calculatePnL);
    _exitPriceController.addListener(_calculatePnL);
    _quantityController.addListener(_calculatePnL);
    _lotSizeController.addListener(_calculatePnL);
  }

  @override
  void dispose() {
    _instrumentController.dispose();
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _quantityController.dispose();
    _lotSizeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculatePnL() {
    final entryPrice = double.tryParse(_entryPriceController.text);
    final exitPrice = double.tryParse(_exitPriceController.text);
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final lotSize = int.tryParse(_lotSizeController.text) ?? 1;

    if (entryPrice != null && exitPrice != null && quantity > 0) {
      final totalQuantity = quantity * lotSize;
      double pnl;
      if (_tradeType == 'BUY') {
        pnl = (exitPrice - entryPrice) * totalQuantity;
      } else {
        pnl = (entryPrice - exitPrice) * totalQuantity;
      }
      setState(() {
        _calculatedPnL = pnl;
      });
    } else {
      setState(() {
        _calculatedPnL = null;
      });
    }
  }

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

  void _saveTrade() {
    if (!_formKey.currentState!.validate()) return;

    // Check subscription limit
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    
    final currentTradeCount = tradeProvider.trades.length;
    
    if (!subscriptionProvider.canAddTrade(currentTradeCount)) {
      // Show paywall
      PaywallHelper.showTradeLimitReached(context);
      return;
    }

    // Save trade
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Free Plan Limit Warning (if applicable)
              if (!subscriptionProvider.isProUser)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    border: Border.all(color: AppTheme.warning),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Free Plan: $currentTradeCount/10 trades used',
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
                ),

              // Instrument Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Instrument',
                  prefixIcon: Icon(Icons.trending_up),
                ),
                items: _instruments.map((instrument) {
                  return DropdownMenuItem(
                    value: instrument,
                    child: Text(instrument),
                  );
                }).toList(),
                onChanged: (value) {
                  _instrumentController.text = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an instrument';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Trade Type Toggle
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trade Type',
                      style: AppTheme.labelLarge,
                    ),
                    const SizedBox(height: AppTheme.spaceSM),
                    Row(
                      children: [
                        Expanded(
                          child: _TradeTypeButton(
                            type: 'BUY',
                            icon: Icons.arrow_upward,
                            isSelected: _tradeType == 'BUY',
                            onTap: () {
                              setState(() {
                                _tradeType = 'BUY';
                              });
                              _calculatePnL();
                            },
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceMD),
                        Expanded(
                          child: _TradeTypeButton(
                            type: 'SELL',
                            icon: Icons.arrow_downward,
                            isSelected: _tradeType == 'SELL',
                            onTap: () {
                              setState(() {
                                _tradeType = 'SELL';
                              });
                              _calculatePnL();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Entry & Exit Price Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _entryPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Entry Price',
                        prefixIcon: Icon(Icons.arrow_downward),
                        prefixText: '₹',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: TextFormField(
                      controller: _exitPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Exit Price',
                        prefixIcon: Icon(Icons.arrow_upward),
                        prefixText: '₹',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Quantity & Lot Size Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: TextFormField(
                      controller: _lotSizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Lot Size',
                        prefixIcon: Icon(Icons.layers),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Trade Date
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Trade Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: AppTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppTheme.spaceLG),

              // Live P&L Display
              if (_calculatedPnL != null)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceLG),
                  decoration: BoxDecoration(
                    color: AppTheme.getPnLColor(_calculatedPnL)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    border: Border.all(
                      color: AppTheme.getPnLColor(_calculatedPnL),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Estimated P&L',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: AppTheme.spaceSM),
                      Text(
                        _formatPnL(_calculatedPnL!),
                        style: AppTheme.getPnLTextStyle(
                          _calculatedPnL,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.spaceLG),

              // Save Button
              ElevatedButton(
                onPressed: canAddMore ? _saveTrade : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  canAddMore ? 'Save Trade' : 'Upgrade to Add More Trades',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPnL(double value) {
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}

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
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
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
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
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
