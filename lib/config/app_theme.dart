import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Modern Color Palette
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color backgroundCard = Color(0xFF161B22);
  static const Color backgroundElevated = Color(0xFF21262D);

  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color accentBlueDark = Color(0xFF1F6FEB);

  static const Color successGreen = Color(0xFF3FB950);
  static const Color warningRed = Color(0xFFF85149);
  static const Color warningYellow = Color(0xFFD29922);

  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);
  static const Color textMuted = Color(0xFF484F58);

  static const Color borderSubtle = Color(0xFF30363D);
  static const Color borderDefault = Color(0xFF444C56);

  // Typography
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentBlue,
      scaffoldBackgroundColor: backgroundDark,
      fontFamily: GoogleFonts.poppins().fontFamily,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundCard,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: accentBlue),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: backgroundCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderSubtle, width: 1),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentBlue,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentBlue,
          side: BorderSide(color: accentBlue, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundElevated,
        labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
        prefixIconColor: accentBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: warningRed),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: backgroundCard,
        elevation: 0,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        iconColor: accentBlue,
        textColor: textPrimary,
        selectedColor: accentBlue,
        selectedTileColor: backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderSubtle),
        ),
        titleTextStyle: heading3,
        contentTextStyle: bodyMedium,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundElevated,
        contentTextStyle: bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderSubtle),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentBlue;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: BorderSide(color: borderDefault, width: 2),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: borderSubtle,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: accentBlue, size: 24),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: button,
      ),
    );
  }

  // Gradient Helpers
  static LinearGradient get backgroundGradient => LinearGradient(
    colors: [backgroundDark, backgroundCard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get accentGradient => LinearGradient(
    colors: [accentBlue, accentBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Box Shadow Helpers
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
