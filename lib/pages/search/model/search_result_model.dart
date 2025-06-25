class SearchResult {
  final List<SearchArticleItem> articles;
  final List<SearchDocumentItem> documents;
  final String query;
  final int totalResults;

  SearchResult({
    required this.articles,
    required this.documents,
    required this.query,
    required this.totalResults,
  });

  factory SearchResult.empty() {
    return SearchResult(
      articles: [],
      documents: [],
      query: '',
      totalResults: 0,
    );
  }
}

class SearchArticleItem {
  final int id;
  final String title;
  final String? summary;
  final String? imageUrl;
  final String? dateCreated;
  final String? categoryName;

  SearchArticleItem({
    required this.id,
    required this.title,
    this.summary,
    this.imageUrl,
    this.dateCreated,
    this.categoryName,
  });

  factory SearchArticleItem.fromJson(Map<String, dynamic> json) {
    return SearchArticleItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'],
      imageUrl: json['image_url'],
      dateCreated: json['date_created'],
      categoryName: json['category_name'],
    );
  }
}

class SearchDocumentItem {
  final int id;
  final String title;
  final String? description;
  final String? fileUrl;
  final String? fileType;
  final String? dateCreated;
  final String? categoryName;

  SearchDocumentItem({
    required this.id,
    required this.title,
    this.description,
    this.fileUrl,
    this.fileType,
    this.dateCreated,
    this.categoryName,
  });

  factory SearchDocumentItem.fromJson(Map<String, dynamic> json) {
    return SearchDocumentItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
      dateCreated: json['date_created'],
      categoryName: json['category_name'],
    );
  }
} 