import 'dart:ui';
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_book_card.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';
import '../book_detail/book_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  final PageController _bannerCtrl = PageController(viewportFraction: 0.88);
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  int _bannerPage = 0;
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _scrollCtrl.addListener(() {
      final s = _scrollCtrl.offset > 10;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _bannerCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  void _openBook(BookModel book) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => BookDetailView(book: book),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Background solid color
          Container(
            color: BVColors.background,
          ),
          // Glow orb top-right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BVColors.primary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main scroll
          CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ──────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 130,
                collapsedHeight: 70,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: FadeTransition(
                    opacity: _headerFade,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Good Evening 👋',
                                  style: TextStyle(
                                    color: BVColors.textMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                ShaderMask(
                                  shaderCallback: (b) => BVColors.primaryGradient.createShader(b),
                                  child: const Text(
                                    'BookVerse',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notification bell
                          _iconBtn(Icons.notifications_outlined, () {}),
                          const SizedBox(width: 10),
                          // Avatar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/image/u1.jpg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: BVColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search Bar ───────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: BVColors.glassStrong,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: BVColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(Icons.search_rounded, color: BVColors.textMuted, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Search books, authors, genres...',
                                    style: TextStyle(color: BVColors.textMuted, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: BVColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Featured Banner Carousel ──────────────────────────
                    _sectionHeader('Featured', 'View All', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 190,
                      child: PageView.builder(
                        controller: _bannerCtrl,
                        itemCount: MockData.books.take(4).length,
                        onPageChanged: (i) => setState(() => _bannerPage = i),
                        itemBuilder: (_, i) {
                          final book = MockData.books[i];
                          final active = i == _bannerPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: active ? 0 : 10,
                            ),
                            child: _FeaturedBannerCard(
                              book: book,
                              onTap: () => _openBook(book),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        MockData.books.take(4).length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _bannerPage ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: i == _bannerPage ? BVColors.primaryGradient : null,
                            color: i != _bannerPage ? BVColors.textMuted.withValues(alpha: 0.3) : null,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── AI Reading Stats Card ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BVGradientCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A0A3E), Color(0xFF0A2040)],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: BVColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.local_fire_department_rounded, color: BVColors.gold, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '🔥 7-Day Streak!',
                                    style: TextStyle(
                                      color: BVColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You\'ve read 87 hours this month. Keep going!',
                                    style: TextStyle(color: BVColors.textMuted, fontSize: 12),
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: 0.6,
                                      backgroundColor: BVColors.primary.withValues(alpha: 0.2),
                                      color: BVColors.gold,
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Continue Reading ──────────────────────────────────
                    _sectionHeader('Continue Reading', 'Library', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.books
                            .where((b) => b.readingProgress > 0)
                            .length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, i) {
                          final book = MockData.books
                              .where((b) => b.readingProgress > 0)
                              .toList()[i];
                          return _ContinueReadingCard(
                            book: book,
                            onTap: () => _openBook(book),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Bestsellers ───────────────────────────────────────
                    _sectionHeader('Bestsellers 🏆', 'See All', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.books
                            .where((b) => b.isBestseller)
                            .length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, i) {
                          final book = MockData.books
                              .where((b) => b.isBestseller)
                              .toList()[i];
                          return BVBookCard(
                            book: book,
                            onTap: () => _openBook(book),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Categories ────────────────────────────────────────
                    _sectionHeader('Categories', 'All', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final cat = MockData.categories[i];
                          return _CategoryChip(
                            category: cat.name,
                            emoji: cat.icon,
                            color: BVColors.categoryColors[i % BVColors.categoryColors.length],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── New Arrivals ──────────────────────────────────────
                    _sectionHeader('New Arrivals ✨', 'See All', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.books.where((b) => b.isNew).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, i) {
                          final book = MockData.books.where((b) => b.isNew).toList()[i];
                          return BVBookCard(book: book, onTap: () => _openBook(book));
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Popular Authors ───────────────────────────────────
                    _sectionHeader('Popular Authors', 'Follow', () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.authors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, i) {
                          final author = MockData.authors[i];
                          return _AuthorCard(author: author);
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Recommended for You ───────────────────────────────
                    _sectionHeader('Recommended for You 🤖', 'More', () {}),
                    const SizedBox(height: 14),
                    ...MockData.books.take(4).map(
                          (book) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: BVBookListTile(
                              book: book,
                              onTap: () => _openBook(book),
                            ),
                          ),
                        ),

                    SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ],
          ),
          // Top bar blur when scrolled
          if (_scrolled)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: media.padding.top + 70,
                    color: BVColors.background.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: BVColors.glass,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BVColors.glassBorder),
        ),
        child: Icon(icon, color: BVColors.textPrimary, size: 22),
      ),
    );
  }

  Widget _sectionHeader(String title, String action, VoidCallback onAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: BVColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: BVColors.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _FeaturedBannerCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const _FeaturedBannerCard({required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              book.cover,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: BVColors.surface),
            ),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xDD0A0E1A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.35, 1.0],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (book.isBestseller)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: BVColors.gold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'BESTSELLER',
                        style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900),
                      ),
                    ),
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        book.author,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded, color: BVColors.gold, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: const TextStyle(color: BVColors.gold, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const _ContinueReadingCard({required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BVColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BVColors.glassBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                book.cover,
                width: 60,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 60, height: 88, color: BVColors.cardDark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BVColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(book.author, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: book.readingProgress,
                            backgroundColor: BVColors.surfaceElevated,
                            color: BVColors.secondary,
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(book.readingProgress * 100).toInt()}%',
                        style: const TextStyle(color: BVColors.secondary, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  final String emoji;
  final Color color;

  const _CategoryChip({required this.category, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            category,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AuthorCard extends StatelessWidget {
  final dynamic author;

  const _AuthorCard({required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: BVColors.primaryGradient,
            boxShadow: [
              BoxShadow(color: BVColors.primary.withValues(alpha: 0.35), blurRadius: 12, spreadRadius: 2),
            ],
          ),
          padding: const EdgeInsets.all(2),
          child: ClipOval(
            child: Image.asset(
              author.avatar,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: BVColors.surface,
                child: const Icon(Icons.person, color: Colors.white54, size: 32),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            author.name.toString().split(' ').first,
            textAlign: TextAlign.center,
            style: const TextStyle(color: BVColors.textSecondary, fontSize: 11),
          ),
        ),
        Text(
          author.genre,
          style: const TextStyle(color: BVColors.textMuted, fontSize: 10),
        ),
      ],
    );
  }
}
