class HomeModel {
  final List<HomeBanner> banners;
  final List<Destination> destinations;
  final List<Tour> tours;
  final List<Hotel> hotels;

  HomeModel({
    required this.banners,
    required this.destinations,
    required this.tours,
    required this.hotels,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      banners: (json['banners'] as List? ?? [])
          .map((e) => HomeBanner.fromJson(e))
          .toList(),
      destinations: (json['destinations'] as List? ?? [])
          .map((e) => Destination.fromJson(e))
          .toList(),
      tours: (json['tours'] as List? ?? [])
          .map((e) => Tour.fromJson(e))
          .toList(),
      hotels: (json['hotels'] as List? ?? [])
          .map((e) => Hotel.fromJson(e))
          .toList(),
    );
  }
}

class HomeBanner {
  final String id;
  final String imageUrl;
  final String title;
  final String link;

  HomeBanner({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.link,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

class Destination {
  final String id;
  final String slug;
  final String name;
  final String imageUrl;

  Destination({
    required this.id,
    required this.slug,
    required this.name,
    required this.imageUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class Tour {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double price;
  final double rating;

  Tour({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}

class Hotel {
  final String id;
  final String slug;
  final String name;
  final String imageUrl;
  final double rating;
  final double pricePerNight;
  final String location;

  Hotel({
    required this.id,
    required this.slug,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.location,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      pricePerNight: (json['price_per_night'] as num?)?.toDouble() ?? 0,
      location: json['location'] ?? '',
    );
  }
}
