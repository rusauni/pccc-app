import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';

class DocumentModel {
  final int? id;
  final String title;
  final String? file;
  final String? description;
  final dynamic category; // Can be int or CategoryObject
  final String? categoryName;
  final String? documentNumber;
  final String? effectiveDate;
  final dynamic subCategory; // Can be int or SubCategoryObject
  final String? subCategoryName;
  final dynamic agencyId; // Can be int or AgencyObject
  final String? agencyName;
  final dynamic documentTypeId; // Can be int or DocumentTypeObject
  final String? documentTypeName;
  final String? tags;

  DocumentModel({
    this.id,
    required this.title,
    this.file,
    this.description,
    this.category,
    this.categoryName,
    this.documentNumber,
    this.effectiveDate,
    this.subCategory,
    this.subCategoryName,
    this.agencyId,
    this.agencyName,
    this.documentTypeId,
    this.documentTypeName,
    this.tags,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // Handle nested category object
    String? categoryName;
    dynamic categoryValue = json['category'];
    if (categoryValue is Map<String, dynamic>) {
      categoryName = categoryValue['name'];
    }

    // Handle nested sub_category object
    String? subCategoryName;
    dynamic subCategoryValue = json['sub_category'];
    if (subCategoryValue is Map<String, dynamic>) {
      subCategoryName = subCategoryValue['sub_name'];
    }

    // Handle nested agency_id object
    String? agencyName;
    dynamic agencyValue = json['agency_id'];
    if (agencyValue is Map<String, dynamic>) {
      agencyName = agencyValue['agency_name'];
    }

    // Handle nested document_type_id object
    String? documentTypeName;
    dynamic documentTypeValue = json['document_type_id'];
    if (documentTypeValue is Map<String, dynamic>) {
      documentTypeName = documentTypeValue['document_type_name'];
    }

    return DocumentModel(
      id: json['id'],
      title: json['title'] ?? '',
      file: json['file'],
      description: json['description'],
      category: categoryValue,
      categoryName: categoryName,
      documentNumber: json['document_number'],
      effectiveDate: json['effective_date'],
      subCategory: subCategoryValue,
      subCategoryName: subCategoryName,
      agencyId: agencyValue,
      agencyName: agencyName,
      documentTypeId: documentTypeValue,
      documentTypeName: documentTypeName,
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file': file,
      'description': description,
      'category': category,
      'document_number': documentNumber,
      'effective_date': effectiveDate,
      'sub_category': subCategory,
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
    dynamic category,
    String? categoryName,
    String? documentNumber,
    String? effectiveDate,
    dynamic subCategory,
    String? subCategoryName,
    dynamic agencyId,
    String? agencyName,
    dynamic documentTypeId,
    String? documentTypeName,
    String? tags,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      file: file ?? this.file,
      description: description ?? this.description,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      documentNumber: documentNumber ?? this.documentNumber,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      subCategory: subCategory ?? this.subCategory,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      agencyId: agencyId ?? this.agencyId,
      agencyName: agencyName ?? this.agencyName,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      documentTypeName: documentTypeName ?? this.documentTypeName,
      tags: tags ?? this.tags,
    );
  }

  // Getter to get category ID safely
  int? get categoryId {
    if (category is int) return category;
    if (category is Map<String, dynamic>) return category['id'];
    return null;
  }

  // Getter to get sub category ID safely
  int? get subCategoryId {
    if (subCategory is int) return subCategory;
    if (subCategory is Map<String, dynamic>) return subCategory['id'];
    return null;
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
    Logger.i('📋 Parsing DocumentListResponse from JSON...');
    Logger.i('🔍 JSON keys: ${json.keys.toList()}');
    
    // Handle null or missing data field
    final dataList = json['data'];
    List<DocumentModel> documents = [];
    
    Logger.i('📊 Data field type: ${dataList.runtimeType}');
    
    if (dataList != null && dataList is List) {
      Logger.i('✅ Data is valid List with ${dataList.length} items');
      documents = dataList
          .map((item) => item is Map<String, dynamic> 
              ? DocumentModel.fromJson(item)
              : null)
          .where((item) => item != null)
          .cast<DocumentModel>()
          .toList();
      Logger.i('✅ Successfully parsed ${documents.length} documents');
    } else {
      Logger.e('❌ Data field is null or not a List: $dataList');
    }
    
    // Handle null or missing meta field
    final metaData = json['meta'];
    DocumentMetadata metadata;
    
    Logger.i('📊 Meta field type: ${metaData.runtimeType}');
    
    if (metaData != null && metaData is Map<String, dynamic>) {
      metadata = DocumentMetadata.fromJson(metaData);
      Logger.i('✅ Successfully parsed metadata');
    } else {
      Logger.i('⚠️ Meta field missing, creating default metadata');
      // Create default metadata if missing
      metadata = DocumentMetadata(
        totalCount: documents.length,
        filterCount: documents.length,
      );
    }
    
    return DocumentListResponse(
      data: documents,
      meta: metadata,
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