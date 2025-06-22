
import 'package:flutter/foundation.dart';
import '../../utils/url_helper.dart';

class FeaturedArticlesModel {
  final int? id;
  final String? title;
  final List<int>? articleIds;
  final List<FeaturedArticleItem>? articles;

  FeaturedArticlesModel({
    this.id,
    this.title,
    this.articleIds,
    this.articles,
  });

  factory FeaturedArticlesModel.fromJson(Map<String, dynamic> json) {
    List<FeaturedArticleItem>? articlesList;
    List<int>? articleIdsList;

    if (json['articles'] != null) {
      if (json['articles'] is List) {
        final articlesData = json['articles'] as List;
        if (articlesData.isNotEmpty) {
          if (articlesData.first is Map<String, dynamic>) {
            // New structure: articles contains full article objects
            articlesList = articlesData
                .map((item) => FeaturedArticleItem.fromJson(item))
                .toList();
          } else {
            // Old structure: articles contains just IDs
            articleIdsList = List<int>.from(articlesData);
          }
        }
      }
    }

    return FeaturedArticlesModel(
      id: json['id'],
      title: json['title'],
      articleIds: articleIdsList,
      articles: articlesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'articles': articles?.map((item) => item.toJson()).toList() ?? articleIds,
    };
  }

  FeaturedArticlesModel copyWith({
    int? id,
    String? title,
    List<int>? articleIds,
    List<FeaturedArticleItem>? articles,
  }) {
    return FeaturedArticlesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      articleIds: articleIds ?? this.articleIds,
      articles: articles ?? this.articles,
    );
  }
}

class FeaturedArticleItem {
  final int? id;
  final int? featuredArticlesId;
  final FeaturedArticleData? articlesId;

  FeaturedArticleItem({
    this.id,
    this.featuredArticlesId,
    this.articlesId,
  });

  factory FeaturedArticleItem.fromJson(Map<String, dynamic> json) {
    try {
      return FeaturedArticleItem(
        id: json['id'],
        featuredArticlesId: json['featured_articles_id'],
        articlesId: json['articles_id'] != null 
            ? FeaturedArticleData.fromJson(json['articles_id'])
            : null,
      );
         } catch (e, stackTrace) {
       // Use debug mode print for development
       if (kDebugMode) {
         print('Error parsing FeaturedArticleItem: $e');
         print('JSON data: $json');
         print('Stack trace: $stackTrace');
       }
       rethrow;
     }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'featured_articles_id': featuredArticlesId,
      'articles_id': articlesId?.toJson(),
    };
  }
}

class FeaturedArticleData {
  final int? id;
  final String? title;
  final String? slug;
  final String? thumbnail;
  final String? dateCreated;
  final FeaturedCategoryData? category;

  FeaturedArticleData({
    this.id,
    this.title,
    this.slug,
    this.thumbnail,
    this.dateCreated,
    this.category,
  });

    factory FeaturedArticleData.fromJson(Map<String, dynamic> json) {
    try {
      // Handle thumbnail - it might be an object or string
      String? thumbnailValue;
      if (json['thumbnail'] != null) {
        if (json['thumbnail'] is String) {
          thumbnailValue = json['thumbnail'];
        } else if (json['thumbnail'] is Map<String, dynamic>) {
          // If thumbnail is an object, try to get the file ID or URL
          final thumbnailObj = json['thumbnail'] as Map<String, dynamic>;
          thumbnailValue = thumbnailObj['id']?.toString() ?? thumbnailObj['url']?.toString();
        }
      }

      // Convert thumbnail to full URL if needed
      thumbnailValue = UrlHelper.formatThumbnailUrl(thumbnailValue);

      return FeaturedArticleData(
        id: json['id'],
        title: json['title']?.toString(),
        slug: json['slug']?.toString(),
        thumbnail: thumbnailValue,
        dateCreated: json['date_created']?.toString(),
        category: json['category'] != null 
            ? FeaturedCategoryData.fromJson(json['category'])
            : null,
      );
    } catch (e, stackTrace) {
      // Use debug mode print for development
      if (kDebugMode) {
        print('Error parsing FeaturedArticleData: $e');
        print('JSON data: $json');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'thumbnail': thumbnail,
      'date_created': dateCreated,
      'category': category?.toJson(),
    };
  }
}

class FeaturedCategoryData {
  final int? id;
  final String? name;
  final String? slug;

  FeaturedCategoryData({
    this.id,
    this.name,
    this.slug,
  });

  factory FeaturedCategoryData.fromJson(Map<String, dynamic> json) {
    return FeaturedCategoryData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
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
    final dataList = (json['data'] as List<dynamic>)
        .map((item) => FeaturedArticlesModel.fromJson(item))
        .toList();
    
    return FeaturedArticlesListResponse(
      data: dataList,
      meta: json['meta'] != null 
          ? FeaturedArticlesMetadata.fromJson(json['meta'])
          : FeaturedArticlesMetadata(totalCount: dataList.length, filterCount: dataList.length),
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