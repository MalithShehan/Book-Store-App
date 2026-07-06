import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../data/mock_data.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late List<dynamic> _notifications;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(MockData.notifications);
  }

  List get _filtered => _showUnreadOnly
      ? _notifications.where((n) => !n.isRead).toList()
      : _notifications;

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  Color _typeColor(String type) {
    switch (type) {
      case 'new_book': return BVColors.primary;
      case 'price_drop': return BVColors.success;
      case 'reminder': return BVColors.gold;
      case 'author': return BVColors.secondary;
      default: return BVColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 16),
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
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Notifications', style: TextStyle(color: BVColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                          if (_unreadCount > 0) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: BVColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$_unreadCount new', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _notifications = _notifications.map((n) => n).toList();
                      }),
                      child: const Text('Mark all read', style: TextStyle(color: BVColors.primaryLight, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _filterChip('All', !_showUnreadOnly, () => setState(() => _showUnreadOnly = false)),
                    const SizedBox(width: 10),
                    _filterChip('Unread ($_unreadCount)', _showUnreadOnly, () => setState(() => _showUnreadOnly = true)),
                  ],
                ),
              ],
            ),
          ),
          // Notifications list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_none_rounded, color: BVColors.textMuted, size: 60),
                        SizedBox(height: 16),
                        Text('No notifications', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final n = _filtered[i];
                      return _NotificationCard(
                        notification: n,
                        accentColor: _typeColor(n.type),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? BVColors.primaryGradient : null,
          color: selected ? null : BVColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.transparent : BVColors.glassBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : BVColors.textMuted,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final dynamic notification;
  final Color accentColor;

  const _NotificationCard({required this.notification, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return BVGlassCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: notification.isRead ? null : accentColor.withValues(alpha: 0.06),
      borderColor: notification.isRead ? null : accentColor.withValues(alpha: 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(notification.icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: BVColors.textPrimary,
                          fontSize: 14,
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(color: BVColors.textMuted, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(notification.time, style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
