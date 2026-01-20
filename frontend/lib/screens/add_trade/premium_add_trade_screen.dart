import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/premium_theme.dart';
import '../../providers/trade_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/indian_instrument_model.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Trading Terminal Style Add Trade Screen
/// Modern fintech UI with live P&L preview
class PremiumAddTradeScreen extends StatefulWidget {
  const PremiumAddTradeScreen({Key? key}) : super(key: key);

  @override
  State<PremiumAddTradeScreen> createState() => _PremiumAddTradeScreenState();
}

class _PremiumAddTradeScreenState extends State<PremiumAddTradeScreen>
    with SingleTickerProviderStateMixin {
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
  bool _isSaving = false;
  late AnimationController _pnlAnimationController;
  late Animation<double> _pnlAnimation;

  final List<String> _instruments = IndianInstrument.getAllInstruments();

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(_updateCalculations);
    _exitPriceController.addListener(_updateCalculations);
    _lotsController.addListener(_updateCalculations);
    
    _pnlAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pnlAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pnlAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pnlAnimationController.dispose();
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _lotsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    final lots = int.tryParse(_lotsController.text) ?? 0;
    if (_selectedInstrument != null && lots > 0) {
      _lotSize = IndianInstrument.getLotSize(_selectedInstrument!);
      _calculatedQuantity = lots * _lotSize;
    } else {
      _calculatedQuantity = 0;
    }

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
      _pnlAnimationController.forward(from: 0);
    } else {
      setState(() {
        _calculatedPnL = null;
      });
    }
  }

  void _onInstrumentChanged(String? instrument) {
    setState(() {
      _selectedInstrument = instrument;
      if (instrument != null) {
        _lotSize = IndianInstrument.getLotSize(instrument);
        _lotsController.text = '1';
      }
    });
    _updateCalculations();
  }

  Future<void> _saveTrade() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInstrument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an instrument')),
      );
      return;
    }

    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    if (!subscriptionProvider.canAddTrade(tradeProvider.trades.length)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trade limit reached. Upgrade to Pro for unlimited trades.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final tradeData = {
      'instrument': _selectedInstrument,
      'tradeType': _tradeType,
      'entryPrice': double.parse(_entryPriceController.text),
      'exitPrice': double.parse(_exitPriceController.text),
      'quantity': _calculatedQuantity,
      'lotSize': _lotSize,
      'tradeDate': _selectedDate.toIso8601String(),
      'profitLoss': _calculatedPnL ?? 0.0,
      'notes': _notesController.text.trim(),
    };

    final success = await tradeProvider.addTrade(tradeData);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Trade added successfully'),
            ],
          ),
          backgroundColor: PremiumTheme.lightProfit,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tradeProvider.error ?? 'Failed to add trade'),
          backgroundColor: PremiumTheme.lightLoss,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final tradeProvider = Provider.of<TradeProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final canAddMore = subscriptionProvider.canAddTrade(tradeProvider.trades.length);

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? PremiumTheme.lightBackground
          : PremiumTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          'Add Trade',
          style: PremiumTheme.heading2(brightness),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Instrument Selection Card
                    Container(
                      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                      decoration: PremiumTheme.cardDecoration(brightness),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instrument',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceSM),
                          DropdownButtonFormField<String>(
                            value: _selectedInstrument,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: brightness == Brightness.light
                                  ? PremiumTheme.lightBackground
                                  : PremiumTheme.darkBackground,
                              prefixIcon: const Icon(Icons.show_chart),
                            ),
                            items: _instruments.map((instrument) {
                              return DropdownMenuItem(
                                value: instrument,
                                child: Text(instrument),
                              );
                            }).toList(),
                            onChanged: _onInstrumentChanged,
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an instrument';
                              }
                              return null;
                            },
                          ),
                          if (_selectedInstrument != null) ...[
                            const SizedBox(height: PremiumTheme.spaceSM),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: PremiumTheme.lightPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Lot Size: ${_lotSize}',
                                style: PremiumTheme.bodySmall(brightness),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),

                    // Trade Type Toggle Card
                    Container(
                      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                      decoration: PremiumTheme.cardDecoration(brightness),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trade Type',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceSM),
                          Row(
                            children: [
                              Expanded(
                                child: _TradeTypeButton(
                                  label: 'BUY',
                                  isSelected: _tradeType == 'BUY',
                                  color: PremiumTheme.lightProfit,
                                  onTap: () {
                                    setState(() => _tradeType = 'BUY');
                                    _updateCalculations();
                                  },
                                  brightness: brightness,
                                ),
                              ),
                              const SizedBox(width: PremiumTheme.spaceMD),
                              Expanded(
                                child: _TradeTypeButton(
                                  label: 'SELL',
                                  isSelected: _tradeType == 'SELL',
                                  color: PremiumTheme.lightLoss,
                                  onTap: () {
                                    setState(() => _tradeType = 'SELL');
                                    _updateCalculations();
                                  },
                                  brightness: brightness,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),

                    // Price Inputs Card
                    Container(
                      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                      decoration: PremiumTheme.cardDecoration(brightness),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prices',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceMD),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _entryPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Entry Price',
                                    prefixText: '₹',
                                    filled: true,
                                    fillColor: brightness == Brightness.light
                                        ? PremiumTheme.lightBackground
                                        : PremiumTheme.darkBackground,
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
                              const SizedBox(width: PremiumTheme.spaceMD),
                              Expanded(
                                child: TextFormField(
                                  controller: _exitPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Exit Price',
                                    prefixText: '₹',
                                    filled: true,
                                    fillColor: brightness == Brightness.light
                                        ? PremiumTheme.lightBackground
                                        : PremiumTheme.darkBackground,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),

                    // Lots & Quantity Card
                    Container(
                      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                      decoration: PremiumTheme.cardDecoration(brightness),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceMD),
                          TextFormField(
                            controller: _lotsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Number of Lots',
                              filled: true,
                              fillColor: brightness == Brightness.light
                                  ? PremiumTheme.lightBackground
                                  : PremiumTheme.darkBackground,
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
                          if (_calculatedQuantity > 0) ...[
                            const SizedBox(height: PremiumTheme.spaceSM),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: PremiumTheme.lightPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Quantity',
                                    style: PremiumTheme.bodyMedium(brightness),
                                  ),
                                  Text(
                                    '$_calculatedQuantity',
                                    style: PremiumTheme.bodyMedium(brightness).copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: PremiumTheme.lightPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: PremiumTheme.spaceMD),

                    // Live P&L Preview Card (Large & Prominent)
                    if (_calculatedPnL != null)
                      ScaleTransition(
                        scale: _pnlAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(PremiumTheme.spaceLG),
                          decoration: PremiumTheme.cardDecorationElevated(brightness).copyWith(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                PremiumTheme.getPnLColor(_calculatedPnL, brightness)
                                    .withOpacity(0.1),
                                PremiumTheme.getPnLColor(_calculatedPnL, brightness)
                                    .withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Estimated P&L',
                                style: PremiumTheme.labelMedium(brightness),
                              ),
                              const SizedBox(height: PremiumTheme.spaceSM),
                              Text(
                                '₹${_calculatedPnL!.abs().toStringAsFixed(2)}',
                                style: PremiumTheme.heroNumber(
                                  PremiumTheme.getPnLColor(_calculatedPnL, brightness),
                                  brightness,
                                ),
                              ),
                              const SizedBox(height: PremiumTheme.spaceXS),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _calculatedPnL! >= 0
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: PremiumTheme.getPnLColor(_calculatedPnL, brightness),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _calculatedPnL! >= 0 ? 'Profit' : 'Loss',
                                    style: PremiumTheme.bodySmall(brightness).copyWith(
                                      color: PremiumTheme.getPnLColor(_calculatedPnL, brightness),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: PremiumTheme.spaceMD),

                    // Date & Notes Card
                    Container(
                      padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                      decoration: PremiumTheme.cardDecoration(brightness),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceSM),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: brightness == Brightness.light
                                    ? PremiumTheme.lightBackground
                                    : PremiumTheme.darkBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: brightness == Brightness.light
                                      ? PremiumTheme.lightBorder
                                      : PremiumTheme.darkBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 12),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                                    style: PremiumTheme.bodyLarge(brightness),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: PremiumTheme.spaceMD),
                          Text(
                            'Notes (Optional)',
                            style: PremiumTheme.labelMedium(brightness),
                          ),
                          const SizedBox(height: PremiumTheme.spaceSM),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Add any notes about this trade...',
                              filled: true,
                              fillColor: brightness == Brightness.light
                                  ? PremiumTheme.lightBackground
                                  : PremiumTheme.darkBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA Button
            Container(
              padding: const EdgeInsets.all(PremiumTheme.spaceMD),
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? PremiumTheme.lightCard
                    : PremiumTheme.darkCard,
                boxShadow: PremiumTheme.shadowLG(brightness),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canAddMore && !_isSaving ? _saveTrade : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            canAddMore ? 'Add Trade' : 'Upgrade to Add More',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final Brightness brightness;

  const _TradeTypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.15)
                : brightness == Brightness.light
                    ? PremiumTheme.lightBackground
                    : PremiumTheme.darkBackground,
            borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
            border: Border.all(
              color: isSelected ? color : PremiumTheme.lightBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: PremiumTheme.bodyLarge(brightness).copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? color
                    : brightness == Brightness.light
                        ? PremiumTheme.lightTextSecondary
                        : PremiumTheme.darkTextSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
