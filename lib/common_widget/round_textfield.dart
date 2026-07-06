import 'package:flutter/material.dart';
import '../common/bv_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dark-glass text field with animated focus glow + optional suffix widget
// ─────────────────────────────────────────────────────────────────────────────
class RoundTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;

  const RoundTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.errorText,
  });

  @override
  State<RoundTextfield> createState() => _RoundTextfieldState();
}

class _RoundTextfieldState extends State<RoundTextfield>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late AnimationController _focusController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (_, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _isFocused ? 0.10 : 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasError
                    ? Colors.redAccent.withValues(alpha: 0.70)
                    : _isFocused
                        ? BVColors.primaryLight.withValues(alpha: 0.70)
                        : Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: BVColors.primary
                            .withValues(alpha: 0.22 * _glowAnimation.value),
                        blurRadius: 14,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: child,
          ),
          child: Focus(
            onFocusChange: (focused) {
              setState(() => _isFocused = focused);
              if (focused) {
                _focusController.forward();
              } else {
                _focusController.reverse();
              }
            },
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              style: const TextStyle(color: BVColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: BVColors.textMuted.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ),
        // Inline error message
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 13),
                const SizedBox(width: 4),
                Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
