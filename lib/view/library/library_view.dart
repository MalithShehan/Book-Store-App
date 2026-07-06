import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';
import '../book_detail/book_detail_view.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with TickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<BookModel> _inProgress = [MockData.books[0], MockData.books[3], MockData.books[7]];
  final List<BookModel> _downloaded = [MockData.books[1], MockData.books[3]];
  final List<BookModel> _completed = [MockData.books[2], MockData.books[4], MockData.books[6]];

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
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Library', style: TextStyle(color: BVColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('${_inProgress.length + _downloaded.length + _completed.length} books in your collection', style: const TextStyle(color: BVColors.textMuted, fontSize: 14)),
                const SizedBox(height: 16),
                // Quick stats
                Row(
                  children: [
                    _quickStat('In Progress', '${_inProgress.length}', BVColors.secondary),
                    const SizedBox(width: 10),
                    _quickStat('Downloaded', '${_downloaded.length}', BVColors.gold),
                    const SizedBox(width: 10),
                    _quickStat('Completed', '${_completed.length}', BVColors.success),
                  ],
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
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  tabs: const [
                    Tab(text: 'In Progress'),
                    Tab(text: 'Downloaded'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _bookList(_inProgress, showProgress: true),
                _bookList(_downloaded),
                _bookList(_completed, showComplete: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickStat(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _bookList(List<BookModel> books, {bool showProgress = false, bool showComplete = false}) {
    if (books.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books_outlined, color: BVColors.textMuted, size: 60),
            SizedBox(height: 16),
            Text('Nothing here yet', style: TextStyle(color: BVColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final book = books[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailView(book: book)),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BVColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BVColors.glassBorder),
            ),
            child: Row(
              children: [
                // Cover
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        book.cover,
                        width: 60,
                        height: 85,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 60, height: 85, color: BVColors.cardDark),
                      ),
                    ),
                    if (showComplete)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.black54,
                            child: const Icon(Icons.check_circle_rounded, color: BVColors.success, size: 28),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: BVColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Text(book.author, style: const TextStyle(color: BVColors.textMuted, fontSize: 12)),
                      const SizedBox(height: 8),
                      if (showProgress && book.readingProgress > 0) ...[
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
                              style: const TextStyle(color: BVColors.secondary, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, color: BVColors.textMuted, size: 13),
                          const SizedBox(width: 4),
                          Text(book.readingTime, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                          if (showComplete) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: BVColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Completed', style: TextStyle(color: BVColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: BVColors.textMuted, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
