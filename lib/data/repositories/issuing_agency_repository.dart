import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/issuing_agency_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';

abstract class IssuingAgencyRepository {
  Future<ApiResponse<IssuingAgencyListResponse>> getIssuingAgencies({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<IssuingAgencySingleResponse>> getIssuingAgency(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class IssuingAgencyRepositoryImpl implements IssuingAgencyRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  IssuingAgencyRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<IssuingAgencyListResponse>> getIssuingAgencies({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockIssuingAgencies();
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

    return await _apiClient.get<IssuingAgencyListResponse>(
      '/items/issuing_agency',
      queryParameters: queryParams,
      fromJson: (json) => IssuingAgencyListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<IssuingAgencySingleResponse>> getIssuingAgency(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockIssuingAgency(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<IssuingAgencySingleResponse>(
      '/items/issuing_agency/$id',
      queryParameters: queryParams,
      fromJson: (json) => IssuingAgencySingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<IssuingAgencyListResponse> _getMockIssuingAgencies() {
    final mockAgencies = [
      IssuingAgencyModel(id: 1, agencyName: 'Bộ Công an'),
      IssuingAgencyModel(id: 2, agencyName: 'Chính phủ'),
      IssuingAgencyModel(id: 3, agencyName: 'Bộ Xây dựng'),
      IssuingAgencyModel(id: 4, agencyName: 'Bộ Khoa học và Công nghệ'),
      IssuingAgencyModel(id: 5, agencyName: 'UBND Thành phố Hồ Chí Minh'),
    ];

    final response = IssuingAgencyListResponse(
      data: mockAgencies,
      meta: IssuingAgencyMetadata(totalCount: mockAgencies.length, filterCount: mockAgencies.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<IssuingAgencySingleResponse> _getMockIssuingAgency(int id) {
    final mockAgency = IssuingAgencyModel(
      id: id,
      agencyName: 'Bộ Công an',
    );

    final response = IssuingAgencySingleResponse(data: mockAgency);
    return ApiResponse.success(response);
  }
} 