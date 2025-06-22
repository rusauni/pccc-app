import 'dart:convert';

// Model cho hệ thống PCCC
class PCCCSystem {
  final String id;
  final String name;
  final String description;
  final List<String> inputFields;
  final PCCCConditions conditions;
  final String reference;
  final String priority;

  PCCCSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.inputFields,
    required this.conditions,
    required this.reference,
    required this.priority,
  });

  factory PCCCSystem.fromJson(Map<String, dynamic> json) {
    return PCCCSystem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      inputFields: List<String>.from(json['inputFields'] ?? []),
      conditions: PCCCConditions.fromJson(json['conditions'] ?? {}),
      reference: json['reference'] ?? '',
      priority: json['priority'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'inputFields': inputFields,
      'conditions': conditions.toJson(),
      'reference': reference,
      'priority': priority,
    };
  }
}

// Model cho điều kiện áp dụng
class PCCCConditions {
  final bool required;
  final List<PCCCRule> rules;

  PCCCConditions({
    required this.required,
    required this.rules,
  });

  factory PCCCConditions.fromJson(Map<String, dynamic> json) {
    return PCCCConditions(
      required: json['required'] ?? false,
      rules: (json['rules'] as List<dynamic>? ?? [])
          .map((rule) => PCCCRule.fromJson(rule))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'rules': rules.map((rule) => rule.toJson()).toList(),
    };
  }
}

// Model cho rule kiểm tra
class PCCCRule {
  final String condition;
  final String description;

  PCCCRule({
    required this.condition,
    required this.description,
  });

  factory PCCCRule.fromJson(Map<String, dynamic> json) {
    return PCCCRule(
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'description': description,
    };
  }
}

// Model cho loại công trình
class BuildingType {
  final String id;
  final String name;
  final List<BuildingSubcategory> subcategories;

  BuildingType({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  factory BuildingType.fromJson(Map<String, dynamic> json) {
    return BuildingType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subcategories: (json['subcategories'] as List<dynamic>? ?? [])
          .map((sub) => BuildingSubcategory.fromJson(sub))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subcategories': subcategories.map((sub) => sub.toJson()).toList(),
    };
  }
}

// Model cho loại công trình con
class BuildingSubcategory {
  final String id;
  final String name;

  BuildingSubcategory({
    required this.id,
    required this.name,
  });

  factory BuildingSubcategory.fromJson(Map<String, dynamic> json) {
    return BuildingSubcategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Model cho hạng nguy hiểm cháy
class FireRiskCategory {
  final String id;
  final String name;
  final String description;

  FireRiskCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory FireRiskCategory.fromJson(Map<String, dynamic> json) {
    return FireRiskCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

// Model cho gợi ý thiết bị
class PCCCSuggestions {
  final List<String> required;
  final List<String> optional;

  PCCCSuggestions({
    required this.required,
    required this.optional,
  });

  factory PCCCSuggestions.fromJson(Map<String, dynamic> json) {
    return PCCCSuggestions(
      required: List<String>.from(json['required'] ?? []),
      optional: List<String>.from(json['optional'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'optional': optional,
    };
  }
}

// Model cho dữ liệu đầu vào kiểm tra
class PCCCInputData {
  String? loaiNha;
  double? chieuCao;
  int? soTang;
  double? tongDienTichSan;
  double? khoiTich;
  String? hangNguyHiemChay;
  bool? coTangHam;
  int? soNguoiSuDung;
  bool? coPhongNgu;
  bool? coPhongOnLon;
  double? dienTichKhuVuc;
  bool? coVatCan;
  bool? khuVucKhoTiepCan;
  String? loaiBinhChuaChay;
  double? khoangCachDenTruNuocCongCong;
  bool? khaNangKetNoiNuocSinhHoat;
  bool? suDungChatKiNuoc;
  String? loaiCoSo;
  double? dienTichCoSo;
  String? loaiPhuongTienCoGioi;
  bool? viTriBoTriPhongTruc;
  bool? coKhuyenKhichMatNaLocDoc;
  bool? mucDichSuDungDacBiet;

  PCCCInputData();

  Map<String, dynamic> toJson() {
    return {
      'loaiNha': loaiNha,
      'chieuCao': chieuCao,
      'soTang': soTang,
      'tongDienTichSan': tongDienTichSan,
      'khoiTich': khoiTich,
      'hangNguyHiemChay': hangNguyHiemChay,
      'coTangHam': coTangHam,
      'soNguoiSuDung': soNguoiSuDung,
      'coPhongNgu': coPhongNgu,
      'coPhongOnLon': coPhongOnLon,
      'dienTichKhuVuc': dienTichKhuVuc,
      'coVatCan': coVatCan,
      'khuVucKhoTiepCan': khuVucKhoTiepCan,
      'loaiBinhChuaChay': loaiBinhChuaChay,
      'khoangCachDenTruNuocCongCong': khoangCachDenTruNuocCongCong,
      'khaNangKetNoiNuocSinhHoat': khaNangKetNoiNuocSinhHoat,
      'suDungChatKiNuoc': suDungChatKiNuoc,
      'loaiCoSo': loaiCoSo,
      'dienTichCoSo': dienTichCoSo,
      'loaiPhuongTienCoGioi': loaiPhuongTienCoGioi,
      'viTriBoTriPhongTruc': viTriBoTriPhongTruc,
      'coKhuyenKhichMatNaLocDoc': coKhuyenKhichMatNaLocDoc,
      'mucDichSuDungDacBiet': mucDichSuDungDacBiet,
    };
  }
}

// Model cho kết quả kiểm tra
class PCCCCheckResult {
  final String systemId;
  final String systemName;
  final bool isRequired;
  final String status; // 'required', 'optional', 'not_required'
  final String reason;
  final List<String> matchedRules;
  final PCCCSuggestions? suggestions;

  PCCCCheckResult({
    required this.systemId,
    required this.systemName,
    required this.isRequired,
    required this.status,
    required this.reason,
    required this.matchedRules,
    this.suggestions,
  });

  factory PCCCCheckResult.fromJson(Map<String, dynamic> json) {
    return PCCCCheckResult(
      systemId: json['systemId'] ?? '',
      systemName: json['systemName'] ?? '',
      isRequired: json['isRequired'] ?? false,
      status: json['status'] ?? 'not_required',
      reason: json['reason'] ?? '',
      matchedRules: List<String>.from(json['matchedRules'] ?? []),
      suggestions: json['suggestions'] != null 
          ? PCCCSuggestions.fromJson(json['suggestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemId': systemId,
      'systemName': systemName,
      'isRequired': isRequired,
      'status': status,
      'reason': reason,
      'matchedRules': matchedRules,
      'suggestions': suggestions?.toJson(),
    };
  }
}

// Model chính chứa toàn bộ dữ liệu PCCC
class PCCCSystemsData {
  final List<PCCCSystem> systems;
  final List<BuildingType> buildingTypes;
  final List<FireRiskCategory> fireRiskCategories;
  final Map<String, PCCCSuggestions> suggestions;

  PCCCSystemsData({
    required this.systems,
    required this.buildingTypes,
    required this.fireRiskCategories,
    required this.suggestions,
  });

  factory PCCCSystemsData.fromJson(Map<String, dynamic> json) {
    final pccData = json['pccSystemsData'] ?? {};
    
    return PCCCSystemsData(
      systems: (pccData['systems'] as List<dynamic>? ?? [])
          .map((system) => PCCCSystem.fromJson(system))
          .toList(),
      buildingTypes: (pccData['buildingTypes'] as List<dynamic>? ?? [])
          .map((type) => BuildingType.fromJson(type))
          .toList(),
      fireRiskCategories: (pccData['fireRiskCategories'] as List<dynamic>? ?? [])
          .map((category) => FireRiskCategory.fromJson(category))
          .toList(),
      suggestions: (pccData['suggestions'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, PCCCSuggestions.fromJson(value))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pccSystemsData': {
        'systems': systems.map((system) => system.toJson()).toList(),
        'buildingTypes': buildingTypes.map((type) => type.toJson()).toList(),
        'fireRiskCategories': fireRiskCategories.map((category) => category.toJson()).toList(),
        'suggestions': suggestions.map((key, value) => MapEntry(key, value.toJson())),
      }
    };
  }
} 