import 'package:vnl_common_ui/vnl_ui.dart';
import 'article_model.dart';

class FeaturedArticlesModel {
  final int? id;
  final String? title;
  final List<int>? articleIds;

  FeaturedArticlesModel({
    this.id,
    this.title,
    this.articleIds,
  });

  factory FeaturedArticlesModel.fromJson(Map<String, dynamic> json) {
    return FeaturedArticlesModel(
      id: json['id'],
      title: json['title'],
      articleIds: json['articles'] != null 
          ? List<int>.from(json['articles']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'articles': articleIds,
    };
  }

  FeaturedArticlesModel copyWith({
    int? id,
    String? title,
    List<int>? articleIds,
  }) {
    return FeaturedArticlesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      articleIds: articleIds ?? this.articleIds,
    );
  }
}

class FeaturedArticlesArticlesModel {
  final int? id;
  final int? featuredArticlesId;
  final int? articlesId;

  FeaturedArticlesArticlesModel({
    this.id,
    this.featuredArticlesId,
    this.articlesId,
  });

  factory FeaturedArticlesArticlesModel.fromJson(Map<String, dynamic> json) {
    return FeaturedArticlesArticlesModel(
      id: json['id'],
      featuredArticlesId: json['featured_articles_id'],
      articlesId: json['articles_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'featured_articles_id': featuredArticlesId,
      'articles_id': articlesId,
    };
  }

  FeaturedArticlesArticlesModel copyWith({
    int? id,
    int? featuredArticlesId,
    int? articlesId,
  }) {
    return FeaturedArticlesArticlesModel(
      id: id ?? this.id,
      featuredArticlesId: featuredArticlesId ?? this.featuredArticlesId,
      articlesId: articlesId ?? this.articlesId,
    );
  }
}

class FeaturedArticlesListResponse {
  final List<FeaturedArticlesModel> data;
  final FeaturedArticlesMetadata meta;

  FeaturedArticlesListResponse({
    required this.data,
    required this.meta,
  });

  factory FeaturedArticlesListResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedArticlesListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => FeaturedArticlesModel.fromJson(item))
          .toList(),
      meta: FeaturedArticlesMetadata.fromJson(json['meta']),
    );
  }
}

class FeaturedArticlesSingleResponse {
  final FeaturedArticlesModel data;

  FeaturedArticlesSingleResponse({required this.data});

  factory FeaturedArticlesSingleResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedArticlesSingleResponse(
      data: FeaturedArticlesModel.fromJson(json['data']),
    );
  }
}

class FeaturedArticlesMetadata {
  final int totalCount;
  final int filterCount;

  FeaturedArticlesMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory FeaturedArticlesMetadata.fromJson(Map<String, dynamic> json) {
    return FeaturedArticlesMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 