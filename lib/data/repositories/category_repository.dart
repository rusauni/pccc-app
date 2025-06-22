import 'package:base_app/data/api_client/pccc_environment.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/category_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';

abstract class CategoryRepository {
  Future<ApiResponse<CategoryListResponse>> getCategories({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<CategorySingleResponse>> getCategory(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class CategoryRepositoryImpl implements CategoryRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  CategoryRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<CategoryListResponse>> getCategories({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockCategories();
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

    return await _apiClient.get<CategoryListResponse>(
      PcccEndpoints.categories,
      queryParameters: queryParams,
      fromJson: (json) => CategoryListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<CategorySingleResponse>> getCategory(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockCategory(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<CategorySingleResponse>(
      PcccEndpoints.categoryById(id),
      queryParameters: queryParams,
      fromJson: (json) => CategorySingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<CategoryListResponse> _getMockCategories() {
    final mockCategories = [
      CategoryModel(
        id: 1,
        name: 'Quy định pháp luật',
        slug: 'quy-dinh-phap-luat',
        order: 1,
      ),
      CategoryModel(
        id: 2,
        name: 'Hướng dẫn kỹ thuật',
        slug: 'huong-dan-ky-thuat',
        order: 2,
      ),
      CategoryModel(
        id: 3,
        name: 'Thiết bị PCCC',
        slug: 'thiet-bi-pccc',
        order: 3,
      ),
      CategoryModel(
        id: 4,
        name: 'Đào tạo - Tuyên truyền',
        slug: 'dao-tao-tuyen-truyen',
        order: 4,
      ),
    ];

    final response = CategoryListResponse(
      data: mockCategories,
      meta: CategoryMetadata(totalCount: mockCategories.length, filterCount: mockCategories.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<CategorySingleResponse> _getMockCategory(int id) {
    final mockCategory = CategoryModel(
      id: id,
      name: 'Quy định pháp luật',
      slug: 'quy-dinh-phap-luat',
      order: 1,
    );

    final response = CategorySingleResponse(data: mockCategory);
    return ApiResponse.success(response);
  }
} 