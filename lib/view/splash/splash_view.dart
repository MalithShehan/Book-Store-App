import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _textCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
    );
    _textSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _glowPulse = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _particleCtrl, curve: Curves.easeInOut),
    );

    _animate();
  }

  Future<void> _animate() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoCtrl.forward();
    await _textCtrl.forward();
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingView(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _particleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Animated particles background
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              painter: _ParticlePainter(_particleCtrl.value),
              size: MediaQuery.of(context).size,
            ),
          ),
          // Glow orbs
          AnimatedBuilder(
            animation: _glowPulse,
            builder: (_, __) => Stack(
              children: [
                Positioned(
                  top: -100,
                  left: -80,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          BVColors.primary.withValues(alpha: 0.25 * _glowPulse.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  right: -60,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          BVColors.secondary.withValues(alpha: 0.20 * _glowPulse.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: BVColors.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: BVColors.primary.withValues(alpha: 0.55),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: BVColors.secondary.withValues(alpha: 0.30),
                              blurRadius: 60,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Text
                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _textOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                BVColors.primaryGradient.createShader(bounds),
                            child: const Text(
                              'BookVerse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Your Universe of Stories',
                            style: TextStyle(
                              color: BVColors.textMuted,
                              fontSize: 14,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Loading dots
                AnimatedBuilder(
                  animation: _particleCtrl,
                  builder: (_, __) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final phase = (_particleCtrl.value + i * 0.2) % 1.0;
                        final opacity = math.sin(phase * math.pi).clamp(0.2, 1.0);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                gradient: BVColors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles = List.generate(
    30,
    (i) => _Particle(
      x: (i * 137.5 % 1.0),
      y: (i * 73.1 % 1.0),
      size: 1.0 + (i % 3) * 0.8,
      speed: 0.2 + (i % 5) * 0.1,
      phase: i * 0.31,
    ),
  );

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final y = (p.y + progress * p.speed) % 1.0;
      final opacity = (math.sin((y + p.phase) * math.pi * 2) * 0.5 + 0.5) * 0.4;
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        Paint()
          ..color = BVColors.primary.withValues(alpha: opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, phase;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}
