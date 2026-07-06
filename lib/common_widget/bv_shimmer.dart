import 'package:flutter/material.dart';
import '../common/bv_colors.dart';

class BVShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BVShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<BVShimmer> createState() => _BVShimmerState();
}

class _BVShimmerState extends State<BVShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [
              BVColors.surface,
              BVColors.surfaceElevated,
              BVColors.surface,
            ],
          ),
        ),
      ),
    );
  }
}

/// Full shimmer loading layout for book cards
class BVBookCardShimmer extends StatelessWidget {
  const BVBookCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BVShimmer(width: 140, height: 200, borderRadius: 14),
        const SizedBox(height: 8),
        const BVShimmer(width: 110, height: 12, borderRadius: 6),
        const SizedBox(height: 4),
        const BVShimmer(width: 80, height: 10, borderRadius: 6),
      ],
    );
  }
}
