import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/bv_colors.dart';
import '../../view/home/home_view.dart';
import '../../view/search/search_view.dart';
import '../../view/library/library_view.dart';
import '../../view/audiobook/audio_view.dart';
import '../../view/community/community_view.dart';
import '../../view/profile/profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navCtrl;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.search_rounded, label: 'Discover'),
    _NavItem(icon: Icons.local_library_rounded, label: 'Library'),
    _NavItem(icon: Icons.headset_rounded, label: 'Audio'),
    _NavItem(icon: Icons.people_rounded, label: 'Community'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  final List<Widget> _pages = const [
    HomeView(),
    SearchView(),
    LibraryView(),
    AudioView(),
    CommunityView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _navCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _navCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(media),
    );
  }

  Widget _buildBottomNav(MediaQueryData media) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, media.padding.bottom + 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: BVColors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: BVColors.glassBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.asMap().entries.map((e) {
                return _NavButton(
                  item: e.value,
                  isSelected: _currentIndex == e.key,
                  onTap: () => _onNavTap(e.key),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.isSelected) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_NavButton old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _ctrl.forward(from: 0);
    } else if (!widget.isSelected && old.isSelected) {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animated glow
              Transform.scale(
                scale: _scale.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: BVColors.primary.withValues(alpha: 0.35 * _glow.value),
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.isSelected ? BVColors.primaryGradient : null,
                        color: widget.isSelected ? null : Colors.transparent,
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: widget.isSelected ? Colors.white : BVColors.textMuted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: widget.isSelected ? BVColors.primaryLight : BVColors.textMuted,
                  fontSize: 10,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
                child: Text(widget.item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
