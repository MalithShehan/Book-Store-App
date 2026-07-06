import 'package:flutter/material.dart';
import '../common/bv_colors.dart';
import '../model/book_model.dart';

/// Vertical book card for grids
class BVBookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;
  final VoidCallback? onWishlist;
  final double width;

  const BVBookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onWishlist,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    book.cover,
                    width: width,
                    height: width * 1.45,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: width,
                      height: width * 1.45,
                      decoration: BoxDecoration(
                        color: BVColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.book, color: Colors.white38, size: 40),
                    ),
                  ),
                ),
                // Badges
                if (book.isBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: BVColors.gold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                if (book.isNew)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onWishlist,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        book.isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: book.isWishlisted ? BVColors.error : Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                // Reading progress bar
                if (book.readingProgress > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      child: LinearProgressIndicator(
                        value: book.readingProgress,
                        backgroundColor: Colors.black45,
                        color: BVColors.secondary,
                        minHeight: 4,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: BVColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
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
                const Icon(Icons.star_rounded, color: BVColors.gold, size: 13),
                const SizedBox(width: 3),
                Text(
                  book.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: BVColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: BVColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal book list tile
class BVBookListTile extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const BVBookListTile({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 88,
                  color: BVColors.cardDark,
                  child: const Icon(Icons.book, color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: BVColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(color: BVColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: BVColors.gold, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: const TextStyle(color: BVColors.gold, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: BVColors.primaryGlow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.genre,
                          style: const TextStyle(color: BVColors.primaryLight, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  if (book.readingProgress > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: book.readingProgress,
                              backgroundColor: BVColors.surfaceElevated,
                              color: BVColors.secondary,
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(book.readingProgress * 100).toInt()}%',
                          style: const TextStyle(color: BVColors.secondary, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: BVColors.primaryLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (book.originalPrice != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '\$${book.originalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: BVColors.textMuted,
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
