import '../../utils/url_helper.dart';

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
  final dynamic content;
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
    // Handle category - it might be an object or int
    int? categoryIdValue;
    if (json['category'] != null) {
      if (json['category'] is int) {
        categoryIdValue = json['category'];
      } else if (json['category'] is Map<String, dynamic>) {
        final categoryObj = json['category'] as Map<String, dynamic>;
        categoryIdValue = categoryObj['id'] is int 
            ? categoryObj['id'] 
            : int.tryParse(categoryObj['id']?.toString() ?? '');
      } else {
        categoryIdValue = int.tryParse(json['category']?.toString() ?? '');
      }
    }

    // Handle files - it might be an object or string
    String? filesValue;
    if (json['files'] != null) {
      if (json['files'] is String) {
        filesValue = json['files'];
      } else if (json['files'] is Map<String, dynamic>) {
        final filesObj = json['files'] as Map<String, dynamic>;
        filesValue = filesObj['id']?.toString() ?? filesObj['url']?.toString();
      } else {
        filesValue = json['files']?.toString();
      }
    }

    return ArticleModel(
      id: json['id'],
      status: json['status']?.toString(),
      sort: json['sort'],
      userCreated: json['user_created']?.toString(),
      dateCreated: json['date_created']?.toString(),
      userUpdated: json['user_updated']?.toString(),
      dateUpdated: json['date_updated']?.toString(),
      title: json['title']?.toString() ?? '',
      thumbnail: UrlHelper.formatThumbnailUrl(json['thumbnail']?.toString()),
      content: json['content'], // Keep as dynamic - could be Map or String
      categoryId: categoryIdValue,
      slug: json['slug']?.toString(),
      summary: json['summary']?.toString(),
      files: filesValue,
      tags: json['tags']?.toString(),
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
    dynamic content,
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
    final dataList = (json['data'] as List<dynamic>)
        .map((item) => ArticleModel.fromJson(item))
        .toList();
    
    return ArticleListResponse(
      data: dataList,
      meta: json['meta'] != null 
          ? ArticleMetadata.fromJson(json['meta'])
          : ArticleMetadata(totalCount: dataList.length, filterCount: dataList.length),
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