import 'package:flutter/material.dart';

/// Professional Trading Journal Design System
/// Fintech-grade theme inspired by TraderVue
/// White theme only - optimized for trading professionals

class AppTheme {
  // ==================== COLOR PALETTE ====================
  
  // Primary Colors - Professional Fintech Blue
  static const Color primary = Color(0xFF1E40AF); // Deep professional blue
  static const Color primaryLight = Color(0xFF3B82F6); // Lighter blue for accents
  static const Color primaryDark = Color(0xFF1E3A8A); // Darker for emphasis
  
  // Profit & Loss Colors - Soft, Professional
  static const Color profit = Color(0xFF059669); // Soft green (not too bright)
  static const Color profitLight = Color(0xFF10B981); // Lighter green
  static const Color loss = Color(0xFFDC2626); // Soft red (not too bright)
  static const Color lossLight = Color(0xFFEF4444); // Lighter red
  
  // Neutral Colors
  static const Color neutral900 = Color(0xFF111827); // Primary text
  static const Color neutral700 = Color(0xFF374151); // Secondary text
  static const Color neutral500 = Color(0xFF6B7280); // Tertiary text
  static const Color neutral300 = Color(0xFFD1D5DB); // Borders
  static const Color neutral100 = Color(0xFFF3F4F6); // Background grey
  static const Color white = Color(0xFFFFFFFF); // Pure white
  
  // Status Colors
  static const Color success = profit;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = loss;
  static const Color info = Color(0xFF3B82F6); // Light blue for info
  
  // ==================== TYPOGRAPHY ====================
  // Using Poppins font family (will be added to pubspec.yaml)
  
  static const String fontFamily = 'Poppins';
  
  // Large P&L Numbers (Hero numbers)
  static TextStyle heroNumber(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -1.0,
    height: 1.2,
  );
  
  // Medium P&L Numbers
  static TextStyle mediumNumber(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.5,
  );
  
  // Small P&L Numbers
  static TextStyle smallNumber(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );
  
  // Medium Number (for payment screen)
  static TextStyle numberMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
  );
  
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: neutral900,
    letterSpacing: -0.5,
    height: 1.3,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: neutral900,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: neutral900,
    letterSpacing: -0.2,
    height: 1.4,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: neutral900,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: neutral900,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: neutral700,
    height: 1.4,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: neutral700,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: neutral700,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: neutral500,
    height: 1.3,
  );
  
  // ==================== SPACING SYSTEM ====================
  
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  
  // ==================== BORDER RADIUS ====================
  
  static const double radiusSM = 6.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  
  // ==================== SHADOWS ====================
  
  static List<BoxShadow> shadowSM = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> shadowMD = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowLG = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  // ==================== CARD DECORATION ====================
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusMD),
    boxShadow: shadowMD,
  );
  
  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusMD),
    boxShadow: shadowLG,
  );
  
  // ==================== P&L COLOR HELPERS ====================
  
  /// Get color based on P&L value
  static Color getPnLColor(double? value) {
    if (value == null) return neutral500;
    if (value > 0) return profit;
    if (value < 0) return loss;
    return neutral500;
  }
  
  /// Get profit/loss text style
  static TextStyle getPnLTextStyle(double? value, {double fontSize = 24}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: getPnLColor(value),
      letterSpacing: -0.5,
    );
  }
  
  // ==================== THEME DATA ====================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: neutral100,
      primaryColor: primary,
      fontFamily: fontFamily,
      
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryLight,
        surface: white,
        background: neutral100,
        error: loss,
        onPrimary: white,
        onSecondary: white,
        onSurface: neutral900,
        onBackground: neutral900,
        onError: white,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: neutral900),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: const BorderSide(color: neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: const BorderSide(color: neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: const BorderSide(color: loss),
        ),
        labelStyle: labelLarge,
        hintStyle: bodyMedium.copyWith(color: neutral500),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: neutral300,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

/// Design Rationale:
/// 
/// 1. **Primary Blue (#1E40AF)**: Professional, trustworthy, commonly used in fintech
///    - Not too bright (avoids eye strain)
///    - Conveys stability and trust
/// 
/// 2. **Soft Green/Red**: Softer than bright colors
///    - Reduces eye fatigue during long trading sessions
///    - Still clearly distinguishable
///    - Professional appearance
/// 
/// 3. **Poppins Font**: Modern, clean, highly readable
///    - Excellent number readability
///    - Professional appearance
///    - Works well at all sizes
/// 
/// 4. **Large Numbers**: Traders need instant feedback
///    - 36px for hero P&L (most important)
///    - Bold weight for emphasis
///    - Negative letter spacing for tighter numbers
/// 
/// 5. **White Background**: Standard for finance apps
///    - High contrast for readability
///    - Professional appearance
///    - Less eye strain than dark themes
/// 
/// 6. **Card Design**: Soft shadows, rounded corners
///    - Modern, clean appearance
///    - Clear visual hierarchy
///    - Touch-friendly on mobile
