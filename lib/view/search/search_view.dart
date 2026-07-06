import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_book_card.dart';
import '../../data/mock_data.dart';
import '../book_detail/book_detail_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  late TabController _tabCtrl;
  bool _hasQuery = false;
  String _query = '';

  final List<String> _tabs = ['All', 'Books', 'Authors', 'Series'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    _searchCtrl.addListener(() {
      setState(() {
        _query = _searchCtrl.text;
        _hasQuery = _query.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  List get _filteredBooks => _hasQuery
      ? MockData.books
          .where((b) =>
              b.title.toLowerCase().contains(_query.toLowerCase()) ||
              b.author.toLowerCase().contains(_query.toLowerCase()) ||
              b.genre.toLowerCase().contains(_query.toLowerCase()))
          .toList()
      : MockData.books;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    color: BVColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Find your next great read',
                  style: TextStyle(color: BVColors.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 16),
                // Search field
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: BVColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasQuery ? BVColors.primary : BVColors.glassBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(
                        Icons.search_rounded,
                        color: _hasQuery ? BVColors.primaryLight : BVColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(color: BVColors.textPrimary, fontSize: 15),
                          decoration: const InputDecoration(
                            hintText: 'Search books, authors...',
                            hintStyle: TextStyle(color: BVColors.textMuted, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_hasQuery)
                        GestureDetector(
                          onTap: () => _searchCtrl.clear(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Icon(Icons.close_rounded, color: BVColors.textMuted, size: 20),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tab bar
                TabBar(
                  controller: _tabCtrl,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    gradient: BVColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: BVColors.textMuted,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  padding: EdgeInsets.zero,
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _hasQuery ? _searchResults() : _discoverContent(),
          ),
        ],
      ),
    );
  }

  Widget _searchResults() {
    if (_filteredBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: BVColors.textMuted, size: 60),
            const SizedBox(height: 16),
            Text(
              'No results for "$_query"',
              style: const TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Try a different term', style: TextStyle(color: BVColors.textMuted)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.52,
      ),
      itemCount: _filteredBooks.length,
      itemBuilder: (_, i) {
        final book = _filteredBooks[i];
        return BVBookCard(
          book: book,
          width: double.infinity,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailView(book: book)),
          ),
        );
      },
    );
  }

  Widget _discoverContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      physics: const BouncingScrollPhysics(),
      children: [
        // Trending Searches
        const Text('🔥 Trending', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: MockData.trendingSearches.asMap().entries.map((e) {
            final color = BVColors.categoryColors[e.key % BVColors.categoryColors.length];
            return GestureDetector(
              onTap: () => _searchCtrl.text = e.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, color: color, size: 14),
                    const SizedBox(width: 6),
                    Text(e.value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        // Categories grid
        const Text('📂 Browse Categories', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: MockData.categories.length,
          itemBuilder: (_, i) {
            final cat = MockData.categories[i];
            final color = BVColors.categoryColors[i % BVColors.categoryColors.length];
            return Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Text(cat.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat.name, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('${cat.bookCount} books', style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 28),
        const Text('✨ Recently Added', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...MockData.books.take(3).map(
          (book) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BVBookListTile(
              book: book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookDetailView(book: book)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
