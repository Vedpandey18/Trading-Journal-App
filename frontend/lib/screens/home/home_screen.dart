import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trade_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/premium_theme.dart';
import '../dashboard/premium_dashboard_screen.dart';
import '../trades/premium_trades_list_screen.dart';
import '../add_trade/premium_add_trade_screen.dart';
import '../profile/profile_screen.dart';
import '../../main_new.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lazy load screens - only build when needed
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const PremiumDashboardScreen();
      case 1:
        return const PremiumTradesListScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const PremiumDashboardScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    // NO API calls here - let each screen fetch its own data when it loads
    // This allows UI to render immediately
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brightness = themeProvider.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    final theme = brightness == Brightness.light ? PremiumTheme.lightTheme : PremiumTheme.darkTheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _getScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: PremiumTheme.lightPrimary,
        unselectedItemColor: PremiumTheme.lightTextTertiary,
        backgroundColor: theme.cardColor,
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
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PremiumAddTradeScreen(),
            ),
          );
        },
        backgroundColor: PremiumTheme.lightPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
