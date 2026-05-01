import 'package:traveler_app/models/product.dart';

class CategoryUtils {
  /// Filters a list of categories to return only unique main categories.
  /// If a sub-category is encountered, its parent is added effectively mapping
  /// sub-categories to their main parent category.
  static List<CategoryModel> filterMainCategories(
    List<CategoryModel> categories,
  ) {
    final Map<String, CategoryModel> uniqueCategories = {};

    for (var category in categories) {
      if (category.parent == null) {
        // It is a main category
        uniqueCategories[category.id] = category;
      } else {
        // It is a sub category, we show its parent
        if (!uniqueCategories.containsKey(category.parent!.id)) {
          uniqueCategories[category.parent?.id ?? ''] = CategoryModel(
            id: category.parent!.id ?? '',
            name: category.parent!.name!,
            ignorePriceListPolicy: false,
          );
        }
      }
    }

    return uniqueCategories.values.toList();
  }

  /// Filters a list of categories to return only sub categories.
  /// A sub-category is any category that has a parent category.
  static List<CategoryModel> getSubCategories(List<CategoryModel> categories) {
    return categories.where((category) => category.parent != null).toList();
  }

  /// Returns the first sub category of a given main category.
  /// Returns null if the main category has no sub categories.
  static CategoryModel? getFirstSubCategory(
    List<CategoryModel> categories,
    CategoryModel mainCategory,
  ) {
    final subCategories = categories
        .where(
          (category) =>
              category.parent != null && category.parent!.id == mainCategory.id,
        )
        .toList();
    return subCategories.isNotEmpty ? subCategories.first : null;
  }
}
