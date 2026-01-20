import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/trade_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/subscription_provider.dart';
import 'theme/premium_theme.dart';
import 'screens/dashboard/premium_dashboard_screen.dart';
import 'screens/trades/premium_trades_list_screen.dart';
import 'screens/add_trade/premium_add_trade_screen.dart';
import 'screens/analytics/premium_analytics_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/admob_service.dart';

/// Main App Entry Point
/// Professional Trading Journal Mobile App
/// Clean navigation with bottom bar
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob
  await AdMobService.initialize();
  
  runApp(const TradingJournalApp());
}

class TradingJournalApp extends StatelessWidget {
  const TradingJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            authProvider.loadUserFromStorage();
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => TradeProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // Force dark mode only as per requirements
          return MaterialApp(
            title: 'Trading Journal',
            debugShowCheckedModeBanner: false,
            theme: PremiumTheme.darkTheme,
            darkTheme: PremiumTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

/// Main Navigation Screen
/// Bottom navigation bar with 5 tabs:
/// 1. Dashboard - Main screen with key metrics
/// 2. Trades - List of all trades
/// 3. Add Trade - Quick add button (floating)
/// 4. Analytics - Detailed analytics
/// 5. Profile - User settings and subscription
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PremiumDashboardScreen(),
    const PremiumTradesListScreen(),
    const PremiumAnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PremiumTheme.darkCard.withOpacity(0.8),
              PremiumTheme.darkCard.withOpacity(0.95),
            ],
          ),
          border: Border(
            top: BorderSide(
              color: PremiumTheme.darkBorder.withOpacity(0.3),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: PremiumTheme.darkPrimary,
          unselectedItemColor: PremiumTheme.darkTextTertiary,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: _currentIndex == 0
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            PremiumTheme.darkPrimary.withOpacity(0.2),
                            PremiumTheme.darkPrimary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  _currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: _currentIndex == 1
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            PremiumTheme.darkPrimary.withOpacity(0.2),
                            PremiumTheme.darkPrimary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  _currentIndex == 1 ? Icons.list : Icons.list_outlined,
                ),
              ),
              label: 'Trades',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: _currentIndex == 2
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            PremiumTheme.darkPrimary.withOpacity(0.2),
                            PremiumTheme.darkPrimary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  _currentIndex == 2 ? Icons.analytics : Icons.analytics_outlined,
                ),
              ),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: _currentIndex == 3
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            PremiumTheme.darkPrimary.withOpacity(0.2),
                            PremiumTheme.darkPrimary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outline,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: PremiumTheme.primaryGradient(),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PremiumTheme.darkPrimary.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PremiumAddTradeScreen(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
