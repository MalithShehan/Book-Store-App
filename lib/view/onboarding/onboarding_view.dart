import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import 'welcome_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  int page = 0;
  final PageController _pageController = PageController();

  late AnimationController _bgController;
  late AnimationController _floatController;
  late AnimationController _contentController;

  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> pageArr = [
    {
      "title": "Discounted\nSecondhand Books",
      "sub_title": "Used and near new secondhand books at great prices.",
      "img": "assets/image/on_1.png",
    },
    {
      "title": "20 Book Grocers\nNationally",
      "sub_title": "We've successfully opened 20 stores across Australia.",
      "img": "assets/image/on_2.png",
    },
    {
      "title": "Sell or Recycle Your\nOld Books With Us",
      "sub_title":
          "Looking to downsize? Sell or recycle old books — the Book Grocer can help.",
      "img": "assets/image/on_3.png",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Drifting background blobs
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Book image levitation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -14, end: 14).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Text entrance on each page change
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-0.25, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _contentController.forward();

    _pageController.addListener(() {
      if (mounted) {
        final newPage = _pageController.page?.round() ?? 0;
        if (newPage != page) {
          setState(() => page = newPage);
          _contentController
            ..reset()
            ..forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _floatController.dispose();
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const WelcomeView(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
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
          // ── Animated blob background ───────────────────────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, _) => CustomPaint(
              size: media,
              painter: _OnboardingBlobPainter(_bgController.value),
            ),
          ),

          // ── Main layout ────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageArr.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final pObj = pageArr[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: media.width * 0.07,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Floating book image
                            AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (_, child) => Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: child,
                              ),
                              child: Container(
                                width: math.min(media.width * 0.70, media.height * 0.40),
                                height: math.min(media.width * 0.70, media.height * 0.40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: BVColors.primary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 50,
                                      spreadRadius: 8,
                                      offset: const Offset(0, 24),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Image.asset(
                                    pObj["img"]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: media.height * 0.055),

                            // Animated title (slides from left)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Text(
                                  pObj["title"]!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: BVColors.textPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Animated subtitle
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                pObj["sub_title"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: BVColors.textMuted,
                                  fontSize: 15,
                                  height: 1.65,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Bottom controls ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, media.height * 0.05),
                  child: Column(
                    children: [
                      // Dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pageArr.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            width: page == index ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: page == index
                                  ? BVColors.secondary
                                  : BVColors.textMuted.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Skip / Next row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skip
                          TextButton(
                            onPressed: _goToWelcome,
                            style: TextButton.styleFrom(
                              foregroundColor: BVColors.textMuted,
                            ),
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),

                          // Next / Get Started (animated switcher)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: page < pageArr.length - 1
                                ? _GradientNavButton(
                                    key: const ValueKey('next'),
                                    label: "Next",
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: () {
                                      _pageController.animateToPage(
                                        page + 1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  )
                                : _GradientNavButton(
                                    key: const ValueKey('start'),
                                    label: "Get Started",
                                    icon: Icons.rocket_launch_rounded,
                                    onPressed: _goToWelcome,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient pill button (Next / Get Started)
// ─────────────────────────────────────────────────────────────────────────────
class _GradientNavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientNavButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_GradientNavButton> createState() => _GradientNavButtonState();
}

class _GradientNavButtonState extends State<_GradientNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.93)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            gradient: BVColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: BVColors.primary.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drifting blob background painter
// ─────────────────────────────────────────────────────────────────────────────
class _OnboardingBlobPainter extends CustomPainter {
  final double t;
  _OnboardingBlobPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Base solid background
    final bg = Paint()..color = BVColors.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    // Blob 1 — teal, drifts top-left
    final p1 = Paint()
      ..color = BVColors.primary.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(
      Offset(size.width * (0.15 + 0.18 * t), size.height * (0.12 + 0.12 * t)),
      size.width * 0.48,
      p1,
    );

    // Blob 2 — secondary/cyan, drifts bottom-right
    final p2 = Paint()
      ..color = BVColors.secondary.withValues(alpha: 0.11)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(
      Offset(
          size.width * (0.88 - 0.18 * t), size.height * (0.80 - 0.12 * t)),
      size.width * 0.42,
      p2,
    );

    // Blob 3 — gold hint
    final p3 = Paint()
      ..color = BVColors.gold.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * (0.5 + 0.1 * math.sin(t * math.pi))),
      size.width * 0.3,
      p3,
    );
  }

  @override
  bool shouldRepaint(_OnboardingBlobPainter old) => old.t != t;
}
