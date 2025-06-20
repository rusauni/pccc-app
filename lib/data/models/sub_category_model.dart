import 'package:vnl_common_ui/vnl_ui.dart';

class SubCategoryModel {
  final int? id;
  final String? subName;
  final int? categoryId;
  final String? slug;

  SubCategoryModel({
    this.id,
    this.subName,
    this.categoryId,
    this.slug,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      subName: json['sub_name'],
      categoryId: json['category_id'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_name': subName,
      'category_id': categoryId,
      'slug': slug,
    };
  }

  SubCategoryModel copyWith({
    int? id,
    String? subName,
    int? categoryId,
    String? slug,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      subName: subName ?? this.subName,
      categoryId: categoryId ?? this.categoryId,
      slug: slug ?? this.slug,
    );
  }
}

class SubCategoryListResponse {
  final List<SubCategoryModel> data;
  final SubCategoryMetadata meta;

  SubCategoryListResponse({
    required this.data,
    required this.meta,
  });

  factory SubCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => SubCategoryModel.fromJson(item))
          .toList(),
      meta: SubCategoryMetadata.fromJson(json['meta']),
    );
  }
}

class SubCategorySingleResponse {
  final SubCategoryModel data;

  SubCategorySingleResponse({required this.data});

  factory SubCategorySingleResponse.fromJson(Map<String, dynamic> json) {
    return SubCategorySingleResponse(
      data: SubCategoryModel.fromJson(json['data']),
    );
  }
}

class SubCategoryMetadata {
  final int totalCount;
  final int filterCount;

  SubCategoryMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory SubCategoryMetadata.fromJson(Map<String, dynamic> json) {
    return SubCategoryMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 