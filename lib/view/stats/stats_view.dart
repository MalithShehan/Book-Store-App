import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../data/mock_data.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with TickerProviderStateMixin {
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;
  int _selectedPeriod = 1; // 0=week, 1=month, 2=year

  final stats = MockData.readingStats;
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _periods = ['Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutQuart);
    _barCtrl.forward();
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final weekData = List<int>.from(stats['weeklyData'] as List);
    final maxMin = weekData.reduce(math.max);

    return Scaffold(
      backgroundColor: BVColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: BVColors.textPrimary, size: 20),
                      ),
                      const SizedBox(width: 16),
                      const Text('Reading Stats', style: TextStyle(color: BVColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Big stats row
                  Row(
                    children: [
                      _bigStat('${stats['booksRead']}', 'Books Read', '📚', BVColors.primaryLight),
                      const SizedBox(width: 12),
                      _bigStat('${stats['hoursRead']}h', 'Reading Time', '⏱️', BVColors.secondary),
                      const SizedBox(width: 12),
                      _bigStat('${stats['currentStreak']}🔥', 'Day Streak', '🔥', BVColors.gold),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Period selector
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: BVColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: _periods.asMap().entries.map((e) {
                        final selected = e.key == _selectedPeriod;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPeriod = e.key),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: selected ? BVColors.primaryGradient : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  e.value,
                                  style: TextStyle(
                                    color: selected ? Colors.white : BVColors.textMuted,
                                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bar chart
                  BVGlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Reading Minutes', style: TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _barAnim,
                          builder: (_, __) => SizedBox(
                            height: 120,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: weekData.asMap().entries.map((e) {
                                final fraction = (e.value / maxMin) * _barAnim.value;
                                final isToday = e.key == 4;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (isToday)
                                          Text(
                                            '${e.value}m',
                                            style: const TextStyle(color: BVColors.primaryLight, fontSize: 10, fontWeight: FontWeight.w700),
                                          ),
                                        const SizedBox(height: 4),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Container(
                                            height: 100 * fraction,
                                            decoration: BoxDecoration(
                                              gradient: isToday ? BVColors.primaryGradient : null,
                                              color: isToday ? null : BVColors.surfaceElevated,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(_days[e.key], style: TextStyle(
                                          color: isToday ? BVColors.primaryLight : BVColors.textMuted,
                                          fontSize: 11,
                                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Genre breakdown
                  const Text('Favorite Genres', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...MockData.categories.take(5).toList().asMap().entries.map((e) {
                    final fracs = [0.75, 0.60, 0.45, 0.38, 0.25];
                    final color = BVColors.categoryColors[e.key % BVColors.categoryColors.length];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(e.value.icon, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(e.value.name, style: const TextStyle(color: BVColors.textSecondary, fontSize: 13)),
                              const Spacer(),
                              Text('${(fracs[e.key] * 100).toInt()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          AnimatedBuilder(
                            animation: _barAnim,
                            builder: (_, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fracs[e.key] * _barAnim.value,
                                backgroundColor: color.withValues(alpha: 0.1),
                                color: color,
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Achievement badges
                  const Text('Achievements 🏆', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _achievement('🔥', 'Week Warrior', '7 day streak', true),
                      _achievement('📚', 'Bookworm', '25 books read', true),
                      _achievement('⚡', 'Speed Reader', '200 pages/day', false),
                      _achievement('🌙', 'Night Owl', '10 nights reading', true),
                      _achievement('🎯', 'Goal Crusher', 'Hit yearly goal', false),
                      _achievement('💎', 'Elite Reader', '100 books', false),
                    ],
                  ),

                  SizedBox(height: media.padding.bottom + 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigStat(String value, String label, String emoji, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: BVColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _achievement(String emoji, String title, String subtitle, bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? BVColors.gold.withValues(alpha: 0.08) : BVColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? BVColors.gold.withValues(alpha: 0.3) : BVColors.glassBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unlocked ? emoji : '🔒', style: TextStyle(fontSize: 28, color: unlocked ? null : null)),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: unlocked ? BVColors.gold : BVColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: BVColors.textMuted, fontSize: 9)),
        ],
      ),
    );
  }
}
