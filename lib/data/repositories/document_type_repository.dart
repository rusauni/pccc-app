import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/document_type_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';
import '../api_client/pccc_environment.dart';

abstract class DocumentTypeRepository {
  Future<ApiResponse<DocumentTypeListResponse>> getDocumentTypes({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<DocumentTypeSingleResponse>> getDocumentType(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class DocumentTypeRepositoryImpl implements DocumentTypeRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  DocumentTypeRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<DocumentTypeListResponse>> getDocumentTypes({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockDocumentTypes();
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

    return await _apiClient.get<DocumentTypeListResponse>(
      PcccEndpoints.documentTypes,
      queryParameters: queryParams,
      fromJson: (json) => DocumentTypeListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<DocumentTypeSingleResponse>> getDocumentType(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockDocumentType(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<DocumentTypeSingleResponse>(
      PcccEndpoints.documentTypeById(id),
      queryParameters: queryParams,
      fromJson: (json) => DocumentTypeSingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<DocumentTypeListResponse> _getMockDocumentTypes() {
    final mockDocumentTypes = [
      DocumentTypeModel(
        id: 1,
        documentTypeName: 'Luật',
      ),
      DocumentTypeModel(
        id: 2,
        documentTypeName: 'Thông tư',
      ),
      DocumentTypeModel(
        id: 3,
        documentTypeName: 'Quyết định',
      ),
      DocumentTypeModel(
        id: 4,
        documentTypeName: 'Nghị định',
      ),
    ];

    final response = DocumentTypeListResponse(
      data: mockDocumentTypes,
      meta: DocumentTypeMetadata(totalCount: mockDocumentTypes.length, filterCount: mockDocumentTypes.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<DocumentTypeSingleResponse> _getMockDocumentType(int id) {
    final mockDocumentType = DocumentTypeModel(
      id: id,
      documentTypeName: 'Luật',
    );

    final response = DocumentTypeSingleResponse(data: mockDocumentType);
    return ApiResponse.success(response);
  }
} 