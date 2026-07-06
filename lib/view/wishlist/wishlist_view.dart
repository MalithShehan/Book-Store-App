import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_book_card.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';
import '../book_detail/book_detail_view.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<BookModel> _wishlist = [
    MockData.books[0],
    MockData.books[1],
    MockData.books[4],
    MockData.books[6],
  ];

  // Reading goal
  int _goalBooks = 12;
  int _readBooks = 8;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
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
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wishlist', style: TextStyle(color: BVColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('${_wishlist.length} books saved', style: const TextStyle(color: BVColors.textMuted, fontSize: 14)),
                const SizedBox(height: 16),
                // Reading goal card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A0A3E), Color(0xFF0A2040)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BVColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📚 2024 Reading Goal', style: TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Text('$_readBooks / $_goalBooks books', style: const TextStyle(color: BVColors.primaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _readBooks / _goalBooks,
                          backgroundColor: BVColors.primary.withValues(alpha: 0.15),
                          color: BVColors.primaryLight,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_goalBooks - _readBooks} more books to reach your goal!',
                        style: const TextStyle(color: BVColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabCtrl,
                  indicator: BoxDecoration(
                    gradient: BVColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: BVColors.textMuted,
                  dividerColor: Colors.transparent,
                  tabs: const [Tab(text: 'Saved Books'), Tab(text: 'Collections')],
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // Saved Books grid
                _wishlist.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite_outline, color: BVColors.textMuted, size: 60),
                            SizedBox(height: 16),
                            Text('No books saved yet', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(height: 8),
                            Text('Tap ♡ on any book to save it here', style: TextStyle(color: BVColors.textMuted)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.52,
                        ),
                        itemCount: _wishlist.length,
                        itemBuilder: (_, i) => BVBookCard(
                          book: _wishlist[i],
                          width: double.infinity,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BookDetailView(book: _wishlist[i])),
                          ),
                          onWishlist: () => setState(() => _wishlist.removeAt(i)),
                        ),
                      ),
                // Collections
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (_, i) {
                    final names = ['Must Read 2024', 'Beach Reads', 'Mind-Blowing Sci-Fi'];
                    final counts = [8, 5, 12];
                    final emojis = ['⭐', '🏖️', '🚀'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BVColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: BVColors.glassBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: BVColors.categoryColors[i].withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Text(emojis[i], style: const TextStyle(fontSize: 24))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(names[i], style: const TextStyle(color: BVColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                                  Text('${counts[i]} books', style: const TextStyle(color: BVColors.textMuted, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: BVColors.textMuted, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
