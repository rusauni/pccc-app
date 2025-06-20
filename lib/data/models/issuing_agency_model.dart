import 'package:vnl_common_ui/vnl_ui.dart';

class IssuingAgencyModel {
  final int? id;
  final String? agencyName;

  IssuingAgencyModel({
    this.id,
    this.agencyName,
  });

  factory IssuingAgencyModel.fromJson(Map<String, dynamic> json) {
    return IssuingAgencyModel(
      id: json['id'],
      agencyName: json['agency_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_name': agencyName,
    };
  }

  IssuingAgencyModel copyWith({
    int? id,
    String? agencyName,
  }) {
    return IssuingAgencyModel(
      id: id ?? this.id,
      agencyName: agencyName ?? this.agencyName,
    );
  }
}

class IssuingAgencyListResponse {
  final List<IssuingAgencyModel> data;
  final IssuingAgencyMetadata meta;

  IssuingAgencyListResponse({
    required this.data,
    required this.meta,
  });

  factory IssuingAgencyListResponse.fromJson(Map<String, dynamic> json) {
    return IssuingAgencyListResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => IssuingAgencyModel.fromJson(item))
          .toList(),
      meta: IssuingAgencyMetadata.fromJson(json['meta']),
    );
  }
}

class IssuingAgencySingleResponse {
  final IssuingAgencyModel data;

  IssuingAgencySingleResponse({required this.data});

  factory IssuingAgencySingleResponse.fromJson(Map<String, dynamic> json) {
    return IssuingAgencySingleResponse(
      data: IssuingAgencyModel.fromJson(json['data']),
    );
  }
}

class IssuingAgencyMetadata {
  final int totalCount;
  final int filterCount;

  IssuingAgencyMetadata({
    required this.totalCount,
    required this.filterCount,
  });

  factory IssuingAgencyMetadata.fromJson(Map<String, dynamic> json) {
    return IssuingAgencyMetadata(
      totalCount: json['total_count'] ?? 0,
      filterCount: json['filter_count'] ?? 0,
    );
  }
} 