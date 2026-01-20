import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'theme/theme.dart';
import 'providers/subscription_provider.dart';
import 'screens/dashboard/dashboard_screen_v2.dart';
import 'screens/trades/trades_list_screen_v2.dart';
import 'screens/add_trade/add_trade_screen_v2.dart';
import 'screens/analytics/analytics_screen_v2.dart';
import 'screens/profile/profile_screen_v2.dart';
import 'screens/subscription/subscription_plans_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_success_screen.dart';

/// Main App with Subscription Support
/// Includes subscription provider and payment flow
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const TradingJournalAppWithSubscription());
}

class TradingJournalAppWithSubscription extends StatelessWidget {
  const TradingJournalAppWithSubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        // Add other providers (TradeProvider, AuthProvider, etc.)
      ],
      child: MaterialApp(
        title: 'Trading Journal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/dashboard',
        routes: {
          '/dashboard': (context) => const MainNavigationScreenWithSubscription(),
          '/subscription': (context) => const SubscriptionPlansScreen(),
          '/payment': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return PaymentScreen(amount: args['amount']);
          },
          '/payment-success': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return PaymentSuccessScreen(
              paymentId: args['paymentId'],
              orderId: args['orderId'],
            );
          },
        },
      ),
    );
  }
}

/// Main Navigation with Subscription Support
class MainNavigationScreenWithSubscription extends StatefulWidget {
  const MainNavigationScreenWithSubscription({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreenWithSubscription> createState() =>
      _MainNavigationScreenWithSubscriptionState();
}

class _MainNavigationScreenWithSubscriptionState
    extends State<MainNavigationScreenWithSubscription> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreenV2(),
    const TradesListScreenV2(),
    const AnalyticsScreenV2(),
    const ProfileScreenV2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Check if accessing Pro feature
          if (index == 2) {
            // Analytics screen
            final subscriptionProvider =
                Provider.of<SubscriptionProvider>(context, listen: false);
            if (!subscriptionProvider.isProUser) {
              // Show paywall
              // PaywallHelper.showAnalyticsPaywall(context);
              // Don't navigate
              return;
            }
          }
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.neutral500,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: AppTheme.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            activeIcon: Icon(Icons.list),
            label: 'Trades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTradeScreenV2(),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
