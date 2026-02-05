import '../../exports.dart';

export 'app_colors.dart';

// 1. TextTheme mapeado a partir do Design System (Figma).
// Tamanhos e line-heights seguem os valores documentados no design system.
// Os `height` foram calculados como lineHeightPx / fontSizePx.
const textTheme = TextTheme(
  // Display
  displayLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 72,
    fontWeight: FontWeight.w400,
    height: 1,
  ),

  // Headlines / H1..H3
  headlineLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 56,
    fontWeight: FontWeight.w400,
    height: 64 / 56,
  ), // h1
  headlineMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 56 / 48,
  ), // h2
  headlineSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 40,
    fontWeight: FontWeight.w400,
    height: 48 / 40,
  ), // h3
  // Titles / H4..H6
  titleLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 40 / 32,
  ), // h4
  titleMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
  ), // h5
  titleSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 28 / 20,
  ), // h6
  // Body / paragraph
  bodyLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
  ),

  // Labels / small
  labelLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 22 / 14,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 20 / 12,
  ),
);

class AppTheme {
  /// Theme for Pessoa Física (uses teal as primary)
  static ThemeData lightThemePF() => _buildLightTheme(AppColors.teal);

  /// Theme for Pessoa Jurídica (uses pjPrimaryRed as primary)
  static ThemeData lightThemePJ() => _buildLightTheme(AppColors.pjPrimaryRed);

  static ThemeData _buildLightTheme(Color primaryColor) {
    // Create a custom ColorScheme with explicit colors for better control
    final colorScheme = ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
      // Override specific colors for better text visibility
      primary: primaryColor,
      onSurface: AppColors.generalText, // Text on surface (input text)
      onSurfaceVariant: AppColors.mediumDarkGray, // Hint/label text
      outline: const Color(0xFFE4E4E7), // Border color
      outlineVariant: const Color(0xFFE4E4E7), // Secondary border color
      surface: AppColors.white, // Background
      surfaceContainerHighest: AppColors.contentBackground, // Disabled bg
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      textTheme: textTheme.apply(
        bodyColor: AppColors.generalText,
        displayColor: AppColors.generalText,
      ),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.contentBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        filled: true,
        fillColor: AppColors.white,
        labelStyle: textTheme.labelLarge?.copyWith(
          color: AppColors.mediumDarkGray,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.mediumGray),
        // Explicitly set text style for input text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.burntRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.burntRed, width: 1.5),
        ),
        errorStyle: textTheme.labelSmall?.copyWith(color: AppColors.burntRed),
      ),
      // Add explicit text selection theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor.withSafeOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGray,
          side: const BorderSide(color: Color(0xFFD7DAE0)),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // TabBar theme for better visibility
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: AppColors.mediumGray,
        indicatorColor: primaryColor,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mediumGray,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
      // DropdownMenu theme
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.generalText),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
          ),
        ),
      ),
    );
  }

  // Legacy getter for backward compatibility
  static ThemeData get lightThemeData => lightThemePF();

  static ThemeData get darkThemeData => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto', // 2. Define a fonte como fallback
    textTheme: textTheme, // 3. Aplica o TextTheme ao tema
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      filled: true,
      fillColor: AppColors.contentBackground,
      labelStyle: textTheme.labelLarge,
      hintStyle: textTheme.bodyMedium,
      errorStyle: textTheme.labelSmall?.copyWith(color: AppColors.burntRed),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.burntRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.burntRed, width: 1.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.mediumGray,
      showUnselectedLabels: false,
      showSelectedLabels: false,
    ),
  );
}

// Theme mode notifier for Riverpod 3.0
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  set themeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
