import 'package:vnl_common_ui/vnl_ui.dart';

class ArticleModel {
  final int? id;
  final String? status;
  final int? sort;
  final String? userCreated;
  final String? dateCreated;
  final String? userUpdated;
  final String? dateUpdated;
  final String title;
  final String? thumbnail;
  final String? content;
  final int? categoryId;
  final String? slug;
  final String? summary;
  final String? files;
  final String? tags;

  ArticleModel({
    this.id,
    this.status,
    this.sort,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    required this.title,
    this.thumbnail,
    this.content,
    this.categoryId,
    this.slug,
    this.summary,
    this.files,
    this.tags,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      status: json['status'],
      sort: json['sort'],
      userCreated: json['user_created'],
      dateCreated: json['date_created'],
      userUpdated: json['user_updated'],
      dateUpdated: json['date_updated'],
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'],
      content: json['content'],
      categoryId: json['category'],
      slug: json['slug'],
      summary: json['summary'],
      files: json['files'],
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'sort': sort,
      'user_created': userCreated,
      'date_created': dateCreated,
      'user_updated': userUpdated,
      'date_updated': dateUpdated,
      'title': title,
      'thumbnail': thumbnail,
      'content': content,
      'category': categoryId,
      'slug': slug,
      'summary': summary,
      'files': files,
      'tags': tags,
    };
  }

  ArticleModel copyWith({
    int? id,
    String? status,
    int? sort,
    String? userCreated,
    String? dateCreated,
    String? userUpdated,
    String? dateUpdated,
    String? title,
    String? thumbnail,
    String? content,
    int? categoryId,
    String? slug,
    String? summary,
    String? files,
    String? tags,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      status: status ?? this.status,
      sort: sort ?? this.sort,
      userCreated: userCreated ?? this.userCreated,
      dateCreated: dateCreated ?? this.dateCreated,
      userUpdated: userUpdated ?? this.userUpdated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      files: files ?? this.files,
      tags: tags ?? this.tags,
    );
  }
}

class ArticleListResponse {
  final List<ArticleModel> data;
  final ArticleMetadata meta;

  ArticleListResponse({
    required this.data,
    required this.meta,
  });

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) {
    return ArticleListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ArticleModel.fromJson(item))
          .toList(),
      meta: ArticleMetadata.fromJson(json['meta']),
    );
  }
}

class ArticleSingleResponse {
  final ArticleModel data;

  ArticleSingleResponse({required this.data});

  factory ArticleSingleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleSingleResponse(
      data: ArticleModel.fromJson(json['data']),
    );
  }
}

class ArticleMetadata {
  final int totalCount;
  final int filterCount;

  ArticleMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory ArticleMetadata.fromJson(Map<String, dynamic> json) {
    return ArticleMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 