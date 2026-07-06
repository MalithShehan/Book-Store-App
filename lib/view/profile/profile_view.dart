import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../view/stats/stats_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: EdgeInsets.fromLTRB(0, media.padding.top, 0, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0A3E), Color(0xFF0A1530)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        const Text('Profile', style: TextStyle(color: BVColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: BVColors.glass,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BVColors.glassBorder),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_outlined, color: BVColors.primaryLight, size: 16),
                                SizedBox(width: 6),
                                Text('Edit', style: TextStyle(color: BVColors.primaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: BVColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: BVColors.primary.withValues(alpha: 0.5),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/image/u1.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: BVColors.surface,
                              child: const Icon(Icons.person, color: Colors.white60, size: 50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            gradient: BVColors.cyanGradient,
                            shape: BoxShape.circle,
                            border: Border.all(color: BVColors.background, width: 2),
                          ),
                          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Malith Shehan', style: TextStyle(color: BVColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('@malithshehan · Thriller & Sci-Fi Reader',
                      style: TextStyle(color: BVColors.textMuted, fontSize: 13)),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _profileStat('34', 'Books Read'),
                      _divider(),
                      _profileStat('245', 'Followers'),
                      _divider(),
                      _profileStat('89', 'Following'),
                      _divider(),
                      _profileStat('12', 'Reviews'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(Icons.bar_chart_rounded, 'Stats', BVColors.primary, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsView()));
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(Icons.bookmark_rounded, 'Bookmarks', BVColors.secondary, () {}),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(Icons.group_rounded, 'Book Clubs', BVColors.gold, () {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Account options
                  _sectionTitle('Account'),
                  const SizedBox(height: 10),
                  _optionTile(Icons.person_outline_rounded, 'Personal Info', subtitle: 'Name, email, password'),
                  _optionTile(Icons.subscriptions_outlined, 'Subscription', subtitle: 'BookVerse Premium · Active', trailing: _badge('PRO', BVColors.gold)),
                  _optionTile(Icons.payment_outlined, 'Payment Methods', subtitle: '•••• 4242'),
                  _optionTile(Icons.history_rounded, 'Purchase History', subtitle: '8 orders'),
                  const SizedBox(height: 20),
                  _sectionTitle('Preferences'),
                  const SizedBox(height: 10),
                  _optionTile(Icons.palette_outlined, 'Appearance', subtitle: 'Dark mode'),
                  _optionTile(Icons.notifications_outlined, 'Notifications', subtitle: 'All enabled'),
                  _optionTile(Icons.language_rounded, 'Language', subtitle: 'English'),
                  _optionTile(Icons.privacy_tip_outlined, 'Privacy & Security'),
                  const SizedBox(height: 20),
                  _sectionTitle('About'),
                  const SizedBox(height: 10),
                  _optionTile(Icons.help_outline_rounded, 'Help & Support'),
                  _optionTile(Icons.info_outline_rounded, 'About BookVerse', subtitle: 'Version 2.0.0'),
                  _optionTile(Icons.star_outline_rounded, 'Rate the App'),
                  const SizedBox(height: 20),
                  // Logout
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: BVColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: BVColors.error.withValues(alpha: 0.25)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: BVColors.error, size: 20),
                          SizedBox(width: 8),
                          Text('Sign Out', style: TextStyle(color: BVColors.error, fontWeight: FontWeight.w700, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('BookVerse v2.0.0 · Made with ❤️',
                        style: TextStyle(color: BVColors.textMuted.withValues(alpha: 0.5), fontSize: 11)),
                  ),
                  SizedBox(height: media.padding.bottom + 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStat(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: BVColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 30, color: BVColors.glassBorder);

  Widget _actionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(color: BVColors.textMuted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      );

  Widget _optionTile(IconData icon, String title, {String? subtitle, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: BVColors.surface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: BVColors.textSecondary, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: BVColors.textPrimary, fontSize: 14)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: BVColors.textMuted, fontSize: 12))
            : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, color: BVColors.textMuted, size: 14),
        onTap: () {},
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}
