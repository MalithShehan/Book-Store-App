import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../model/book_model.dart';

class AudiobookPlayerView extends StatefulWidget {
  final BookModel book;
  const AudiobookPlayerView({super.key, required this.book});

  @override
  State<AudiobookPlayerView> createState() => _AudiobookPlayerViewState();
}

class _AudiobookPlayerViewState extends State<AudiobookPlayerView>
    with TickerProviderStateMixin {
  late AnimationController _vinylCtrl;
  late AnimationController _waveCtrl;
  bool _isPlaying = false;
  double _progress = 0.32;
  double _speed = 1.0;
  final List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _vinylCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _vinylCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _vinylCtrl.repeat();
    } else {
      _vinylCtrl.stop();
    }
  }

  String _formatTime(double progress) {
    final totalSec = (6 * 60 + 30) * 60; // 6h 30m
    final current = (totalSec * progress).toInt();
    final h = current ~/ 3600;
    final m = (current % 3600) ~/ 60;
    final s = current % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0A1A), Color(0xFF0A0E1A), Color(0xFF0A1020)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: BVGlassCard(
                        padding: const EdgeInsets.all(10),
                        borderRadius: 12,
                        child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text('Now Playing', style: TextStyle(color: BVColors.textMuted, fontSize: 12)),
                          Text('Audiobook', style: TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    BVGlassCard(
                      padding: const EdgeInsets.all(10),
                      borderRadius: 12,
                      child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Vinyl record
              AnimatedBuilder(
                animation: _vinylCtrl,
                builder: (_, __) => Transform.rotate(
                  angle: _vinylCtrl.value * 2 * math.pi,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [Color(0xFF1A1A2E), Color(0xFF2A2A4E), Color(0xFF1A1A2E)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: BVColors.primary.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Vinyl grooves
                        ...List.generate(6, (i) => Container(
                          width: 200.0 - i * 28,
                          height: 200.0 - i * 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.04 + i * 0.01),
                              width: 1,
                            ),
                          ),
                        )),
                        // Center label
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: BVColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(color: BVColors.primary.withValues(alpha: 0.5), blurRadius: 16),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              widget.book.cover,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.headphones_rounded, color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                        // Center dot
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: BVColors.background,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Book info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      widget.book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BVColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.book.author} · Chapter 1: Introduction',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BVColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Waveform visualization
              SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: _waveCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: _WaveformPainter(
                      progress: _progress,
                      animValue: _waveCtrl.value,
                      isPlaying: _isPlaying,
                    ),
                    size: Size(MediaQuery.of(context).size.width - 40, 48),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Progress slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                        activeTrackColor: BVColors.primary,
                        inactiveTrackColor: BVColors.surfaceElevated,
                        thumbColor: Colors.white,
                        overlayColor: BVColors.primaryGlow,
                      ),
                      child: Slider(
                        value: _progress,
                        onChanged: (v) => setState(() => _progress = v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatTime(_progress), style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                          Text('6h 30m', style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Speed
                    GestureDetector(
                      onTap: () {
                        final idx = _speeds.indexOf(_speed);
                        setState(() => _speed = _speeds[(idx + 1) % _speeds.length]);
                      },
                      child: BVGlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        borderRadius: 10,
                        child: Text(
                          '${_speed}x',
                          style: const TextStyle(color: BVColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ),
                    // Skip back 30s
                    GestureDetector(
                      onTap: () => setState(() => _progress = (_progress - 0.05).clamp(0.0, 1.0)),
                      child: const Icon(Icons.replay_30_rounded, color: BVColors.textSecondary, size: 36),
                    ),
                    // Play/Pause
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: BVColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: BVColors.primary.withValues(alpha: 0.5),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    // Skip forward 30s
                    GestureDetector(
                      onTap: () => setState(() => _progress = (_progress + 0.05).clamp(0.0, 1.0)),
                      child: const Icon(Icons.forward_30_rounded, color: BVColors.textSecondary, size: 36),
                    ),
                    // Bookmark
                    BVGlassCard(
                      padding: const EdgeInsets.all(10),
                      borderRadius: 10,
                      child: const Icon(Icons.bookmark_outline, color: BVColors.textSecondary, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sleep timer & queue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomAction(Icons.bedtime_outlined, 'Sleep Timer'),
                    _bottomAction(Icons.list_rounded, 'Chapters'),
                    _bottomAction(Icons.share_rounded, 'Share'),
                  ],
                ),
              ),

              SizedBox(height: media.padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: BVColors.textMuted, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: BVColors.textMuted, fontSize: 10)),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;
  final double animValue;
  final bool isPlaying;

  _WaveformPainter({required this.progress, required this.animValue, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = 40;
    final barWidth = size.width / (barCount * 1.8);
    final gap = barWidth * 0.8;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);
      final fraction = i / barCount;
      final isActive = fraction <= progress;
      final wave = isPlaying
          ? math.sin(fraction * math.pi * 8 + animValue * 2 * math.pi) * 0.5 + 0.5
          : math.sin(fraction * math.pi * 6) * 0.5 + 0.5;
      final barHeight = 8 + wave * 32;
      final color = isActive ? BVColors.primary : BVColors.surfaceElevated;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, size.height / 2),
            width: barWidth,
            height: barHeight,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => true;
}
