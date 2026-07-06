import 'dart:ui';
import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';
import 'audiobook_player_view.dart';

class AudioView extends StatefulWidget {
  const AudioView({super.key});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  final List<BookModel> _audiobooks = MockData.books.where((b) => b.hasAudio).toList();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final currentlyPlaying = _audiobooks.isNotEmpty ? _audiobooks[0] : null;

    return Scaffold(
      backgroundColor: BVColors.background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BVColors.secondary.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BVColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Audiobooks',
                          style: TextStyle(
                            color: BVColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Listen to immersive narrations and stories',
                          style: TextStyle(
                            color: BVColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue Listening Glassmorphic Card
                if (currentlyPlaying != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AudiobookPlayerView(book: currentlyPlaying),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: BVColors.surface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: BVColors.glassBorder),
                              ),
                              child: Row(
                                children: [
                                  // Album/Book Cover
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      currentlyPlaying.cover,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 80,
                                        height: 80,
                                        color: BVColors.surfaceElevated,
                                        child: const Icon(Icons.music_note, color: Colors.white54),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Player Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CONTINUE LISTENING',
                                          style: TextStyle(
                                            color: BVColors.secondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          currentlyPlaying.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: BVColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'by ${currentlyPlaying.author}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: BVColors.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Progress Bar
                                        Row(
                                          children: [
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value: 0.42,
                                                backgroundColor: BVColors.surfaceElevated,
                                                valueColor: const AlwaysStoppedAnimation(BVColors.primary),
                                                borderRadius: BorderRadius.circular(4),
                                                minHeight: 4,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '42%',
                                              style: TextStyle(color: BVColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Play Button
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      gradient: BVColors.primaryGradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Section Title: Trending
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
                    child: Text(
                      'Trending Audiobooks',
                      style: TextStyle(
                        color: BVColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                // Audiobooks Grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = _audiobooks[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AudiobookPlayerView(book: book),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: BVColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: BVColors.glassBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Cover Photo
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: Image.asset(
                                            book.cover,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: BVColors.surfaceElevated,
                                              child: const Icon(Icons.music_note, color: Colors.white38, size: 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.headset_rounded, color: BVColors.secondary, size: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Text details
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: BVColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        book.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: BVColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: BVColors.gold, size: 14),
                                          const SizedBox(width: 2),
                                          Text(
                                            book.rating.toString(),
                                            style: const TextStyle(color: BVColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            book.readingTime ?? '4h 10m',
                                            style: const TextStyle(color: BVColors.textMuted, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _audiobooks.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
