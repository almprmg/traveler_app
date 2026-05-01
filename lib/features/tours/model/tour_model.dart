class TourListItem {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewsCount;
  final String? duration;
  final String? location;
  final String? categoryName;
  final String? destination;

  TourListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    this.duration,
    this.location,
    this.categoryName,
    this.destination,
  });

  factory TourListItem.fromJson(Map<String, dynamic> json) {
    return TourListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
      duration: json['duration']?.toString(),
      location: json['location'],
      categoryName: json['category'],
      destination: json['destination'],
    );
  }
}

class TourItineraryItem {
  final String title;
  final String content;

  TourItineraryItem({required this.title, required this.content});
}

class TourFaq {
  final String title;
  final String content;

  TourFaq({required this.title, required this.content});
}

class TourDetail {
  final String id;
  final String slug;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> gallery;
  final double price;
  final double rating;
  final int reviewsCount;
  final String? duration;
  final String? location;
  final String? categoryName;
  final String? destination;
  final List<String> includes;
  final List<String> excludes;
  final List<TourItineraryItem> itinerary;
  final List<TourFaq> faqs;
  final List<TourReview> reviews;

  TourDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gallery,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    this.duration,
    this.location,
    this.categoryName,
    this.destination,
    required this.includes,
    required this.excludes,
    required this.itinerary,
    required this.faqs,
    required this.reviews,
  });

  factory TourDetail.fromJson(Map<String, dynamic> json) {
    return TourDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      gallery: (json['gallery'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
      duration: json['duration']?.toString(),
      location: json['location'],
      categoryName: json['category'],
      destination: json['destination'],
      includes: _parseStringMap(json['includes']),
      excludes: _parseStringMap(json['excludes']),
      itinerary: _parseItinerary(json['itinerary']),
      faqs: _parseFaqs(json['faqs']),
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => TourReview.fromJson(e))
          .toList(),
    );
  }

  static List<String> _parseStringMap(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is Map) {
      return raw.values
          .whereType<Map>()
          .map((e) => e['title']?.toString())
          .where((t) => t != null && t.isNotEmpty)
          .cast<String>()
          .toList();
    }
    return [];
  }

  static List<TourItineraryItem> _parseItinerary(dynamic raw) {
    if (raw is! Map) return [];
    return raw.values
        .whereType<Map>()
        .where((e) => e['title'] != null && (e['title'] as String).isNotEmpty)
        .map((e) => TourItineraryItem(
              title: e['title']?.toString() ?? '',
              content: e['content']?.toString() ?? '',
            ))
        .toList();
  }

  static List<TourFaq> _parseFaqs(dynamic raw) {
    if (raw is! Map) return [];
    return raw.values
        .whereType<Map>()
        .where((e) => e['title'] != null && (e['title'] as String).isNotEmpty)
        .map((e) => TourFaq(
              title: e['title']?.toString() ?? '',
              content: e['content']?.toString() ?? '',
            ))
        .toList();
  }
}

class TourReview {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final String createdAt;

  TourReview({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory TourReview.fromJson(Map<String, dynamic> json) {
    return TourReview(
      id: json['id']?.toString() ?? '',
      userName: json['reviewer']?['name'] ??
          json['user']?['name'] ??
          json['user_name'] ??
          '',
      userAvatar: json['avatar_url'] ?? json['user']?['avatar'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
