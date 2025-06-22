import 'package:gtd_network/gtd_network.dart';
import '../models/featured_articles_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';
import '../api_client/pccc_environment.dart';

abstract class FeaturedArticlesRepository {
  Future<ApiResponse<FeaturedArticlesListResponse>> getFeaturedArticles({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<FeaturedArticlesSingleResponse>> getFeaturedArticle(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class FeaturedArticlesRepositoryImpl implements FeaturedArticlesRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  FeaturedArticlesRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<FeaturedArticlesListResponse>> getFeaturedArticles({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockFeaturedArticles();
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

    return await _apiClient.get<FeaturedArticlesListResponse>(
      PcccEndpoints.featuredArticles,
      queryParameters: queryParams,
      fromJson: (json) => FeaturedArticlesListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<FeaturedArticlesSingleResponse>> getFeaturedArticle(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockFeaturedArticle(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<FeaturedArticlesSingleResponse>(
      PcccEndpoints.featuredArticleById(id),
      queryParameters: queryParams,
      fromJson: (json) => FeaturedArticlesSingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<FeaturedArticlesListResponse> _getMockFeaturedArticles() {
    final mockFeaturedArticles = [
      FeaturedArticlesModel(
        id: 1,
        title: 'Breaking News Today',
        articleIds: [1, 2, 3],
      ),
    ];

    final response = FeaturedArticlesListResponse(
      data: mockFeaturedArticles,
      meta: FeaturedArticlesMetadata(
        totalCount: mockFeaturedArticles.length,
        filterCount: mockFeaturedArticles.length,
      ),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<FeaturedArticlesSingleResponse> _getMockFeaturedArticle(int id) {
    final mockFeaturedArticle = FeaturedArticlesModel(
      id: id,
      title: 'Breaking News Today',
      articleIds: [1, 2, 3],
    );

    final response = FeaturedArticlesSingleResponse(data: mockFeaturedArticle);
    return ApiResponse.success(response);
  }
} 