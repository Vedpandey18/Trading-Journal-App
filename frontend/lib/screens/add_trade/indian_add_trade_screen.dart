import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';
import '../../models/exchange_model.dart';
import '../../models/indian_trade_model.dart';

/// Indian Market Add Trade Screen
/// Exchange-aware trade entry for BTC and Gold
/// Supports Indian brokers and exchanges
class IndianAddTradeScreen extends StatefulWidget {
  const IndianAddTradeScreen({Key? key}) : super(key: key);

  @override
  State<IndianAddTradeScreen> createState() => _IndianAddTradeScreenState();
}

class _IndianAddTradeScreenState extends State<IndianAddTradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _btcQuantityController = TextEditingController();
  final _feesController = TextEditingController();
  final _leverageController = TextEditingController();
  final _lotSizeController = TextEditingController();
  final _numberOfLotsController = TextEditingController();
  final _goldQuantityController = TextEditingController();
  final _notesController = TextEditingController();

  AssetType _selectedAsset = AssetType.btc;
  ExchangeModel? _selectedExchange;
  String _tradeType = 'BUY';
  GoldTradeType? _goldTradeType;
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedTime;
  double? _calculatedPnL;

  // MCX Gold lot size (fixed: 100 grams per lot)
  static const int mcxGoldLotSize = 100;

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(_calculatePnL);
    _exitPriceController.addListener(_calculatePnL);
    _btcQuantityController.addListener(_calculatePnL);
    _feesController.addListener(_calculatePnL);
    _numberOfLotsController.addListener(_calculatePnL);
    _goldQuantityController.addListener(_calculatePnL);
    _lotSizeController.text = mcxGoldLotSize.toString();
  }

  @override
  void dispose() {
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _btcQuantityController.dispose();
    _feesController.dispose();
    _leverageController.dispose();
    _lotSizeController.dispose();
    _numberOfLotsController.dispose();
    _goldQuantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculatePnL() {
    final entryPrice = double.tryParse(_entryPriceController.text);
    final exitPrice = double.tryParse(_exitPriceController.text);

    if (entryPrice == null || exitPrice == null) {
      setState(() {
        _calculatedPnL = null;
      });
      return;
    }

    double pnl = 0.0;

    if (_selectedAsset == AssetType.btc) {
      final quantity = double.tryParse(_btcQuantityController.text) ?? 0.0;
      final fees = double.tryParse(_feesController.text) ?? 0.0;
      pnl = (exitPrice - entryPrice) * quantity - fees;
    } else if (_selectedAsset == AssetType.gold) {
      if (_goldTradeType == GoldTradeType.mcx) {
        final lotSize = int.tryParse(_lotSizeController.text) ?? mcxGoldLotSize;
        final numberOfLots = int.tryParse(_numberOfLotsController.text) ?? 0;
        pnl = (exitPrice - entryPrice) * lotSize * numberOfLots;
      } else {
        final quantity = double.tryParse(_goldQuantityController.text) ?? 0.0;
        pnl = (exitPrice - entryPrice) * quantity;
      }
    }

    if (_tradeType == 'SELL') {
      pnl = -pnl;
    }

    setState(() {
      _calculatedPnL = pnl;
    });
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

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveTrade() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExchange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an exchange/broker'),
          backgroundColor: AppTheme.loss,
        ),
      );
      return;
    }

    // Save trade
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
    final availableExchanges = IndianExchanges.getExchangesForAsset(_selectedAsset);

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
              // Asset Type Selection
              _AssetTypeSelector(
                selectedAsset: _selectedAsset,
                onAssetChanged: (asset) {
                  setState(() {
                    _selectedAsset = asset;
                    _selectedExchange = null;
                    if (asset == AssetType.gold) {
                      _goldTradeType = GoldTradeType.mcx;
                    }
                  });
                  _calculatePnL();
                },
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Exchange/Broker Selection
              DropdownButtonFormField<ExchangeModel>(
                decoration: const InputDecoration(
                  labelText: 'Exchange / Broker',
                  prefixIcon: Icon(Icons.account_balance),
                  hintText: 'Select exchange or broker',
                ),
                value: _selectedExchange,
                items: availableExchanges.map((exchange) {
                  return DropdownMenuItem(
                    value: exchange,
                    child: Text(exchange.name),
                  );
                }).toList(),
                onChanged: (exchange) {
                  setState(() {
                    _selectedExchange = exchange;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an exchange/broker';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spaceMD),

              // Gold Trade Type (if Gold selected)
              if (_selectedAsset == AssetType.gold)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gold Trade Type',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: AppTheme.spaceSM),
                      Row(
                        children: [
                          Expanded(
                            child: _GoldTypeButton(
                              type: GoldTradeType.mcx,
                              label: 'MCX Gold',
                              isSelected: _goldTradeType == GoldTradeType.mcx,
                              onTap: () {
                                setState(() {
                                  _goldTradeType = GoldTradeType.mcx;
                                });
                                _calculatePnL();
                              },
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceMD),
                          Expanded(
                            child: _GoldTypeButton(
                              type: GoldTradeType.digitalGold,
                              label: 'Digital Gold',
                              isSelected:
                                  _goldTradeType == GoldTradeType.digitalGold,
                              onTap: () {
                                setState(() {
                                  _goldTradeType = GoldTradeType.digitalGold;
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
              if (_selectedAsset == AssetType.gold)
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

              // Entry & Exit Price
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

              // BTC-Specific Fields
              if (_selectedAsset == AssetType.btc) ...[
                TextFormField(
                  controller: _btcQuantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Quantity (BTC)',
                    prefixIcon: Icon(Icons.currency_bitcoin),
                    hintText: '0.00123456',
                    helperText: 'Fractional BTC allowed (up to 8 decimals)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final quantity = double.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Invalid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spaceMD),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _feesController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Trading Fees (₹)',
                          prefixIcon: Icon(Icons.receipt),
                          prefixText: '₹',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMD),
                    Expanded(
                      child: TextFormField(
                        controller: _leverageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Leverage (Optional)',
                          prefixIcon: Icon(Icons.trending_up),
                          hintText: 'For Delta Exchange',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMD),
              ],

              // Gold-Specific Fields
              if (_selectedAsset == AssetType.gold) ...[
                if (_goldTradeType == GoldTradeType.mcx) ...[
                  // MCX Gold: Lot Size (auto) + Number of Lots
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lotSizeController,
                          keyboardType: TextInputType.number,
                          enabled: false, // Auto-filled
                          decoration: const InputDecoration(
                            labelText: 'Lot Size (grams)',
                            prefixIcon: Icon(Icons.layers),
                            helperText: 'Auto: 100 grams per lot (MCX standard)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceMD),
                      Expanded(
                        child: TextFormField(
                          controller: _numberOfLotsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Number of Lots',
                            prefixIcon: Icon(Icons.numbers),
                            helperText: 'Total = Lot Size × Lots',
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
                  // Total Quantity Display (MCX)
                  if (_numberOfLotsController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spaceMD),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Quantity:',
                            style: AppTheme.labelMedium,
                          ),
                          Text(
                            '${(int.tryParse(_lotSizeController.text) ?? mcxGoldLotSize) * (int.tryParse(_numberOfLotsController.text) ?? 0)} grams',
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ] else ...[
                  // Digital Gold: Quantity in grams
                  TextFormField(
                    controller: _goldQuantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Quantity (grams)',
                      prefixIcon: Icon(Icons.scale),
                      hintText: '1.5',
                      helperText: 'Quantity in grams',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: AppTheme.spaceMD),
              ],

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: InkWell(
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
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Trade Time (Optional)',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? DateFormat('hh:mm a').format(_selectedTime!)
                              : 'Not set',
                          style: AppTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
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

  String _formatPnL(double value) {
    if (value >= 0) {
      return '+₹${value.toStringAsFixed(2)}';
    }
    return '₹${value.toStringAsFixed(2)}';
  }
}

/// Asset Type Selector
class _AssetTypeSelector extends StatelessWidget {
  final AssetType selectedAsset;
  final Function(AssetType) onAssetChanged;

  const _AssetTypeSelector({
    required this.selectedAsset,
    required this.onAssetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Type',
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Row(
            children: [
              Expanded(
                child: _AssetButton(
                  asset: AssetType.btc,
                  label: 'BTC (Crypto)',
                  icon: Icons.currency_bitcoin,
                  isSelected: selectedAsset == AssetType.btc,
                  onTap: () => onAssetChanged(AssetType.btc),
                ),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                child: _AssetButton(
                  asset: AssetType.gold,
                  label: 'Gold',
                  icon: Icons.monetization_on,
                  isSelected: selectedAsset == AssetType.gold,
                  onTap: () => onAssetChanged(AssetType.gold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetButton extends StatelessWidget {
  final AssetType asset;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AssetButton({
    required this.asset,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.neutral300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.neutral700,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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

class _GoldTypeButton extends StatelessWidget {
  final GoldTradeType type;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoldTypeButton({
    required this.type,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.neutral300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppTheme.primary : AppTheme.neutral900,
          ),
        ),
      ),
    );
  }
}
