import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Fintech Design System
/// Inspired by Zerodha, Groww, TradingView
/// Full light & dark mode support
class PremiumTheme {
  // ==================== LIGHT MODE COLORS ====================
  
  // Primary - Deep Indigo/Blue (Trustworthy, Professional)
  static const Color lightPrimary = Color(0xFF1E40AF); // Deep blue
  static const Color lightPrimaryLight = Color(0xFF3B82F6);
  static const Color lightPrimaryDark = Color(0xFF1E3A8A);
  
  // Profit & Loss - Vivid but Professional
  static const Color lightProfit = Color(0xFF10B981); // Emerald green
  static const Color lightProfitLight = Color(0xFF34D399);
  static const Color lightLoss = Color(0xFFEF4444); // Red
  static const Color lightLossLight = Color(0xFFF87171);
  
  // Backgrounds
  static const Color lightBackground = Color(0xFFF8FAFC); // Soft grey
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  // Text
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextTertiary = Color(0xFF94A3B8); // Slate 400
  
  // Borders & Dividers
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorderColor = Color(0xFFE2E8F0); // Alias
  static const Color lightDivider = Color(0xFFE2E8F0);
  
  // Neutral Grey
  static const Color neutralGrey = Color(0xFF94A3B8); // Slate 400
  
  // Profit & Loss aliases for convenience
  static const Color profitGreen = Color(0xFF10B981); // Same as lightProfit
  static const Color lossRed = Color(0xFFEF4444); // Same as lightLoss
  
  // ==================== DARK MODE COLORS ====================
  
  // Primary - Brighter for dark mode
  static const Color darkPrimary = Color(0xFF60A5FA); // Sky blue
  static const Color darkPrimaryLight = Color(0xFF93C5FD);
  static const Color darkPrimaryDark = Color(0xFF3B82F6);
  
  // Profit & Loss - Must stay vivid in dark mode
  static const Color darkProfit = Color(0xFF10B981); // Same green
  static const Color darkProfitLight = Color(0xFF34D399);
  static const Color darkLoss = Color(0xFFEF4444); // Same red
  static const Color darkLossLight = Color(0xFFF87171);
  
  // Backgrounds - Dark Navy/Charcoal
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  
  // Text
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Slate 400
  
  // Borders & Dividers
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkBorderColor = Color(0xFF334155); // Alias
  static const Color darkDivider = Color(0xFF334155);
  
  // ==================== TYPOGRAPHY ====================
  
  // Using Inter font (modern, clean, excellent readability)
  static TextStyle get fontFamily => GoogleFonts.inter();
  
  // Hero Numbers (Large P&L)
  static TextStyle heroNumber(Color color, [Brightness? brightness]) => GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -1.2,
    height: 1.1,
  );
  
  // Large Numbers
  static TextStyle largeNumber(Color color) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.8,
    height: 1.2,
  );
  
  // Medium Numbers
  static TextStyle mediumNumber(Color color) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.5,
  );
  
  // Headings
  static TextStyle heading1(Brightness brightness) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: brightness == Brightness.light ? lightTextPrimary : darkTextPrimary,
    letterSpacing: -0.8,
    height: 1.2,
  );
  
  static TextStyle heading2(Brightness brightness) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: brightness == Brightness.light ? lightTextPrimary : darkTextPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );
  
  static TextStyle heading3(Brightness brightness) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? lightTextPrimary : darkTextPrimary,
    letterSpacing: -0.3,
    height: 1.4,
  );
  
  // Body Text
  static TextStyle bodyLarge(Brightness brightness) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: brightness == Brightness.light ? lightTextPrimary : darkTextPrimary,
    height: 1.5,
  );
  
  static TextStyle bodyMedium(Brightness brightness) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: brightness == Brightness.light ? lightTextSecondary : darkTextSecondary,
    height: 1.5,
  );
  
  static TextStyle bodySmall(Brightness brightness) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: brightness == Brightness.light ? lightTextTertiary : darkTextTertiary,
    height: 1.4,
  );
  
  // Labels
  static TextStyle labelMedium(Brightness brightness) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? lightTextSecondary : darkTextSecondary,
  );
  
  static TextStyle labelSmall(Brightness brightness) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? lightTextTertiary : darkTextTertiary,
  );
  
  // ==================== SPACING SYSTEM (8px grid) ====================
  
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  
  // Card Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMD);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(spaceLG);
  
  // ==================== BORDER RADIUS ====================
  
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  
  // ==================== SHADOWS ====================
  
  static List<BoxShadow> shadowSM(Brightness brightness) => [
    BoxShadow(
      color: brightness == Brightness.light 
          ? Colors.black.withOpacity(0.04)
          : Colors.black.withOpacity(0.3),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> shadowMD(Brightness brightness) => [
    BoxShadow(
      color: brightness == Brightness.light
          ? Colors.black.withOpacity(0.06)
          : Colors.black.withOpacity(0.4),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowLG(Brightness brightness) => [
    BoxShadow(
      color: brightness == Brightness.light
          ? Colors.black.withOpacity(0.08)
          : Colors.black.withOpacity(0.5),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  // ==================== CARD DECORATION ====================
  
  static BoxDecoration cardDecoration(Brightness brightness) => BoxDecoration(
    color: brightness == Brightness.light ? lightCard : darkCard,
    borderRadius: BorderRadius.circular(radiusMD),
    boxShadow: shadowMD(brightness),
    border: Border.all(
      color: brightness == Brightness.light ? lightBorder : darkBorder,
      width: 1,
    ),
  );
  
  static BoxDecoration cardDecorationElevated(Brightness brightness) => BoxDecoration(
    color: brightness == Brightness.light ? lightCard : darkCard,
    borderRadius: BorderRadius.circular(radiusLG),
    boxShadow: shadowLG(brightness),
    border: Border.all(
      color: brightness == Brightness.light ? lightBorder : darkBorder,
      width: 1,
    ),
  );
  
  // ==================== GLASSMORPHISM DECORATION ====================
  
  /// Glassmorphic card decoration with backdrop blur effect
  /// Perfect for dark mode premium UI
  static BoxDecoration glassmorphicCard(Brightness brightness, {Color? gradientColor}) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                darkCard.withOpacity(0.7),
                darkCard.withOpacity(0.5),
              ]
            : [
                lightCard.withOpacity(0.9),
                lightCard.withOpacity(0.7),
              ],
      ),
      borderRadius: BorderRadius.circular(radiusLG),
      border: Border.all(
        color: isDark
            ? darkBorder.withOpacity(0.3)
            : lightBorder.withOpacity(0.5),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        if (gradientColor != null)
          BoxShadow(
            color: gradientColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }
  
  /// Glassmorphic card with gradient accent line
  static BoxDecoration glassmorphicCardWithAccent(
    Brightness brightness,
    Color accentColor, {
    bool topAccent = true,
  }) {
    final base = glassmorphicCard(brightness, gradientColor: accentColor);
    return base.copyWith(
      border: Border(
        top: topAccent
            ? BorderSide(color: accentColor, width: 3)
            : BorderSide.none,
        left: !topAccent
            ? BorderSide(color: accentColor, width: 3)
            : BorderSide.none,
        right: BorderSide(
          color: brightness == Brightness.dark
              ? darkBorder.withOpacity(0.3)
              : lightBorder.withOpacity(0.5),
          width: 1.5,
        ),
        bottom: BorderSide(
          color: brightness == Brightness.dark
              ? darkBorder.withOpacity(0.3)
              : lightBorder.withOpacity(0.5),
          width: 1.5,
        ),
      ),
    );
  }
  
  // ==================== GRADIENT BACKGROUNDS ====================
  
  static BoxDecoration gradientBackground(Brightness brightness) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: brightness == Brightness.light
          ? [
              const Color(0xFFF8FAFC),
              const Color(0xFFF1F5F9),
            ]
          : [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
            ],
    ),
  );
  
  /// Premium dark mode gradient background
  /// Deep navy to charcoal with subtle blue tint
  static BoxDecoration premiumDarkGradient() => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
      colors: [
        const Color(0xFF0A0E27), // Deep navy
        const Color(0xFF0F172A), // Slate 900
        const Color(0xFF1E293B), // Slate 800
      ],
    ),
  );
  
  /// Profit gradient (green)
  static LinearGradient profitGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF10B981), // Emerald
      const Color(0xFF34D399), // Emerald light
    ],
  );
  
  /// Loss gradient (red)
  static LinearGradient lossGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFEF4444), // Red
      const Color(0xFFF87171), // Red light
    ],
  );
  
  /// Primary gradient (blue)
  static LinearGradient primaryGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF1E40AF), // Deep blue
      const Color(0xFF3B82F6), // Blue
    ],
  );
  
  // ==================== P&L COLOR HELPERS ====================
  
  static Color getPnLColor(double? value, Brightness brightness) {
    if (value == null) {
      return brightness == Brightness.light ? lightTextTertiary : darkTextTertiary;
    }
    if (value > 0) {
      return brightness == Brightness.light ? lightProfit : darkProfit;
    }
    if (value < 0) {
      return brightness == Brightness.light ? lightLoss : darkLoss;
    }
    return brightness == Brightness.light ? lightTextTertiary : darkTextTertiary;
  }
  
  static TextStyle getPnLTextStyle(double? value, Brightness brightness, {double fontSize = 24}) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: getPnLColor(value, brightness),
      letterSpacing: -0.5,
    );
  }
  
  // ==================== THEME DATA ====================
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: lightPrimary,
    
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightPrimaryLight,
      surface: lightSurface,
      background: lightBackground,
      error: lightLoss,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightTextPrimary,
      onBackground: lightTextPrimary,
      onError: Colors.white,
    ),
    
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: heading1(Brightness.light),
      displayMedium: heading2(Brightness.light),
      displaySmall: heading3(Brightness.light),
      bodyLarge: bodyLarge(Brightness.light),
      bodyMedium: bodyMedium(Brightness.light),
      bodySmall: bodySmall(Brightness.light),
      labelLarge: labelMedium(Brightness.light),
      labelMedium: labelMedium(Brightness.light),
      labelSmall: labelSmall(Brightness.light),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurface,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: lightTextPrimary),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightTextPrimary,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
      margin: EdgeInsets.zero,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: lightLoss),
      ),
      labelStyle: labelMedium(Brightness.light),
      hintStyle: bodyMedium(Brightness.light).copyWith(color: lightTextTertiary),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: lightDivider,
      thickness: 1,
      space: 1,
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: darkPrimary,
    
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkPrimaryLight,
      surface: darkSurface,
      background: darkBackground,
      error: darkLoss,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkTextPrimary,
      onBackground: darkTextPrimary,
      onError: Colors.white,
    ),
    
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: heading1(Brightness.dark),
      displayMedium: heading2(Brightness.dark),
      displaySmall: heading3(Brightness.dark),
      bodyLarge: bodyLarge(Brightness.dark),
      bodyMedium: bodyMedium(Brightness.dark),
      bodySmall: bodySmall(Brightness.dark),
      labelLarge: labelMedium(Brightness.dark),
      labelMedium: labelMedium(Brightness.dark),
      labelSmall: labelSmall(Brightness.dark),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: darkTextPrimary),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
      margin: EdgeInsets.zero,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSM),
        borderSide: const BorderSide(color: darkLoss),
      ),
      labelStyle: labelMedium(Brightness.dark),
      hintStyle: bodyMedium(Brightness.dark).copyWith(color: darkTextTertiary),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: darkDivider,
      thickness: 1,
      space: 1,
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
  
  // ==================== THEME GETTERS ====================
  
  static ElevatedButtonThemeData get elevatedButtonTheme => lightTheme.elevatedButtonTheme!;
  
  static TextButtonThemeData get textButtonTheme => lightTheme.textButtonTheme!;
}
