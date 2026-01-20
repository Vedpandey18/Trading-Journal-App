import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'providers/trade_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/premium_login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/api_service.dart';
import 'theme/premium_theme.dart';
// New Professional UI
import 'main_new.dart' as new_ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences and load user data
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final isLoggedIn = token != null && token.isNotEmpty;
  
  // Use new professional UI (set to true to enable)
  const useNewUI = true;
  
  if (useNewUI && isLoggedIn) {
    // Use new professional UI for logged-in users
    runApp(new_ui.TradingJournalApp());
  } else {
    // Use original UI for login/auth flow
    runApp(MyApp(isLoggedIn: isLoggedIn));
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            // Load user data from storage on app start
            authProvider.loadUserFromStorage();
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => TradeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Trading Journal',
            debugShowCheckedModeBanner: false,
            theme: PremiumTheme.lightTheme,
            darkTheme: PremiumTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: isLoggedIn ? const HomeScreen() : const SplashScreen(),
            routes: {
              '/login': (context) => const PremiumLoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
