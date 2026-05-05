class VisaListItem {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final double cost;
  final String country;
  final String? category;
  final String? validity;
  final String? processing;

  VisaListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    required this.cost,
    required this.country,
    this.category,
    this.validity,
    this.processing,
  });

  factory VisaListItem.fromJson(Map<String, dynamic> json) {
    return VisaListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
      country: json['country']?.toString() ?? '',
      category: json['category']?.toString(),
      validity: json['validity']?.toString(),
      processing: json['processing']?.toString(),
    );
  }
}

class VisaFaq {
  final String title;
  final String content;
  VisaFaq({required this.title, required this.content});
  factory VisaFaq.fromJson(Map<String, dynamic> json) => VisaFaq(
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
      );
}

class VisaDetail {
  final String id;
  final String slug;
  final String title;
  final String imageUrl;
  final String? bannerUrl;
  final double cost;
  final String country;
  final String? category;
  final String? validity;
  final String? processing;
  final String? maximumStay;
  final String? visaMode;
  final List<String> includes;
  final List<VisaFaq> faqs;

  VisaDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    this.bannerUrl,
    required this.cost,
    required this.country,
    this.category,
    this.validity,
    this.processing,
    this.maximumStay,
    this.visaMode,
    required this.includes,
    required this.faqs,
  });

  factory VisaDetail.fromJson(Map<String, dynamic> json) {
    return VisaDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      bannerUrl: json['banner_url']?.toString(),
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
      country: json['country']?.toString() ?? '',
      category: json['category']?.toString(),
      validity: json['validity']?.toString(),
      processing: json['processing']?.toString(),
      maximumStay: json['maximum_stay']?.toString(),
      visaMode: json['visa_mode']?.toString(),
      includes: (json['includes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      faqs: (json['faqs'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(VisaFaq.fromJson)
          .toList(),
    );
  }
}
