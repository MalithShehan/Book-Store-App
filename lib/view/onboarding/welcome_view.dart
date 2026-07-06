import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_app/common/bv_colors.dart';
import 'package:flutter_app/common_widget/round_button.dart';
import 'package:flutter_app/view/login/signin_view.dart';
import 'package:flutter_app/view/login/signup_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _particleController;
  late AnimationController _entranceController;

  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _btn1Fade;
  late Animation<Offset> _btn1Slide;
  late Animation<double> _btn2Fade;
  late Animation<Offset> _btn2Slide;

  @override
  void initState() {
    super.initState();

    // Slow color-sweep background
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // Floating particle dots
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Staggered content entrance
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.55, curve: Curves.easeOut),
      ),
    );

    _btn1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );
    _btn1Slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    _btn2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );
    _btn2Slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _particleController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _pushSlide(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, anim, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // ── Animated gradient background ──────────────────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, _) => CustomPaint(
              size: media,
              painter: _WelcomeBgPainter(_bgController.value),
            ),
          ),

          // ── Floating particles ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, _) => CustomPaint(
              size: media,
              painter: _ParticlePainter(_particleController.value),
            ),
          ),

          // ── Glass card ────────────────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.07,
                vertical: 32,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(28, 44, 28, 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App icon
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            gradient: BVColors.primaryGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: BVColors.primary.withValues(alpha: 0.55),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title
                        FadeTransition(
                          opacity: _titleFade,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: Text(
                              "Book For\nEvery Taste.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: BVColors.textPrimary,
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        FadeTransition(
                          opacity: _subtitleFade,
                          child: Text(
                            "Discover secondhand books at\nunbeatable prices near you.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: BVColors.textMuted,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        FadeTransition(
                          opacity: _btn1Fade,
                          child: SlideTransition(
                            position: _btn1Slide,
                            child: RoundButton(
                              title: "Sign In",
                              onPressed: () => _pushSlide(const SignInView()),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Create Account button
                        FadeTransition(
                          opacity: _btn2Fade,
                          child: SlideTransition(
                            position: _btn2Slide,
                            child: RoundOutlineButton(
                              title: "Create Account",
                              onPressed: () => _pushSlide(const SignUpView()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated background — slow gradient sweep with soft glowing blobs
// ─────────────────────────────────────────────────────────────────────────────
class _WelcomeBgPainter extends CustomPainter {
  final double t;
  _WelcomeBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Deep navy base
    final bg = Paint()..color = BVColors.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    // Teal blob — drifts slowly
    final p1 = Paint()
      ..color = BVColors.primary.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(
      Offset(size.width * (0.12 + 0.14 * t), size.height * 0.22),
      size.width * 0.52,
      p1,
    );

    // Gold blob — bottom right
    final p2 = Paint()
      ..color = BVColors.gold.withValues(alpha: 0.09)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 130);
    canvas.drawCircle(
      Offset(size.width * (0.92 - 0.1 * t), size.height * 0.82),
      size.width * 0.45,
      p2,
    );
  }

  @override
  bool shouldRepaint(_WelcomeBgPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating particle dots
// ─────────────────────────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double t;

  static final _rng = math.Random(99);
  static final _particles = List.generate(9, (i) => [
        _rng.nextDouble(), // x
        _rng.nextDouble(), // y
        _rng.nextDouble() * 0.025 + 0.008, // radius
        _rng.nextDouble(), // phase
      ]);

  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final phase = p[3];
      final x = size.width * p[0];
      final yBase = size.height * p[1];
      final drift = size.height * 0.04 * math.sin((t + phase) * 2 * math.pi);
      final r = size.width * p[2];
      final alpha = 0.12 + 0.08 * math.sin((t + phase) * 2 * math.pi);

      final paint = Paint()
        ..color = BVColors.secondary.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, yBase - drift), r, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
