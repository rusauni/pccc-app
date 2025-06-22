class VideoModel {
  final int? id;
  final String title;
  final String? link;
  final String? thumbnail;
  final String? description;
  final int? category;
  final String? tags;

  VideoModel({
    this.id,
    required this.title,
    this.link,
    this.thumbnail,
    this.description,
    this.category,
    this.tags,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'] ?? '',
      link: json['link'],
      thumbnail: json['thumbnail'] is String ? json['thumbnail'] : null,
      description: json['description'],
      category: json['category'],
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'thumbnail': thumbnail,
      'description': description,
      'category': category,
      'tags': tags,
    };
  }
}

class VideoListResponse {
  final List<VideoModel> data;
  final VideoMetadata? meta;

  VideoListResponse({
    required this.data,
    this.meta,
  });

  factory VideoListResponse.fromJson(Map<String, dynamic> json) {
    return VideoListResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null
          ? VideoMetadata.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class VideoSingleResponse {
  final VideoModel data;

  VideoSingleResponse({required this.data});

  factory VideoSingleResponse.fromJson(Map<String, dynamic> json) {
    return VideoSingleResponse(
      data: VideoModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class VideoMetadata {
  final int totalCount;
  final int filterCount;

  VideoMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) {
    return VideoMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'filter_count': filterCount,
    };
  }
} 