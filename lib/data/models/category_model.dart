import 'package:vnl_common_ui/vnl_ui.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String? slug;
  final int? parentId;
  final int? order;

  CategoryModel({
    this.id,
    required this.name,
    this.slug,
    this.parentId,
    this.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
      parentId: json['parent_id'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent_id': parentId,
      'order': order,
    };
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    int? parentId,
    int? order,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
    );
  }
}

class CategoryListResponse {
  final List<CategoryModel> data;
  final CategoryMetadata meta;

  CategoryListResponse({
    required this.data,
    required this.meta,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item))
          .toList(),
      meta: CategoryMetadata.fromJson(json['meta']),
    );
  }
}

class CategorySingleResponse {
  final CategoryModel data;

  CategorySingleResponse({required this.data});

  factory CategorySingleResponse.fromJson(Map<String, dynamic> json) {
    return CategorySingleResponse(
      data: CategoryModel.fromJson(json['data']),
    );
  }
}

class CategoryMetadata {
  final int totalCount;
  final int filterCount;

  CategoryMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory CategoryMetadata.fromJson(Map<String, dynamic> json) {
    return CategoryMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 