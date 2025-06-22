import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/article_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';

abstract class ArticleRepository {
  Future<ApiResponse<ArticleListResponse>> getArticles({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<ArticleSingleResponse>> getArticle(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class ArticleRepositoryImpl implements ArticleRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  ArticleRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<ArticleListResponse>> getArticles({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockArticles();
    }

    final queryParams = _apiClient.buildListQuery(
      fields: fields,
      limit: limit,
      meta: meta,
      offset: offset,
      sort: sort,
      filter: filter,
      search: search,
    );

    return await _apiClient.get<ArticleListResponse>(
      '/items/articles',
      queryParameters: queryParams,
      fromJson: (json) => ArticleListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<ArticleSingleResponse>> getArticle(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockArticle(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<ArticleSingleResponse>(
      '/items/articles/$id',
      queryParameters: queryParams,
      fromJson: (json) => ArticleSingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<ArticleListResponse> _getMockArticles() {
    final mockArticles = [
      ArticleModel(
        id: 1,
        title: 'Quy định về an toàn phòng cháy chữa cháy',
        summary: 'Những quy định cơ bản về an toàn PCCC trong các tòa nhà',
        slug: 'quy-dinh-an-toan-pccc',
        categoryId: 1,
        content: 'Nội dung chi tiết về quy định PCCC...',
        thumbnail: 'thumbnail1.jpg',
        dateCreated: DateTime.now().toIso8601String(),
        tags: 'pccc,quy-định,an-toàn',
      ),
      ArticleModel(
        id: 2,
        title: 'Hướng dẫn sử dụng thiết bị chữa cháy',
        summary: 'Cách sử dụng các thiết bị chữa cháy cơ bản',
        slug: 'huong-dan-thiet-bi-chua-chay',
        categoryId: 2,
        content: 'Hướng dẫn chi tiết về thiết bị PCCC...',
        thumbnail: 'thumbnail2.jpg',
        dateCreated: DateTime.now().toIso8601String(),
        tags: 'thiết-bị,hướng-dẫn,pccc',
      ),
    ];

    final response = ArticleListResponse(
      data: mockArticles,
      meta: ArticleMetadata(totalCount: mockArticles.length, filterCount: mockArticles.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<ArticleSingleResponse> _getMockArticle(int id) {
    final mockArticle = ArticleModel(
      id: id,
      title: 'Quy định về an toàn phòng cháy chữa cháy',
      summary: 'Những quy định cơ bản về an toàn PCCC trong các tòa nhà',
      slug: 'quy-dinh-an-toan-pccc',
      categoryId: 1,
      content: 'Nội dung chi tiết về quy định PCCC...',
      thumbnail: 'thumbnail1.jpg',
      dateCreated: DateTime.now().toIso8601String(),
      tags: 'pccc,quy-định,an-toàn',
    );

    final response = ArticleSingleResponse(data: mockArticle);
    return ApiResponse.success(response);
  }
} 