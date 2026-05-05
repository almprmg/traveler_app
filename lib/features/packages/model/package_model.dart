class PackageListItem {
  final String id;
  final String slug;
  final String title;
  final String? shortDesc;
  final String imageUrl;
  final double price;
  final double? salePrice;
  final String? duration;
  final int days;
  final int nights;
  final bool isFeatured;
  final double rating;
  final int reviewsCount;

  PackageListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.days,
    required this.nights,
    required this.rating,
    required this.reviewsCount,
    required this.isFeatured,
    this.salePrice,
    this.duration,
    this.shortDesc,
  });

  factory PackageListItem.fromJson(Map<String, dynamic> json) {
    return PackageListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      shortDesc: json['short_desc']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      duration: json['duration']?.toString(),
      days: (json['days'] as num?)?.toInt() ?? 0,
      nights: (json['nights'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class PackageItineraryItem {
  final String title;
  final String content;
  PackageItineraryItem({required this.title, required this.content});
  factory PackageItineraryItem.fromJson(Map<String, dynamic> json) =>
      PackageItineraryItem(
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
      );
}

class PackageFaq {
  final String title;
  final String content;
  PackageFaq({required this.title, required this.content});
  factory PackageFaq.fromJson(Map<String, dynamic> json) => PackageFaq(
    title: json['title']?.toString() ?? '',
    content: json['content']?.toString() ?? '',
  );
}

class PackageReview {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;
  PackageReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  factory PackageReview.fromJson(Map<String, dynamic> json) => PackageReview(
    id: json['id']?.toString() ?? '',
    userName:
        json['reviewer']?['name'] ??
        json['user']?['name'] ??
        json['user_name'] ??
        '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    comment: json['comment'] ?? '',
    createdAt: json['created_at'] ?? '',
  );
}

class PackageDetail {
  final String id;
  final String slug;
  final String title;
  final String? shortDesc;
  final String content;
  final String imageUrl;
  final List<String> gallery;
  final double price;
  final double? salePrice;
  final String? duration;
  final int days;
  final int nights;
  final bool isFeatured;
  final List<String> includes;
  final List<String> excludes;
  final List<String> highlights;
  final List<String> destinations;
  final List<PackageItineraryItem> itinerary;
  final List<PackageFaq> faqs;
  final double rating;
  final int reviewsCount;
  final List<PackageReview> reviews;

  PackageDetail({
    required this.id,
    required this.slug,
    required this.title,
    this.shortDesc,
    required this.content,
    required this.imageUrl,
    required this.gallery,
    required this.price,
    this.salePrice,
    this.duration,
    required this.days,
    required this.nights,
    required this.isFeatured,
    required this.includes,
    required this.excludes,
    required this.highlights,
    required this.destinations,
    required this.itinerary,
    required this.faqs,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      shortDesc: json['short_desc']?.toString(),
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      gallery: (json['gallery'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      duration: json['duration']?.toString(),
      days: (json['days'] as num?)?.toInt() ?? 0,
      nights: (json['nights'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      includes: (json['includes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      excludes: (json['excludes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      highlights: (json['highlights'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      destinations: (json['destinations'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      itinerary: (json['itinerary'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(PackageItineraryItem.fromJson)
          .toList(),
      faqs: (json['faqs'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(PackageFaq.fromJson)
          .toList(),
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['review_count'] as num?)?.toInt() ?? 0,
      reviews: (json['reviews'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(PackageReview.fromJson)
          .toList(),
    );
  }
}
