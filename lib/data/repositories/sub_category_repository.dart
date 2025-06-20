import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/sub_category_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';

abstract class SubCategoryRepository {
  Future<ApiResponse<SubCategoryListResponse>> getSubCategories({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<SubCategorySingleResponse>> getSubCategory(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  SubCategoryRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<SubCategoryListResponse>> getSubCategories({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockSubCategories();
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

    return await _apiClient.get<SubCategoryListResponse>(
      '/items/sub_category',
      queryParameters: queryParams,
      fromJson: (json) => SubCategoryListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<SubCategorySingleResponse>> getSubCategory(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockSubCategory(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<SubCategorySingleResponse>(
      '/items/sub_category/$id',
      queryParameters: queryParams,
      fromJson: (json) => SubCategorySingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<SubCategoryListResponse> _getMockSubCategories() {
    final mockSubCategories = [
      SubCategoryModel(
        id: 1,
        subName: 'Thông tư',
        categoryId: 1,
        slug: 'thong-tu',
      ),
      SubCategoryModel(
        id: 2,
        subName: 'Nghị định',
        categoryId: 1,
        slug: 'nghi-dinh',
      ),
      SubCategoryModel(
        id: 3,
        subName: 'Quy chuẩn kỹ thuật',
        categoryId: 2,
        slug: 'quy-chuan-ky-thuat',
      ),
    ];

    final response = SubCategoryListResponse(
      data: mockSubCategories,
      meta: SubCategoryMetadata(totalCount: mockSubCategories.length, filterCount: mockSubCategories.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<SubCategorySingleResponse> _getMockSubCategory(int id) {
    final mockSubCategory = SubCategoryModel(
      id: id,
      subName: 'Thông tư',
      categoryId: 1,
      slug: 'thong-tu',
    );

    final response = SubCategorySingleResponse(data: mockSubCategory);
    return ApiResponse.success(response);
  }
} 