import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import 'package:flutter_app/common_widget/round_button.dart';
import 'package:flutter_app/common_widget/round_textfield.dart';
import 'package:flutter_app/view/login/signup_view.dart';
import 'package:flutter_app/view/dashboard/dashboard_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  final TextEditingController txtCode = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool isStay = false;
  bool _showPassword = false;
  bool _isLoading = false;

  // ── Validation errors ──────────────────────────────────────────────────────
  String? _emailError;
  String? _passwordError;

  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _entranceCtrl;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // 6 slots: title, code, email, password, row, button
    _fades = List.generate(6, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(0.10 * i, (0.10 * i + 0.45).clamp(0.0, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });

    _slides = List.generate(6, (i) {
      return Tween<Offset>(
        begin: const Offset(0.25, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(0.10 * i, (0.10 * i + 0.45).clamp(0.0, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    txtCode.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Widget _stagger(int i, Widget child) => FadeTransition(
        opacity: _fades[i],
        child: SlideTransition(position: _slides[i], child: child),
      );

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email);

  bool _validate() {
    setState(() {
      if (txtEmail.text.trim().isEmpty) {
        _emailError = "Email address is required";
      } else if (!_isValidEmail(txtEmail.text.trim())) {
        _emailError = "Enter a valid email address";
      } else {
        _emailError = null;
      }

      if (txtPassword.text.isEmpty) {
        _passwordError = "Password is required";
      } else if (txtPassword.text.length < 6) {
        _passwordError = "Password must be at least 6 characters";
      } else {
        _passwordError = null;
      }
    });

    return _emailError == null && _passwordError == null;
  }

  Future<void> _onSignIn() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const DashboardView(),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  Widget _eyeIcon(bool visible, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Icon(
            visible
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: BVColors.textMuted,
            size: 20,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Background
          CustomPaint(
            size: media,
            painter: _SignInBgPainter(),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── AppBar ───────────────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: BVColors.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable body ──────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Title
                        _stagger(
                          0,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  color: BVColors.textPrimary,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Sign in to your account",
                                style: TextStyle(
                                  color: BVColors.textMuted,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Group code (optional)
                        _stagger(
                          1,
                          RoundTextfield(
                            controller: txtCode,
                            hintText: "Optional Group Special Code",
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        _stagger(
                          2,
                          RoundTextfield(
                            controller: txtEmail,
                            hintText: "Email Address",
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password + show/hide toggle
                        _stagger(
                          3,
                          RoundTextfield(
                            controller: txtPassword,
                            hintText: "Password",
                            obscureText: !_showPassword,
                            errorText: _passwordError,
                            suffixIcon: _eyeIcon(
                              _showPassword,
                              () => setState(
                                  () => _showPassword = !_showPassword),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Stay logged in + Forgot password
                        _stagger(
                          4,
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => isStay = !isStay),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isStay
                                        ? BVColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isStay
                                          ? BVColors.primary
                                          : BVColors.textMuted
                                              .withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: isStay
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 14)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Stay Logged In",
                                style: TextStyle(
                                    color: BVColors.textMuted, fontSize: 14),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: BVColors.primaryLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Sign In button
                        _stagger(
                          5,
                          _isLoading
                              ? Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    gradient: BVColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                )
                              : RoundButton(
                                  title: "Sign In",
                                  onPressed: _onSignIn,
                                ),
                        ),

                        const SizedBox(height: 28),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color:
                                    BVColors.textMuted.withValues(alpha: 0.18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              child: Text(
                                "or",
                                style: TextStyle(
                                    color: BVColors.textMuted, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color:
                                    BVColors.textMuted.withValues(alpha: 0.18),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Sign Up link — navigates directly to Sign Up
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, _, _) => const SignUpView(),
                                  transitionsBuilder: (_, anim, _, child) =>
                                      SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                        parent: anim, curve: Curves.easeInOut)),
                                    child: child,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 350),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account?  ",
                                style: TextStyle(
                                    color: BVColors.textMuted, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: BVColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
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
// Background — dark navy + teal glow top-right
// ─────────────────────────────────────────────────────────────────────────────
class _SignInBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = BVColors.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final glow = Paint()
      ..color = BVColors.primary.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.12),
      size.width * 0.45,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
