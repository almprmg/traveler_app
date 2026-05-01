import 'package:traveler_app/models/name.dart';

/// Product category model.
class CategoryModel {
  final String id;
  final NameModel name;
  final String? image;
  final String? icon;
  final ParentCategory? parent;
  final CategoryType? type;
  final NameModel? code;
  final bool ignorePriceListPolicy;

  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.parent,
    this.icon,
    this.type,
    this.code,
    required this.ignorePriceListPolicy,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String? ?? '',
      name: NameModel.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
      image: json['image'] as String?,
      parent: json['parent'] != null
          ? ParentCategory.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      type: json['type'] != null
          ? CategoryType.fromJson(json['type'] as Map<String, dynamic>)
          : null,
      code: json['code'] != null
          ? NameModel.fromJson(json['code'] as Map<String, dynamic>)
          : null,
      ignorePriceListPolicy: json['ignorePriceListPolicy'] as bool? ?? false,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name.toJson(),
      'parent': parent?.toJson(),
      'type': type?.toJson(),
      'code': code?.toJson(),
      'ignorePriceListPolicy': ignorePriceListPolicy,
      'image': image,
      'icon': icon,
    };
  }
}

/// Parent category reference.
class ParentCategory {
  final String? id;
  final NameModel? name;
  final NameModel? code;

  const ParentCategory({this.id, this.name, this.code});

  factory ParentCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ParentCategory();

    return ParentCategory(
      id: json['_id'] as String?,
      name: json['name'] != null
          ? NameModel.fromJson(json['name'] as Map<String, dynamic>)
          : null,
      code: json['code'] != null
          ? NameModel.fromJson(json['code'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name?.toJson(), 'code': code?.toJson()};
  }

  ParentCategory copyWith({String? id, NameModel? name, NameModel? code}) {
    return ParentCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }
}

/// Category type model.
class CategoryType {
  final String id;
  final NameModel name;
  final String code;

  const CategoryType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      id: json['_id'] as String? ?? '',
      name: NameModel.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
      code: json['code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name.toJson(), 'code': code};
  }
}
