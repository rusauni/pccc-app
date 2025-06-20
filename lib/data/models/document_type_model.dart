import 'package:vnl_common_ui/vnl_ui.dart';

class DocumentTypeModel {
  final int? id;
  final String? documentTypeName;

  DocumentTypeModel({
    this.id,
    this.documentTypeName,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json['id'],
      documentTypeName: json['document_type_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type_name': documentTypeName,
    };
  }

  DocumentTypeModel copyWith({
    int? id,
    String? documentTypeName,
  }) {
    return DocumentTypeModel(
      id: id ?? this.id,
      documentTypeName: documentTypeName ?? this.documentTypeName,
    );
  }
}

class DocumentTypeListResponse {
  final List<DocumentTypeModel> data;
  final DocumentTypeMetadata meta;

  DocumentTypeListResponse({
    required this.data,
    required this.meta,
  });

  factory DocumentTypeListResponse.fromJson(Map<String, dynamic> json) {
    return DocumentTypeListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => DocumentTypeModel.fromJson(item))
          .toList(),
      meta: DocumentTypeMetadata.fromJson(json['meta']),
    );
  }
}

class DocumentTypeSingleResponse {
  final DocumentTypeModel data;

  DocumentTypeSingleResponse({required this.data});

  factory DocumentTypeSingleResponse.fromJson(Map<String, dynamic> json) {
    return DocumentTypeSingleResponse(
      data: DocumentTypeModel.fromJson(json['data']),
    );
  }
}

class DocumentTypeMetadata {
  final int totalCount;
  final int filterCount;

  DocumentTypeMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory DocumentTypeMetadata.fromJson(Map<String, dynamic> json) {
    return DocumentTypeMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 