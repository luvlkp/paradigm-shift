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


class FadingStar extends StatefulWidget {
  const FadingStar({
    super.key,
    this.size = 10,
    this.color = const Color(0xFF8066A8),
    this.duration = const Duration(seconds: 3),
  });

  final double size;
  final Color color;
  final Duration duration;

  @override
  State<FadingStar> createState() => _FadingStarState();
}

class _FadingStarState extends State<FadingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = Curves.easeInOut.transform(_controller.value);

        return Container(
          width: widget.size * 5,
          height: widget.size * 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withValues(alpha: 0.12 + glow * 0.08),
                widget.color.withValues(alpha: 0.05 + glow * 0.04),
                widget.color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// A soft, forest-inspired background: warm cream base, gentle gradient,
/// a soft golden glow, and a few subtle sparkles/leaves.
class GroveBackground extends StatelessWidget {
  const GroveBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Warm enchanted parchment background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF3F4E6),
                GroveColors.cream,
                Color(0xFFEAE7F0),
              ],
            ),
          ),
        ),

        // Soft golden moonlight
        Positioned(
          top: -140,
          right: -80,
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  GroveColors.softGold.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Very subtle mystical purple glow
        Positioned(
          bottom: -180,
          left: -120,
          child: Container(
            width: 480,
            height: 480,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF75689A).withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),


        // Small leaf
        Positioned(
          top: 90,
          right: 42,
          child: Icon(
            Icons.eco,
            size: 18,
            color: GroveColors.moss.withValues(alpha: 0.35),
          ),
        ),

        // Bottom leaf
        Positioned(
          bottom: 25,
          right: 45,
          child: Icon(
            Icons.eco,
            size: 20,
            color: GroveColors.sage.withValues(alpha: 0.45),
          ),
        ),

        // Fading purple stars
        const Positioned(
          top: 55,
          left: 75,
          child: FadingStar(
            size: 7,
            duration: Duration(seconds: 3),
          ),
        ),

        const Positioned(
          top: 110,
          right: 65,
          child: FadingStar(
            size: 6,
            duration: Duration(seconds: 4),
          ),
        ),

        const Positioned(
          bottom: 75,
          left: 55,
          child: FadingStar(
            size: 6,
            duration: Duration(seconds: 5),
          ),
        ),

        const Positioned(
          bottom: 110,
          right: 70,
          child: FadingStar(
            size: 7,
            duration: Duration(seconds: 4),
          ),
        ),

        const Positioned(
          top: 180,
          left: 180,
          child: FadingStar(
            size: 5,
            duration: Duration(seconds: 5),
          ),
        ),

        const Positioned(
          top: 70,
          left: 380,
          child: FadingStar(
            size: 7,
            duration: Duration(seconds: 4),
          ),
        ),

        const Positioned(
          top: 30,
          right: 280,
          child: FadingStar(
            size: 5,
            duration: Duration(seconds: 6),
          ),
        ),

        const Positioned(
          top: 85,
          right: 420,
          child: FadingStar(
            size: 6,
            duration: Duration(seconds: 3),
          ),
        ),

        const Positioned(
          top: 245,
          left: 500,
          child: FadingStar(
            size: 4,
            duration: Duration(seconds: 7),
          ),
        ),
        // Actual page
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
