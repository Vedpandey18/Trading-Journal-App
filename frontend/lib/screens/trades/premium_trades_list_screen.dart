import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trade_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/premium_theme.dart';
import '../../widgets/premium_trade_card.dart';
import '../../widgets/loading_skeleton.dart';

/// Premium Trades List Screen
/// Modern card-based design with empty states
class PremiumTradesListScreen extends StatefulWidget {
  const PremiumTradesListScreen({Key? key}) : super(key: key);

  @override
  State<PremiumTradesListScreen> createState() => _PremiumTradesListScreenState();
}

class _PremiumTradesListScreenState extends State<PremiumTradesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      if (tradeProvider.trades.isEmpty) {
        tradeProvider.fetchTrades();
      }
    });
  }

  Future<void> _deleteTrade(int tradeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Trade',
          style: PremiumTheme.heading3(Theme.of(context).brightness),
        ),
        content: const Text('Are you sure you want to delete this trade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: PremiumTheme.lightLoss,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      await tradeProvider.deleteTrade(tradeId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Trade deleted successfully'),
              ],
            ),
            backgroundColor: PremiumTheme.lightProfit,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final tradeProvider = Provider.of<TradeProvider>(context);
    final trades = tradeProvider.trades;

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? PremiumTheme.lightBackground
          : PremiumTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          'My Trades',
          style: PremiumTheme.heading2(brightness),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: 'Toggle theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => tradeProvider.refreshTrades(),
          ),
        ],
      ),
      body: tradeProvider.isLoading && trades.isEmpty
          ? const TradeListLoadingSkeleton()
          : trades.isEmpty
              ? _buildEmptyState(brightness)
              : RefreshIndicator(
                  onRefresh: () => tradeProvider.refreshTrades(),
                  child: ListView.builder(
                    itemCount: trades.length,
                    padding: const EdgeInsets.all(PremiumTheme.spaceMD),
                    itemBuilder: (context, index) {
                      final trade = trades[index];
                      return PremiumTradeCard(
                        trade: trade,
                        onDelete: () => _deleteTrade(trade['id'] as int),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(Brightness brightness) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PremiumTheme.space2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: PremiumTheme.lightPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox,
                size: 64,
                color: brightness == Brightness.light
                    ? PremiumTheme.lightPrimary
                    : PremiumTheme.darkPrimary,
              ),
            ),
            const SizedBox(height: PremiumTheme.spaceLG),
            Text(
              'No trades yet',
              style: PremiumTheme.heading2(brightness),
            ),
            const SizedBox(height: PremiumTheme.spaceSM),
            Text(
              'Tap the + button to add your first trade',
              style: PremiumTheme.bodyMedium(brightness),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
