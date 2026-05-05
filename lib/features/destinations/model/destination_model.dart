class DestinationListItem {
  final String id;
  final String slug;
  final String name;
  final String imageUrl;

  DestinationListItem({
    required this.id,
    required this.slug,
    required this.name,
    required this.imageUrl,
  });

  factory DestinationListItem.fromJson(Map<String, dynamic> json) {
    return DestinationListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }
}

class DestinationTour {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double price;
  final double rating;

  DestinationTour({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  factory DestinationTour.fromJson(Map<String, dynamic> json) {
    return DestinationTour(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}

class DestinationDetail {
  final String id;
  final String slug;
  final String name;
  final String description;
  final String imageUrl;
  final List<DestinationTour> tours;

  DestinationDetail({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tours,
  });

  factory DestinationDetail.fromJson(Map<String, dynamic> json) {
    return DestinationDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      tours: (json['tours'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(DestinationTour.fromJson)
          .toList(),
    );
  }
}
