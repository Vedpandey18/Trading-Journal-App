import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/theme.dart';
import 'screens/dashboard/dashboard_screen_v2.dart';
import 'screens/trades/trades_list_screen_v2.dart';
import 'screens/add_trade/add_trade_screen_v2.dart';
import 'screens/analytics/analytics_screen_v2.dart';
import 'screens/profile/profile_screen_v2.dart';

/// Main App Entry Point - Professional Trading Journal
/// Production-ready Flutter app with fintech-grade UI
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const TradingJournalAppV2());
}

class TradingJournalAppV2 extends StatelessWidget {
  const TradingJournalAppV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreenV2(),
    );
  }
}

/// Main Navigation Screen
/// Bottom navigation with 5 tabs optimized for traders
/// 
/// Navigation Structure:
/// 1. Dashboard - Main screen (most used)
/// 2. Trades - All trades list
/// 3. Analytics - Performance analysis
/// 4. Profile - Settings & subscription
/// 
/// Why This Navigation Works:
/// - Bottom navigation is thumb-friendly (one-hand usage)
/// - Always visible (no hidden menus)
/// - Clear labels (icons + text)
/// - Floating action button for quick add (most common action)
/// - Dashboard first (traders check performance most often)
class MainNavigationScreenV2 extends StatefulWidget {
  const MainNavigationScreenV2({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreenV2> createState() => _MainNavigationScreenV2State();
}

class _MainNavigationScreenV2State extends State<MainNavigationScreenV2> {
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
