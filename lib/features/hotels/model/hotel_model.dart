class HotelPolicy {
  final String title;
  final String content;

  HotelPolicy({required this.title, required this.content});

  factory HotelPolicy.fromJson(Map<String, dynamic> json) {
    return HotelPolicy(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class HotelListItem {
  final String id;
  final String slug;
  final String name;
  final String imageUrl;
  final double rating;
  final double pricePerNight;
  final String? location;
  final int reviewsCount;

  HotelListItem({
    required this.id,
    required this.slug,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    this.location,
    required this.reviewsCount,
  });

  factory HotelListItem.fromJson(Map<String, dynamic> json) {
    return HotelListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      pricePerNight: (json['price_per_night'] as num?)?.toDouble() ?? 0,
      location: json['location'],
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
    );
  }
}

class HotelDetail {
  final String id;
  final String slug;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> gallery;
  final double rating;
  final double pricePerNight;
  final String? location;
  final String? country;
  final String? address;
  final int reviewsCount;
  final List<HotelPolicy> policies;
  final List<HotelReview> reviews;

  HotelDetail({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.gallery,
    required this.rating,
    required this.pricePerNight,
    this.location,
    this.country,
    this.address,
    required this.reviewsCount,
    required this.policies,
    required this.reviews,
  });

  factory HotelDetail.fromJson(Map<String, dynamic> json) {
    final policiesRaw = json['policies'];
    final List<HotelPolicy> parsedPolicies = [];
    if (policiesRaw is Map) {
      policiesRaw.forEach((_, v) {
        if (v is Map<String, dynamic>) {
          parsedPolicies.add(HotelPolicy.fromJson(v));
        }
      });
    }

    return HotelDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      gallery:
          (json['gallery'] as List? ?? []).map((e) => e.toString()).toList(),
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      pricePerNight: (json['price_per_night'] as num?)?.toDouble() ?? 0,
      location: json['location'],
      country: json['country'],
      address: json['address'],
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
      policies: parsedPolicies,
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => HotelReview.fromJson(e))
          .toList(),
    );
  }
}

class HotelReview {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;

  HotelReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory HotelReview.fromJson(Map<String, dynamic> json) {
    return HotelReview(
      id: json['id']?.toString() ?? '',
      userName: json['user']?['name'] ?? json['user_name'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
