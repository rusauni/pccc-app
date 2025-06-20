import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/document_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';

abstract class DocumentRepository {
  Future<ApiResponse<DocumentListResponse>> getDocuments({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<DocumentSingleResponse>> getDocument(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class DocumentRepositoryImpl implements DocumentRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  DocumentRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<DocumentListResponse>> getDocuments({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockDocuments();
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

    return await _apiClient.get<DocumentListResponse>(
      '/items/documents',
      queryParameters: queryParams,
      fromJson: (json) => DocumentListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<DocumentSingleResponse>> getDocument(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockDocument(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<DocumentSingleResponse>(
      '/items/documents/$id',
      queryParameters: queryParams,
      fromJson: (json) => DocumentSingleResponse.fromJson(json),
    );
  }

  // Mock data methods for design/testing purposes
  ApiResponse<DocumentListResponse> _getMockDocuments() {
    final mockDocuments = [
      DocumentModel(
        id: 1,
        title: 'Thông tư 01/2024/TT-BCA về quy định PCCC',
        description: 'Quy định về điều kiện an toàn PCCC đối với nhà cao tầng',
        documentNumber: '01/2024/TT-BCA',
        effectiveDate: '2024-03-01',
        categoryId: 1,
        subCategoryId: 1,
        agencyId: 1,
        documentTypeId: 1,
        file: 'document_1.pdf',
        tags: 'PCCC, thông tư, nhà cao tầng',
      ),
      DocumentModel(
        id: 2,
        title: 'Nghị định 136/2020/NĐ-CP về quản lý PCCC',
        description: 'Quy định chi tiết thi hành một số điều của Luật PCCC',
        documentNumber: '136/2020/NĐ-CP',
        effectiveDate: '2021-01-01',
        categoryId: 1,
        subCategoryId: 2,
        agencyId: 2,
        documentTypeId: 2,
        file: 'document_2.pdf',
        tags: 'PCCC, nghị định, quản lý',
      ),
      DocumentModel(
        id: 3,
        title: 'QCVN 06:2010/BXD - Quy chuẩn kỹ thuật quốc gia về an toàn cháy',
        description: 'Quy chuẩn kỹ thuật quốc gia về an toàn cháy cho nhà và công trình',
        documentNumber: 'QCVN 06:2010/BXD',
        effectiveDate: '2010-07-01',
        categoryId: 2,
        subCategoryId: 3,
        agencyId: 3,
        documentTypeId: 3,
        file: 'document_3.pdf',
        tags: 'QCVN, kỹ thuật, an toàn cháy',
      ),
    ];

    final response = DocumentListResponse(
      data: mockDocuments,
      meta: DocumentMetadata(totalCount: mockDocuments.length, filterCount: mockDocuments.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<DocumentSingleResponse> _getMockDocument(int id) {
    final mockDocument = DocumentModel(
      id: id,
      title: 'Thông tư 01/2024/TT-BCA về quy định PCCC',
      description: '''
Thông tư quy định về điều kiện an toàn về phòng cháy và chữa cháy đối với nhà cao tầng, nhà siêu cao tầng.

Căn cứ:
- Luật Phòng cháy và chữa cháy năm 2001;
- Luật sửa đổi, bổ sung một số điều của Luật Phòng cháy và chữa cháy năm 2013;
- Nghị định số 79/2014/NĐ-CP ngày 31/7/2014 của Chính phủ quy định chi tiết thi hành một số điều của Luật Phòng cháy và chữa cháy và Luật sửa đổi, bổ sung một số điều của Luật Phòng cháy và chữa cháy;

Bộ trưởng Bộ Công an ban hành Thông tư quy định về điều kiện an toàn về phòng cháy và chữa cháy đối với nhà cao tầng, nhà siêu cao tầng.
      ''',
      documentNumber: '01/2024/TT-BCA',
      effectiveDate: '2024-03-01',
      categoryId: 1,
      subCategoryId: 1,
      agencyId: 1,
      documentTypeId: 1,
      file: 'document_$id.pdf',
      tags: 'PCCC, thông tư, nhà cao tầng, quy định',
    );

    final response = DocumentSingleResponse(data: mockDocument);
    return ApiResponse.success(response);
  }
} 