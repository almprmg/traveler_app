class ActivityListItem {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double price;
  final double? salePrice;
  final int days;
  final int nights;
  final double rating;
  final int reviewsCount;

  ActivityListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.days,
    required this.nights,
    required this.rating,
    required this.reviewsCount,
    this.salePrice,
  });

  factory ActivityListItem.fromJson(Map<String, dynamic> json) {
    return ActivityListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      days: (json['days'] as num?)?.toInt() ?? 0,
      nights: (json['nights'] as num?)?.toInt() ?? 0,
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ActivityPlanItem {
  final String title;
  final String content;
  ActivityPlanItem({required this.title, required this.content});

  factory ActivityPlanItem.fromJson(Map<String, dynamic> json) =>
      ActivityPlanItem(
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
      );
}

class ActivityFaq {
  final String title;
  final String content;
  ActivityFaq({required this.title, required this.content});

  factory ActivityFaq.fromJson(Map<String, dynamic> json) => ActivityFaq(
    title: json['title']?.toString() ?? '',
    content: json['content']?.toString() ?? '',
  );
}

class ActivityReview {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final String createdAt;

  ActivityReview({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ActivityReview.fromJson(Map<String, dynamic> json) {
    return ActivityReview(
      id: json['id']?.toString() ?? '',
      userName:
          json['reviewer']?['name'] ??
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

class ActivityDetail {
  final String id;
  final String slug;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> gallery;
  final double price;
  final String? duration;
  final String? location;
  final String? country;
  final List<String> highlights;
  final List<String> includes;
  final List<String> excludes;
  final List<ActivityPlanItem> plan;
  final List<ActivityFaq> faqs;
  final double rating;
  final int reviewsCount;
  final List<ActivityReview> reviews;

  ActivityDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gallery,
    required this.price,
    this.duration,
    this.location,
    this.country,
    required this.highlights,
    required this.includes,
    required this.excludes,
    required this.plan,
    required this.faqs,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    return ActivityDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      gallery: (json['gallery'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      duration: json['duration']?.toString(),
      location: json['location']?.toString(),
      country: json['country']?.toString(),
      highlights: _parseStringList(json['highlights']),
      includes: _parseStringList(json['includes']),
      excludes: _parseStringList(json['excludes']),
      plan: (json['plan'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ActivityPlanItem.fromJson)
          .toList(),
      faqs: _parseFaqs(json['faqs']),
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
      reviews: (json['reviews'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ActivityReview.fromJson)
          .toList(),
    );
  }

  static List<String> _parseStringList(dynamic raw) {
    String extract(dynamic e) =>
        e is Map ? (e['title']?.toString() ?? '') : e.toString();
    if (raw is List) return raw.map(extract).toList();
    if (raw is Map) return raw.values.map(extract).toList();
    return [];
  }

  static List<ActivityFaq> _parseFaqs(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(ActivityFaq.fromJson)
          .toList();
    }
    if (raw is Map) {
      return raw.values
          .whereType<Map<String, dynamic>>()
          .map(ActivityFaq.fromJson)
          .toList();
    }
    return [];
  }
}
