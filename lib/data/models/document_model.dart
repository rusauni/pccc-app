import 'package:vnl_common_ui/vnl_ui.dart';

class DocumentModel {
  final int? id;
  final String title;
  final String? file;
  final String? description;
  final int? categoryId;
  final String? documentNumber;
  final String? effectiveDate;
  final int? subCategoryId;
  final int? agencyId;
  final int? documentTypeId;
  final String? tags;

  DocumentModel({
    this.id,
    required this.title,
    this.file,
    this.description,
    this.categoryId,
    this.documentNumber,
    this.effectiveDate,
    this.subCategoryId,
    this.agencyId,
    this.documentTypeId,
    this.tags,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      title: json['title'] ?? '',
      file: json['file'],
      description: json['description'],
      categoryId: json['category'],
      documentNumber: json['document_number'],
      effectiveDate: json['effective_date'],
      subCategoryId: json['sub_category'],
      agencyId: json['agency_id'],
      documentTypeId: json['document_type_id'],
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file': file,
      'description': description,
      'category': categoryId,
      'document_number': documentNumber,
      'effective_date': effectiveDate,
      'sub_category': subCategoryId,
      'agency_id': agencyId,
      'document_type_id': documentTypeId,
      'tags': tags,
    };
  }

  DocumentModel copyWith({
    int? id,
    String? title,
    String? file,
    String? description,
    int? categoryId,
    String? documentNumber,
    String? effectiveDate,
    int? subCategoryId,
    int? agencyId,
    int? documentTypeId,
    String? tags,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      file: file ?? this.file,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      documentNumber: documentNumber ?? this.documentNumber,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      agencyId: agencyId ?? this.agencyId,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      tags: tags ?? this.tags,
    );
  }
}

class DocumentListResponse {
  final List<DocumentModel> data;
  final DocumentMetadata meta;

  DocumentListResponse({
    required this.data,
    required this.meta,
  });

  factory DocumentListResponse.fromJson(Map<String, dynamic> json) {
    return DocumentListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => DocumentModel.fromJson(item))
          .toList(),
      meta: DocumentMetadata.fromJson(json['meta']),
    );
  }
}

class DocumentSingleResponse {
  final DocumentModel data;

  DocumentSingleResponse({required this.data});

  factory DocumentSingleResponse.fromJson(Map<String, dynamic> json) {
    return DocumentSingleResponse(
      data: DocumentModel.fromJson(json['data']),
    );
  }
}

class DocumentMetadata {
  final int totalCount;
  final int filterCount;

  DocumentMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory DocumentMetadata.fromJson(Map<String, dynamic> json) {
    return DocumentMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 