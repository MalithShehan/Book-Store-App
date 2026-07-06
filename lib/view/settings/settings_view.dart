import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _darkMode = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _soundEffects = true;
  bool _haptics = true;
  bool _autoDownload = false;
  String _fontFamily = 'SF Pro Text';
  double _fontSize = 16;
  int _selectedTheme = 0;

  final List<Map<String, dynamic>> _themes = [
    {'name': 'Midnight', 'color': const Color(0xFF7C4DFF)},
    {'name': 'Ocean', 'color': const Color(0xFF00E5FF)},
    {'name': 'Ember', 'color': const Color(0xFFFF6B6B)},
    {'name': 'Forest', 'color': const Color(0xFF69F0AE)},
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: BVColors.textPrimary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Text('Settings', style: TextStyle(color: BVColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
            ),

            // ── Appearance ─────────────────────────────────────────────────
            _section('🎨 Appearance', [
              _switchTile(Icons.dark_mode_rounded, 'Dark Mode', _darkMode, (v) => setState(() => _darkMode = v)),
              _infoTile(Icons.palette_rounded, 'Theme Color', trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: _themes.asMap().entries.map((e) {
                  final selected = e.key == _selectedTheme;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTheme = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 6),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: e.value['color'] as Color,
                        shape: BoxShape.circle,
                        border: selected ? Border.all(color: Colors.white, width: 2) : null,
                        boxShadow: selected ? [BoxShadow(color: (e.value['color'] as Color).withValues(alpha: 0.5), blurRadius: 8)] : null,
                      ),
                    ),
                  );
                }).toList(),
              )),
            ]),

            // ── Reading ────────────────────────────────────────────────────
            _section('📖 Reading', [
              _infoTile(Icons.text_fields_rounded, 'Font Family', subtitle: _fontFamily,
                trailing: DropdownButton<String>(
                  value: _fontFamily,
                  dropdownColor: BVColors.surface,
                  underline: const SizedBox(),
                  style: const TextStyle(color: BVColors.primaryLight, fontSize: 12),
                  items: ['SF Pro Text', 'Georgia', 'Courier New'].map((f) =>
                    DropdownMenuItem(value: f, child: Text(f, style: const TextStyle(color: BVColors.textPrimary, fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _fontFamily = v!),
                ),
              ),
              _infoTile(Icons.format_size_rounded, 'Font Size', subtitle: '${_fontSize.toInt()}px',
                trailing: SizedBox(
                  width: 140,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      activeTrackColor: BVColors.primary,
                      inactiveTrackColor: BVColors.surfaceElevated,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 12,
                      max: 24,
                      onChanged: (v) => setState(() => _fontSize = v),
                    ),
                  ),
                ),
              ),
              _switchTile(Icons.download_outlined, 'Auto-Download', _autoDownload, (v) => setState(() => _autoDownload = v)),
            ]),

            // ── Notifications ──────────────────────────────────────────────
            _section('🔔 Notifications', [
              _switchTile(Icons.notifications_outlined, 'Push Notifications', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
              _switchTile(Icons.email_outlined, 'Email Notifications', _emailNotifications, (v) => setState(() => _emailNotifications = v)),
            ]),

            // ── Accessibility ──────────────────────────────────────────────
            _section('♿ Accessibility', [
              _switchTile(Icons.volume_up_rounded, 'Sound Effects', _soundEffects, (v) => setState(() => _soundEffects = v)),
              _switchTile(Icons.vibration_rounded, 'Haptic Feedback', _haptics, (v) => setState(() => _haptics = v)),
            ]),

            // ── Language ───────────────────────────────────────────────────
            _section('🌍 Language & Region', [
              _navTile(Icons.language_rounded, 'App Language', subtitle: 'English'),
              _navTile(Icons.currency_exchange_rounded, 'Currency', subtitle: 'USD (\$)'),
            ]),

            // ── Privacy ────────────────────────────────────────────────────
            _section('🔒 Privacy & Security', [
              _switchTile(Icons.fingerprint_rounded, 'Biometric Login', true, (_) {}),
              _navTile(Icons.block_rounded, 'Blocked Users'),
              _navTile(Icons.delete_outline_rounded, 'Clear Cache', subtitle: '42 MB'),
            ]),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1A0A3E), Color(0xFF0A2040)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: BVColors.gold, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BookVerse Premium', style: TextStyle(color: BVColors.textPrimary, fontWeight: FontWeight.w700)),
                          Text('Unlimited books, ad-free, offline reading', style: TextStyle(color: BVColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: BVColors.goldGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Active', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: media.padding.bottom + 24),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
          child: Text(title, style: const TextStyle(color: BVColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: BVColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BVColors.glassBorder),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _switchTile(IconData icon, String label, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: BVColors.surfaceElevated, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: BVColors.textSecondary, size: 18),
      ),
      title: Text(label, style: const TextStyle(color: BVColors.textPrimary, fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        inactiveTrackColor: BVColors.surfaceElevated,
      ),
    );
  }

  Widget _navTile(IconData icon, String label, {String? subtitle}) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: BVColors.surfaceElevated, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: BVColors.textSecondary, size: 18),
      ),
      title: Text(label, style: const TextStyle(color: BVColors.textPrimary, fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: BVColors.textMuted, fontSize: 12)) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: BVColors.textMuted, size: 14),
      onTap: () {},
    );
  }

  Widget _infoTile(IconData icon, String label, {String? subtitle, Widget? trailing}) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: BVColors.surfaceElevated, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: BVColors.textSecondary, size: 18),
      ),
      title: Text(label, style: const TextStyle(color: BVColors.textPrimary, fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: BVColors.textMuted, fontSize: 12)) : null,
      trailing: trailing,
    );
  }
}
