import 'dart:ui';
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BVColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BVColors.secondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Community',
                        style: TextStyle(
                          color: BVColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connect with fellow bibliophiles',
                        style: TextStyle(
                          color: BVColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Custom TabBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: BVColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BVColors.glassBorder),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        gradient: BVColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: BVColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: BVColors.textMuted,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      tabs: const [
                        Tab(text: 'Book Clubs'),
                        Tab(text: 'Discussions'),
                        Tab(text: 'Leaderboard'),
                      ],
                    ),
                  ),
                ),

                // TabBarView content
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _buildBookClubs(),
                      _buildDiscussions(),
                      _buildLeaderboard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──── Tab 1: Book Clubs ──────────────────────────────────────────────────
  Widget _buildBookClubs() {
    final clubs = [
      {'name': 'Sci-Fi Explorers', 'members': '1,240', 'topic': 'Reading: Stellar Odyssey', 'image': '🚀'},
      {'name': 'Thriller Addicts', 'members': '890', 'topic': 'Reading: The Midnight Algorithm', 'image': '🔍'},
      {'name': 'Fantasy Realm', 'members': '2,150', 'topic': 'Reading: Dragon\'s Covenant', 'image': '⚔️'},
      {'name': 'Romantic Escapes', 'members': '650', 'topic': 'Reading: A Thousand Sunsets', 'image': '❤️'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: clubs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final club = clubs[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BVColors.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BVColors.glassBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: BVColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      club['image']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club['name']!,
                          style: const TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          club['topic']!,
                          style: const TextStyle(color: BVColors.secondaryLight, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${club['members']} active members',
                          style: const TextStyle(color: BVColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: BVColors.primary),
                      ),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(color: BVColors.primaryLight, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ──── Tab 2: Discussions ──────────────────────────────────────────────────
  Widget _buildDiscussions() {
    final posts = [
      {
        'user': 'Alex Reader',
        'handle': '@alex_r',
        'avatar': 'A',
        'content': 'Has anyone finished chapter 12 of "Stellar Odyssey" yet? That plot twist about the alien beacon was absolutely mindblowing! 🤯 Let\'s discuss.',
        'likes': '24',
        'comments': '15',
        'time': '2h ago'
      },
      {
        'user': 'Sarah Jenkins',
        'handle': '@sarah_j',
        'avatar': 'S',
        'content': 'Looking for recommendations for books similar to "The Midnight Algorithm". I love fast-paced techno-thrillers with strong detective protagonists! 🔍',
        'likes': '12',
        'comments': '8',
        'time': '5h ago'
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BVColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BVColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: BVColors.primary,
                    child: Text(post['avatar']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['user']!, style: const TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('${post['handle']} · ${post['time']}', style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded, color: BVColors.textMuted),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                post['content']!,
                style: const TextStyle(color: BVColors.textSecondary, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.favorite_border_rounded, size: 16, color: BVColors.textMuted),
                  const SizedBox(width: 6),
                  Text(post['likes']!, style: const TextStyle(color: BVColors.textMuted, fontSize: 12)),
                  const SizedBox(width: 20),
                  Icon(Icons.chat_bubble_outline_rounded, size: 16, color: BVColors.textMuted),
                  const SizedBox(width: 6),
                  Text(post['comments']!, style: const TextStyle(color: BVColors.textMuted, fontSize: 12)),
                  const Spacer(),
                  Icon(Icons.share_rounded, size: 16, color: BVColors.textMuted),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ──── Tab 3: Leaderboard ──────────────────────────────────────────────────
  Widget _buildLeaderboard() {
    final ranks = [
      {'rank': '1', 'name': 'Malith Shehan', 'xp': '24,500 XP', 'streak': '42 days', 'avatar': 'M', 'isMe': true},
      {'rank': '2', 'name': 'Elena Frost', 'xp': '22,100 XP', 'streak': '31 days', 'avatar': 'E', 'isMe': false},
      {'rank': '3', 'name': 'Marcus Webb', 'xp': '20,400 XP', 'streak': '28 days', 'avatar': 'M', 'isMe': false},
      {'rank': '4', 'name': 'Sophia Lane', 'xp': '18,900 XP', 'streak': '15 days', 'avatar': 'S', 'isMe': false},
      {'rank': '5', 'name': 'James Kira', 'xp': '15,600 XP', 'streak': '12 days', 'avatar': 'J', 'isMe': false},
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: ranks.length,
      itemBuilder: (context, index) {
        final rank = ranks[index];
        final isTop3 = index < 3;
        final rankColors = [
          BVColors.gold,
          BVColors.secondary,
          BVColors.primaryLight,
        ];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: rank['isMe'] as bool ? BVColors.primary.withValues(alpha: 0.1) : BVColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: rank['isMe'] as bool ? BVColors.primary.withValues(alpha: 0.4) : BVColors.glassBorder,
            ),
          ),
          child: Row(
            children: [
              // Rank Number / Badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isTop3 ? rankColors[index].withValues(alpha: 0.15) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  rank['rank'].toString(),
                  style: TextStyle(
                    color: isTop3 ? rankColors[index] : BVColors.textMuted,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: isTop3 ? rankColors[index] : BVColors.surfaceElevated,
                radius: 20,
                child: Text(
                  rank['avatar'].toString(),
                  style: TextStyle(
                    color: isTop3 ? Colors.black87 : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rank['name'].toString(),
                          style: const TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (rank['isMe'] as bool) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: BVColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rank['xp'].toString(),
                      style: const TextStyle(color: BVColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        rank['streak'].toString(),
                        style: const TextStyle(color: BVColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text('Streak', style: TextStyle(color: BVColors.textMuted, fontSize: 10)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
