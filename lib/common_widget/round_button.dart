import 'package:flutter/material.dart';
import '../common/bv_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Filled gradient button with scale-press animation (hit-test safe)
// ─────────────────────────────────────────────────────────────────────────────
class RoundButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: BVColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: BVColors.primary.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Outline glass button with scale-press animation (hit-test safe)
// ─────────────────────────────────────────────────────────────────────────────
class RoundOutlineButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const RoundOutlineButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  State<RoundOutlineButton> createState() => _RoundOutlineButtonState();
}

class _RoundOutlineButtonState extends State<RoundOutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: BVColors.primaryLight.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                color: BVColors.primaryLight,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy alias (kept for backward compatibility)
// ─────────────────────────────────────────────────────────────────────────────
class RoundLineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const RoundLineButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) =>
      RoundOutlineButton(title: title, onPressed: onPressed);
}
