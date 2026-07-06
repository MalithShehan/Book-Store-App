import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import 'package:flutter_app/common_widget/round_button.dart';
import 'package:flutter_app/common_widget/round_textfield.dart';
import 'package:flutter_app/view/login/signin_view.dart';
import 'package:flutter_app/view/dashboard/dashboard_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView>
    with SingleTickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirm = TextEditingController();

  // ── UI state ───────────────────────────────────────────────────────────────
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  // ── Validation errors ──────────────────────────────────────────────────────
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

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

    // 7 staggered slots (title + 4 fields + terms + button)
    _fades = List.generate(7, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(0.08 * i, (0.08 * i + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });

    _slides = List.generate(7, (i) {
      return Tween<Offset>(
        begin: const Offset(0.25, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(0.08 * i, (0.08 * i + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    txtName.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirm.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _stagger(int i, Widget child) => FadeTransition(
        opacity: _fades[i],
        child: SlideTransition(position: _slides[i], child: child),
      );

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email);
  }

  // ── Validation ─────────────────────────────────────────────────────────────
  bool _validate() {
    setState(() {
      _nameError =
          txtName.text.trim().isEmpty ? "Full name is required" : null;

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

      if (txtConfirm.text.isEmpty) {
        _confirmError = "Please confirm your password";
      } else if (txtConfirm.text != txtPassword.text) {
        _confirmError = "Passwords do not match";
      } else {
        _confirmError = null;
      }
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _onCreateAccount() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    // Simulate network call
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

  // ── Password toggle icon ───────────────────────────────────────────────────
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
          // ── Background ─────────────────────────────────────────────────────
          CustomPaint(
            size: media,
            painter: _SignUpBgPainter(),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── AppBar ──────────────────────────────────────────────────
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

                // ── Scrollable form ──────────────────────────────────────────
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
                                "Create Account",
                                style: TextStyle(
                                  color: BVColors.textPrimary,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Join the Book Grocer community",
                                style: TextStyle(
                                  color: BVColors.textMuted,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Full Name
                        _stagger(
                          1,
                          RoundTextfield(
                            controller: txtName,
                            hintText: "Full Name",
                            keyboardType: TextInputType.name,
                            errorText: _nameError,
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

                        // Password
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
                        const SizedBox(height: 16),

                        // Confirm Password
                        _stagger(
                          4,
                          RoundTextfield(
                            controller: txtConfirm,
                            hintText: "Confirm Password",
                            obscureText: !_showConfirm,
                            errorText: _confirmError,
                            suffixIcon: _eyeIcon(
                              _showConfirm,
                              () =>
                                  setState(() => _showConfirm = !_showConfirm),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Terms note
                        _stagger(
                          5,
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text:
                                    "By creating an account you agree to our ",
                                style: TextStyle(
                                    color: BVColors.textMuted, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      color: BVColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style:
                                        const TextStyle(color: BVColors.textMuted),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
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

                        const SizedBox(height: 28),

                        // Create Account button
                        _stagger(
                          6,
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
                                  title: "Create Account",
                                  onPressed: _onCreateAccount,
                                ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In link — navigates directly to Sign In
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, _, _) => const SignInView(),
                                  transitionsBuilder: (_, anim, _, child) =>
                                      SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(-1, 0),
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
                                text: "Already have an account?  ",
                                style: TextStyle(
                                    color: BVColors.textMuted, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
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

                        const SizedBox(height: 20),
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
// Background — dark navy + gold glow top-left
// ─────────────────────────────────────────────────────────────────────────────
class _SignUpBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = BVColors.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final glow = Paint()
      ..color = BVColors.gold.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      size.width * 0.45,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}