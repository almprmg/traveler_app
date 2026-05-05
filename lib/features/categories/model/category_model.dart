class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String? icon;

  CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icon: json['icon']?.toString(),
    );
  }
}

class CategoriesGroup {
  final String type;
  final List<CategoryItem> categories;

  CategoriesGroup({required this.type, required this.categories});

  factory CategoriesGroup.fromJson(Map<String, dynamic> json) {
    return CategoriesGroup(
      type: json['type']?.toString() ?? '',
      categories: (json['categories'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CategoryItem.fromJson)
          .toList(),
    );
  }
}
