import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/trade_provider.dart';
import '../../widgets/loading_skeleton.dart';

class TradesListScreen extends StatefulWidget {
  const TradesListScreen({Key? key}) : super(key: key);

  @override
  State<TradesListScreen> createState() => _TradesListScreenState();
}

class _TradesListScreenState extends State<TradesListScreen> {
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

  Future<void> _deleteTrade(int tradeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trade'),
        content: const Text('Are you sure you want to delete this trade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      await tradeProvider.deleteTrade(tradeId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trade deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final trades = tradeProvider.trades;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trades'),
      ),
      body: tradeProvider.isLoading && trades.isEmpty
          ? const TradeListLoadingSkeleton()
          : trades.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No trades yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first trade',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => tradeProvider.fetchTrades(),
                  child: ListView.builder(
                    itemCount: trades.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final trade = trades[index];
                      final profitLoss = trade['profitLoss'] ?? 0.0;
                      final isProfit = profitLoss > 0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isProfit
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              isProfit ? Icons.trending_up : Icons.trending_down,
                              color: isProfit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            trade['instrument'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${trade['tradeType']} | Qty: ${trade['quantity']} x ${trade['lotSize']}',
                              ),
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(DateTime.parse(trade['tradeDate'])),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  symbol: '₹',
                                  decimalDigits: 2,
                                ).format(profitLoss),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isProfit ? Colors.green : Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: Colors.red,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _deleteTrade(trade['id']),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
