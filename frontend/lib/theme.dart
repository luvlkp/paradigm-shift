import 'package:flutter/material.dart';

/// Centralized color palette for the Enchanted Grove theme.
class GroveColors {
  static const Color forestGreen = Color(0xFF1E4D3B);
  static const Color deepForest = Color(0xFF143526);
  static const Color moss = Color(0xFF6E8B67);
  static const Color sage = Color(0xFFADC7A4);
  static const Color cream = Color(0xFFF5EFE0);
  static const Color parchment = Color(0xFFFCF8EE);
  static const Color gold = Color(0xFFD2A94E);
  static const Color softGold = Color(0xFFE8CE8F);
  static const Color woodBrown = Color(0xFF6B4F3A);
  static const Color ink = Color(0xFF2A332C);
}

ThemeData groveTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: GroveColors.forestGreen,
    brightness: Brightness.light,
  ).copyWith(
    primary: GroveColors.forestGreen,
    onPrimary: GroveColors.parchment,
    secondary: GroveColors.moss,
    onSecondary: GroveColors.parchment,
    surface: GroveColors.parchment,
    onSurface: GroveColors.ink,
    surfaceContainerHighest: GroveColors.sage.withValues(alpha: 0.25),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: GroveColors.cream,
    cardTheme: CardThemeData(
      color: GroveColors.parchment,
      elevation: 3,
      shadowColor: GroveColors.woodBrown.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: GroveColors.gold.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: GroveColors.forestGreen,
        foregroundColor: GroveColors.parchment,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: GroveColors.forestGreen,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleLarge: TextStyle(
        color: GroveColors.forestGreen,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      bodyMedium: TextStyle(color: GroveColors.ink),
      bodyLarge: TextStyle(color: GroveColors.ink),
    ),
  );
}

/// A soft, forest-inspired background: warm cream base, gentle gradient,
/// a soft golden glow, and a few subtle sparkles/leaves.
class GroveBackground extends StatelessWidget {
  const GroveBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEFF3E4), GroveColors.cream],
            ),
          ),
        ),
        // Soft golden glow near the top, like light through the canopy.
        Positioned(
          top: -120,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GroveColors.softGold.withValues(alpha: 0.35),
                    GroveColors.softGold.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 18,
          left: 24,
          child: Icon(Icons.eco, size: 20, color: GroveColors.moss.withValues(alpha: 0.35)),
        ),
        Positioned(
          top: 60,
          right: 32,
          child: Icon(Icons.auto_awesome, size: 16, color: GroveColors.gold.withValues(alpha: 0.5)),
        ),
        Positioned(
          bottom: 24,
          left: 48,
          child: Icon(Icons.auto_awesome, size: 12, color: GroveColors.gold.withValues(alpha: 0.4)),
        ),
        Positioned(
          bottom: 16,
          right: 40,
          child: Icon(Icons.eco, size: 18, color: GroveColors.sage.withValues(alpha: 0.5)),
        ),
        child,
      ],
    );
  }
}

/// Small growth indicator icon based on mastery level.
IconData growthIcon(int mastery) {
  if (mastery >= 75) return Icons.local_florist; // mastered
  if (mastery >= 40) return Icons.eco; // growing
  return Icons.grass; // needs attention
}

Color growthColor(int mastery) {
  if (mastery >= 75) return GroveColors.forestGreen;
  if (mastery >= 40) return GroveColors.moss;
  return GroveColors.woodBrown;
}
