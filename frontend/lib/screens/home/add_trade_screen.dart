import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/trade_provider.dart';
import '../../providers/auth_provider.dart';

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
  double _calculatedProfitLoss = 0.0;

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(_calculateProfitLoss);
    _exitPriceController.addListener(_calculateProfitLoss);
    _quantityController.addListener(_calculateProfitLoss);
    _lotSizeController.addListener(_calculateProfitLoss);
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

  void _calculateProfitLoss() {
    try {
      final entryPrice = double.tryParse(_entryPriceController.text) ?? 0.0;
      final exitPrice = double.tryParse(_exitPriceController.text) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final lotSize = int.tryParse(_lotSizeController.text) ?? 1;

      if (entryPrice > 0 && exitPrice > 0 && quantity > 0) {
        final totalQuantity = quantity * lotSize;
        if (_tradeType == 'BUY') {
          _calculatedProfitLoss = (exitPrice - entryPrice) * totalQuantity;
        } else {
          _calculatedProfitLoss = (entryPrice - exitPrice) * totalQuantity;
        }
        setState(() {});
      } else {
        setState(() {
          _calculatedProfitLoss = 0.0;
        });
      }
    } catch (e) {
      setState(() {
        _calculatedProfitLoss = 0.0;
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

  Future<void> _submitTrade() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isProUser()) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      final tradeCount = tradeProvider.trades.length;
      if (tradeCount >= 10) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Free plan limit reached. Upgrade to PRO for unlimited trades.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final tradeData = {
      'instrument': _instrumentController.text.trim(),
      'tradeType': _tradeType,
      'entryPrice': double.parse(_entryPriceController.text),
      'exitPrice': double.parse(_exitPriceController.text),
      'quantity': int.parse(_quantityController.text),
      'lotSize': int.parse(_lotSizeController.text),
      'tradeDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'notes': _notesController.text.trim(),
    };

    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    final success = await tradeProvider.addTrade(tradeData);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trade added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tradeProvider.error ?? 'Failed to add trade'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _instrumentController,
                decoration: const InputDecoration(
                  labelText: 'Instrument',
                  hintText: 'e.g., NIFTY, BANKNIFTY, RELIANCE',
                  prefixIcon: Icon(Icons.trending_up),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instrument name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tradeType,
                decoration: const InputDecoration(
                  labelText: 'Trade Type',
                  prefixIcon: Icon(Icons.swap_horiz),
                ),
                items: const [
                  DropdownMenuItem(value: 'BUY', child: Text('BUY')),
                  DropdownMenuItem(value: 'SELL', child: Text('SELL')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tradeType = value!;
                  });
                  _calculateProfitLoss();
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _entryPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Entry Price',
                        prefixIcon: Icon(Icons.arrow_downward),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _exitPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Exit Price',
                        prefixIcon: Icon(Icons.arrow_upward),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                          return 'Invalid quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
                          return 'Invalid lot size';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Trade Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              // Profit/Loss Display
              if (_calculatedProfitLoss != 0.0)
                Card(
                  color: _calculatedProfitLoss > 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated P&L:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '₹', decimalDigits: 2)
                              .format(_calculatedProfitLoss),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _calculatedProfitLoss > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: tradeProvider.isLoading ? null : _submitTrade,
                child: tradeProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Trade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
