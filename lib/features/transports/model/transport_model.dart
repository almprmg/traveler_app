class TransportListItem {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double carPrice;
  final String? location;
  final double rating;

  TransportListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.carPrice,
    required this.rating,
    this.location,
  });

  factory TransportListItem.fromJson(Map<String, dynamic> json) {
    return TransportListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      carPrice: (json['car_price'] as num?)?.toDouble() ?? 0,
      location: json['location']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TransportPrice {
  final double price;
  final double? salePrice;
  final double? childPrice;
  TransportPrice({required this.price, this.salePrice, this.childPrice});
  factory TransportPrice.fromJson(Map<String, dynamic> json) => TransportPrice(
        price: (json['price'] as num?)?.toDouble() ?? 0,
        salePrice: (json['sale_price'] as num?)?.toDouble(),
        childPrice: (json['child_price'] as num?)?.toDouble(),
      );
}

class TransportFaq {
  final String title;
  final String content;
  TransportFaq({required this.title, required this.content});
  factory TransportFaq.fromJson(Map<String, dynamic> json) => TransportFaq(
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
      );
}

class TransportReview {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;
  TransportReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  factory TransportReview.fromJson(Map<String, dynamic> json) =>
      TransportReview(
        id: json['id']?.toString() ?? '',
        userName: json['reviewer']?['name'] ??
            json['user']?['name'] ??
            json['user_name'] ??
            '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        comment: json['comment'] ?? '',
        createdAt: json['created_at'] ?? '',
      );
}

class TransportDetail {
  final String id;
  final String slug;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> gallery;
  final String? location;
  final String? country;
  final String? address;
  final String? carType;
  final String? distanceKm;
  final String? minStay;
  final Map<String, TransportPrice> pricing;
  final List<TransportFaq> faqs;
  final double rating;
  final int reviewsCount;
  final List<TransportReview> reviews;

  TransportDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gallery,
    this.location,
    this.country,
    this.address,
    this.carType,
    this.distanceKm,
    this.minStay,
    required this.pricing,
    required this.faqs,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });

  factory TransportDetail.fromJson(Map<String, dynamic> json) {
    final rawPricing = json['pricing'];
    final pricing = <String, TransportPrice>{};
    if (rawPricing is Map) {
      rawPricing.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          pricing[k.toString()] = TransportPrice.fromJson(v);
        }
      });
    }
    return TransportDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      gallery:
          (json['gallery'] as List? ?? []).map((e) => e.toString()).toList(),
      location: json['location']?.toString(),
      country: json['country']?.toString(),
      address: json['address']?.toString(),
      carType: json['car_type']?.toString(),
      distanceKm: json['distance_km']?.toString(),
      minStay: json['min_stay']?.toString(),
      pricing: pricing,
      faqs: (json['faqs'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TransportFaq.fromJson)
          .toList(),
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['total_reviews'] as num?)?.toInt() ?? 0,
      reviews: (json['reviews'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TransportReview.fromJson)
          .toList(),
    );
  }
}
