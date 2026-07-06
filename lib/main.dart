import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/common/bv_colors.dart';
import 'package:flutter_app/view/splash/splash_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BookVerseApp(),
    ),
  );
}

class BookVerseApp extends StatelessWidget {
  const BookVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: BVColors.primary,
          secondary: BVColors.secondary,
          surface: BVColors.surface,
          error: BVColors.error,
        ),
        scaffoldBackgroundColor: BVColors.background,
        fontFamily: 'SF Pro Text',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          foregroundColor: BVColors.textPrimary,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: BVColors.primary,
          thumbColor: Colors.white,
          inactiveTrackColor: BVColors.surfaceElevated,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? Colors.white : BVColors.textMuted,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? BVColors.primary : BVColors.surfaceElevated,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashView(),
    );
  }
}
