class BookModel {
  final String id;
  final String title;
  final String author;
  final String authorId;
  final String cover;
  final String genre;
  final double rating;
  final int reviewCount;
  final double price;
  final double? originalPrice;
  final String description;
  final int pages;
  final String language;
  final String publisher;
  final String publishedDate;
  final bool isBestseller;
  final bool isNew;
  final bool hasFreePreview;
  final bool hasAudio;
  final double readingProgress; // 0.0 - 1.0
  final bool isWishlisted;
  final bool isPurchased;
  final String readingTime; // e.g. "6h 30m"

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.authorId,
    required this.cover,
    required this.genre,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.pages,
    this.language = 'English',
    required this.publisher,
    required this.publishedDate,
    this.isBestseller = false,
    this.isNew = false,
    this.hasFreePreview = true,
    this.hasAudio = false,
    this.readingProgress = 0.0,
    this.isWishlisted = false,
    this.isPurchased = false,
    this.readingTime = '4h 00m',
  });

  BookModel copyWith({
    bool? isWishlisted,
    double? readingProgress,
    bool? isPurchased,
  }) {
    return BookModel(
      id: id,
      title: title,
      author: author,
      authorId: authorId,
      cover: cover,
      genre: genre,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      originalPrice: originalPrice,
      description: description,
      pages: pages,
      language: language,
      publisher: publisher,
      publishedDate: publishedDate,
      isBestseller: isBestseller,
      isNew: isNew,
      hasFreePreview: hasFreePreview,
      hasAudio: hasAudio,
      readingProgress: readingProgress ?? this.readingProgress,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      isPurchased: isPurchased ?? this.isPurchased,
      readingTime: readingTime,
    );
  }
}

class AuthorModel {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final int booksCount;
  final double rating;
  final int followers;
  final String genre;

  const AuthorModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.booksCount,
    required this.rating,
    required this.followers,
    required this.genre,
  });
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int bookCount;
  final String cover;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.bookCount,
    required this.cover,
  });
}

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String avatar;
  final double rating;
  final String comment;
  final String date;
  final int likes;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.likes,
  });
}

class CartItemModel {
  final BookModel book;
  int quantity;

  CartItemModel({required this.book, this.quantity = 1});
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String icon;
  final String type; // 'new_book', 'price_drop', 'author', 'reminder'
  final String time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}
