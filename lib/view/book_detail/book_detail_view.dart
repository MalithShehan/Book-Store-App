import 'dart:ui';
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_book_card.dart';
import '../../common_widget/bv_glass_card.dart';
import '../../common_widget/bv_gradient_button.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';

class BookDetailView extends StatefulWidget {
  final BookModel book;

  const BookDetailView({super.key, required this.book});

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView>
    with TickerProviderStateMixin {
  late TabController _tabCtrl;
  late AnimationController _heroCtrl;
  late AnimationController _contentCtrl;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  bool _isWishlisted = false;
  bool _addedToCart = false;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.book.isWishlisted;
    _tabCtrl = TabController(length: 3, vsync: this);
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _heroCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero Cover ───────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: BVColors.background,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: BVGlassCard(
                      padding: EdgeInsets.zero,
                      borderRadius: 12,
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                      child: BVGlassCard(
                        padding: const EdgeInsets.all(8),
                        borderRadius: 12,
                        child: Icon(
                          _isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: _isWishlisted ? BVColors.error : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: BVGlassCard(
                      padding: const EdgeInsets.all(8),
                      borderRadius: 12,
                      child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover image
                      Image.asset(
                        widget.book.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            gradient: BVColors.primaryGradient,
                          ),
                          child: const Icon(Icons.book, color: Colors.white30, size: 80),
                        ),
                      ),
                      // Gradient scrim
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, BVColors.background],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.45, 1.0],
                          ),
                        ),
                      ),
                      // Genre badge
                      Positioned(
                        bottom: 24,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: BVColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.book.genre,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      if (widget.book.hasAudio)
                        Positioned(
                          bottom: 24,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: BVColors.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: BVColors.gold.withValues(alpha: 0.5)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.headphones_rounded, color: BVColors.gold, size: 14),
                                SizedBox(width: 4),
                                Text('Audiobook', style: TextStyle(color: BVColors.gold, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentFade,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + Author
                          Text(
                            widget.book.title,
                            style: const TextStyle(
                              color: BVColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, color: BVColors.textMuted, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.book.author,
                                style: const TextStyle(color: BVColors.primaryLight, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Stats row
                          Row(
                            children: [
                              _statChip(Icons.star_rounded, '${widget.book.rating}', BVColors.gold),
                              const SizedBox(width: 10),
                              _statChip(Icons.rate_review_outlined, '${widget.book.reviewCount} reviews', BVColors.textMuted),
                              const SizedBox(width: 10),
                              _statChip(Icons.menu_book_rounded, '${widget.book.pages} pages', BVColors.textMuted),
                              const SizedBox(width: 10),
                              _statChip(Icons.timer_outlined, widget.book.readingTime, BVColors.textMuted),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Price row
                          Row(
                            children: [
                              ShaderMask(
                                shaderCallback: (b) => BVColors.primaryGradient.createShader(b),
                                child: Text(
                                  '\$${widget.book.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (widget.book.originalPrice != null) ...[
                                const SizedBox(width: 10),
                                Text(
                                  '\$${widget.book.originalPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: BVColors.textMuted,
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: BVColors.success.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(((widget.book.originalPrice! - widget.book.price) / widget.book.originalPrice!) * 100).toInt()}% OFF',
                                    style: const TextStyle(color: BVColors.success, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Reading progress (if started)
                          if (widget.book.readingProgress > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Reading Progress', style: TextStyle(color: BVColors.textSecondary, fontSize: 13)),
                                      Text(
                                        '${(widget.book.readingProgress * 100).toInt()}% complete',
                                        style: const TextStyle(color: BVColors.secondary, fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: widget.book.readingProgress,
                                      backgroundColor: BVColors.surfaceElevated,
                                      color: BVColors.secondary,
                                      minHeight: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: BVGradientButton(
                                  text: widget.book.readingProgress > 0 ? 'Continue Reading' : 'Buy Now',
                                  height: 50,
                                  icon: widget.book.readingProgress > 0
                                      ? Icons.auto_stories_rounded
                                      : Icons.shopping_bag_rounded,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => setState(() => _addedToCart = !_addedToCart),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _addedToCart
                                        ? BVColors.success.withValues(alpha: 0.15)
                                        : BVColors.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: _addedToCart ? BVColors.success : BVColors.glassBorder,
                                    ),
                                  ),
                                  child: Icon(
                                    _addedToCart ? Icons.check_rounded : Icons.shopping_cart_outlined,
                                    color: _addedToCart ? BVColors.success : BVColors.textSecondary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (widget.book.hasFreePreview)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: BVOutlinedButton(
                                text: 'Read Free Sample',
                                icon: Icons.remove_red_eye_outlined,
                                height: 46,
                                onPressed: () {},
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Tabs
                          Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: BVColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabCtrl,
                              indicator: BoxDecoration(
                                gradient: BVColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: BVColors.textMuted,
                              dividerColor: Colors.transparent,
                              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              padding: const EdgeInsets.all(4),
                              tabs: const [
                                Tab(text: 'Overview'),
                                Tab(text: 'Reviews'),
                                Tab(text: 'Similar'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Tab content
                          SizedBox(
                            height: 350,
                            child: TabBarView(
                              controller: _tabCtrl,
                              children: [
                                _overviewTab(),
                                _reviewsTab(),
                                _similarTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: media.padding.bottom + 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: BVColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BVColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _overviewTab() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About this book', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            widget.book.description,
            style: const TextStyle(color: BVColors.textSecondary, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 20),
          // Book info
          _infoRow('Publisher', widget.book.publisher),
          _infoRow('Published', widget.book.publishedDate),
          _infoRow('Language', widget.book.language),
          _infoRow('Pages', '${widget.book.pages}'),
          if (widget.book.hasAudio) _infoRow('Format', 'eBook + Audiobook'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: BVColors.textMuted, fontSize: 13)),
          ),
          Text(value, style: const TextStyle(color: BVColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _reviewsTab() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: MockData.reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final r = MockData.reviews[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BVColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BVColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(r.avatar, width: 36, height: 36, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 36, height: 36, color: BVColors.primary,
                            child: const Icon(Icons.person, color: Colors.white, size: 20))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.userName, style: const TextStyle(color: BVColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(r.date, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (si) => Icon(
                      si < r.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                      color: BVColors.gold,
                      size: 14,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(r.comment, style: const TextStyle(color: BVColors.textSecondary, fontSize: 13, height: 1.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.thumb_up_outlined, color: BVColors.textMuted, size: 14),
                  const SizedBox(width: 4),
                  Text('${r.likes}', style: const TextStyle(color: BVColors.textMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _similarTab() {
    final similar = MockData.books.where((b) => b.id != widget.book.id && b.genre == widget.book.genre).take(4).toList();
    if (similar.isEmpty) {
      final all = MockData.books.where((b) => b.id != widget.book.id).take(4).toList();
      return _similarGrid(all);
    }
    return _similarGrid(similar);
  }

  Widget _similarGrid(List books) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.52,
      ),
      itemCount: books.length,
      itemBuilder: (_, i) => BVBookCard(
        book: books[i],
        width: double.infinity,
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BookDetailView(book: books[i])),
        ),
      ),
    );
  }
}
