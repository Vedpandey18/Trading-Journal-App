import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

/// Add Trade Screen
/// Clean form for adding new trades
/// Features live P&L calculation as user types
class AddTradeScreen extends StatefulWidget {
  const AddTradeScreen({Key? key}) : super(key: key);

  @override
  State<AddTradeScreen> createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends State<AddTradeScreen> {
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

  // Common instruments
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
    if (_formKey.currentState!.validate()) {
      // Save trade to API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trade saved successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Add Trade'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: AppTheme.spacingMD),

              // Trade Type Toggle
              Container(
                padding: AppTheme.cardPadding,
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trade Type',
                      style: AppTheme.labelMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTradeTypeButton('BUY', Icons.arrow_upward),
                        ),
                        const SizedBox(width: AppTheme.spacingMD),
                        Expanded(
                          child: _buildTradeTypeButton('SELL', Icons.arrow_downward),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMD),

              // Entry & Exit Price Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _entryPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: TextFormField(
                      controller: _exitPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMD),

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
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
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
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMD),

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
              const SizedBox(height: AppTheme.spacingMD),

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
              const SizedBox(height: AppTheme.spacingLG),

              // Live P&L Display
              if (_calculatedPnL != null)
                Container(
                  padding: AppTheme.cardPaddingLarge,
                  decoration: BoxDecoration(
                    color: AppTheme.getPnLColor(_calculatedPnL)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.getPnLColor(_calculatedPnL),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Estimated P&L',
                        style: AppTheme.labelMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingSM),
                      Text(
                        _formatPnL(_calculatedPnL!),
                        style: AppTheme.getPnLTextStyle(
                          _calculatedPnL,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.spacingLG),

              // Save Button
              ElevatedButton(
                onPressed: _saveTrade,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Trade'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeTypeButton(String type, IconData icon) {
    final isSelected = _tradeType == type;
    final color = type == 'BUY' ? AppTheme.profitGreen : AppTheme.lossRed;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tradeType = type;
        });
        _calculatePnL();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : AppTheme.textPrimary,
              ),
            ),
          ],
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
