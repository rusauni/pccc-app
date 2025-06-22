import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/issuing_agency_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';
import '../api_client/pccc_environment.dart';

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
      PcccEndpoints.issuingAgencies,
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
      PcccEndpoints.issuingAgencyById(id),
      queryParameters: queryParams,
      fromJson: (json) => IssuingAgencySingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<IssuingAgencyListResponse> _getMockIssuingAgencies() {
    final mockIssuingAgencies = [
      IssuingAgencyModel(
        id: 1,
        agencyName: 'Bộ Công an',
      ),
      IssuingAgencyModel(
        id: 2,
        agencyName: 'Bộ Xây dựng',
      ),
      IssuingAgencyModel(
        id: 3,
        agencyName: 'Chính phủ',
      ),
      IssuingAgencyModel(
        id: 4,
        agencyName: 'Quốc hội',
      ),
    ];

    final response = IssuingAgencyListResponse(
      data: mockIssuingAgencies,
      meta: IssuingAgencyMetadata(totalCount: mockIssuingAgencies.length, filterCount: mockIssuingAgencies.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<IssuingAgencySingleResponse> _getMockIssuingAgency(int id) {
    final mockIssuingAgency = IssuingAgencyModel(
      id: id,
      agencyName: 'Bộ Công an',
    );

    final response = IssuingAgencySingleResponse(data: mockIssuingAgency);
    return ApiResponse.success(response);
  }
} 