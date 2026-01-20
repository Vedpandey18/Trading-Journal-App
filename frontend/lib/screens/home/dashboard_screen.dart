import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/trade_provider.dart';
import '../../providers/auth_provider.dart';
import 'add_trade_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
      tradeProvider.fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final analytics = tradeProvider.analytics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddTradeScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await tradeProvider.fetchTrades();
          await tradeProvider.fetchAnalytics();
        },
        child: tradeProvider.isLoading && analytics == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total P&L Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total P&L',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatCurrency(analytics?['totalProfitLoss'] ?? 0.0),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getProfitLossColor(
                                  analytics?['totalProfitLoss'] ?? 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Trades',
                            value: '${analytics?['totalTrades'] ?? 0}',
                            icon: Icons.trending_up,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Win Rate',
                            value: '${analytics?['winRate']?.toStringAsFixed(1) ?? 0.0}%',
                            icon: Icons.percent,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Winning',
                            value: '${analytics?['winningTrades'] ?? 0}',
                            icon: Icons.arrow_upward,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Losing',
                            value: '${analytics?['losingTrades'] ?? 0}',
                            icon: Icons.arrow_downward,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Best & Worst Trades
                    if (analytics?['bestTrade'] != null)
                      _TradeCard(
                        title: 'Best Trade',
                        trade: analytics!['bestTrade'],
                        isBest: true,
                      ),
                    if (analytics?['worstTrade'] != null) ...[
                      const SizedBox(height: 16),
                      _TradeCard(
                        title: 'Worst Trade',
                        trade: analytics!['worstTrade'],
                        isBest: false,
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Monthly Summary
                    if (analytics?['monthlySummary'] != null &&
                        (analytics!['monthlySummary'] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...((analytics!['monthlySummary'] as List).take(6).map((month) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(month['month'] ?? ''),
                                trailing: Text(
                                  _formatCurrency(month['profitLoss'] ?? 0.0),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getProfitLossColor(
                                      month['profitLoss'] ?? 0.0,
                                    ),
                                  ),
                                ),
                                subtitle: Text('${month['tradeCount']} trades'),
                              ),
                            );
                          })),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Color _getProfitLossColor(dynamic value) {
    if (value == null) return Colors.grey;
    final numValue = value is num ? value.toDouble() : 0.0;
    if (numValue > 0) return Colors.green;
    if (numValue < 0) return Colors.red;
    return Colors.grey;
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '₹0.00';
    final numValue = value is num ? value.toDouble() : 0.0;
    return NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(numValue);
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> trade;
  final bool isBest;

  const _TradeCard({
    required this.title,
    required this.trade,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    final profitLoss = trade['profitLoss'] ?? 0.0;
    final color = profitLoss > 0 ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    NumberFormat.currency(symbol: '₹', decimalDigits: 2)
                        .format(profitLoss),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${trade['instrument'] ?? ''} - ${trade['tradeType'] ?? ''}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              'Entry: ₹${trade['entryPrice']} | Exit: ₹${trade['exitPrice']}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
