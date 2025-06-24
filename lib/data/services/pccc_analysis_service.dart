import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pccc_system_model.dart';

class PCCCAnalysisService {
  static PCCCSystemsData? _systemsData;
  
  // Load dữ liệu từ JSON file
  static Future<PCCCSystemsData> loadSystemsData() async {
    if (_systemsData != null) return _systemsData!;
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/pccc_systems_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _systemsData = PCCCSystemsData.fromJson(jsonData);
      return _systemsData!;
    } catch (e) {
      throw Exception('Không thể tải dữ liệu hệ thống PCCC: $e');
    }
  }

  // Phân tích và kiểm tra tất cả hệ thống PCCC
  static Future<List<PCCCCheckResult>> analyzeAllSystems(PCCCInputData inputData) async {
    final systemsData = await loadSystemsData();
    final results = <PCCCCheckResult>[];
    
    for (final system in systemsData.systems) {
      final result = _analyzeSystem(system, inputData, systemsData.suggestions[system.id]);
      results.add(result);
    }
    
    return results;
  }

  // Phân tích một hệ thống cụ thể
  static PCCCCheckResult _analyzeSystem(PCCCSystem system, PCCCInputData inputData, PCCCSuggestions? suggestions) {
    final matchedRules = <String>[];
    bool isRequired = false;
    String status = 'not_required';
    String reason = 'Không đáp ứng điều kiện bắt buộc';

    // Kiểm tra từng rule trong hệ thống
    for (final rule in system.conditions.rules) {
      if (_evaluateRule(rule.condition, inputData)) {
        matchedRules.add(rule.description);
        if (system.conditions.required) {
          isRequired = true;
          status = 'required';
          reason = 'Bắt buộc theo TCVN 3890:2023';
        } else {
          status = 'optional';
          reason = 'Khuyến nghị lắp đặt';
        }
      }
    }

    // Nếu không có rule nào match nhưng hệ thống là optional
    if (matchedRules.isEmpty && !system.conditions.required) {
      status = 'optional';
      reason = 'Có thể cân nhắc lắp đặt tùy theo nhu cầu';
    }
    
    return PCCCCheckResult(
      systemId: system.id,
      systemName: system.name,
      isRequired: isRequired,
      status: status,
      reason: reason,
      matchedRules: matchedRules,
      suggestions: suggestions,
    );
  }

  // Đánh giá rule logic
  static bool _evaluateRule(String condition, PCCCInputData inputData) {
    try {
      // Chỉ xử lý IN operator khi nó đứng một mình (không có AND/OR)
      if (condition.contains(' IN ') && !condition.contains(' AND ') && !condition.contains(' OR ')) {
        return _evaluateInCondition(condition, inputData);
      }

      // Thay thế các biến trong condition bằng giá trị thực tế
      String evaluatedCondition = condition;
      
      // Thay thế string variables trước
      if (inputData.loaiNha != null) {
        evaluatedCondition = evaluatedCondition.replaceAll('loaiNha', "'${inputData.loaiNha}'");
      }
      if (inputData.hangNguyHiemChay != null) {
        evaluatedCondition = evaluatedCondition.replaceAll('hangNguyHiemChay', "'${inputData.hangNguyHiemChay}'");
      }
      if (inputData.loaiCoSo != null) {
        evaluatedCondition = evaluatedCondition.replaceAll('loaiCoSo', "'${inputData.loaiCoSo}'");
      }
      if (inputData.loaiBinhChuaChay != null) {
        evaluatedCondition = evaluatedCondition.replaceAll('loaiBinhChuaChay', "'${inputData.loaiBinhChuaChay}'");
      }
      if (inputData.loaiPhuongTienCoGioi != null) {
        evaluatedCondition = evaluatedCondition.replaceAll('loaiPhuongTienCoGioi', "'${inputData.loaiPhuongTienCoGioi}'");
      }
      
      // Thay thế các biến số
      evaluatedCondition = evaluatedCondition.replaceAll('chieuCao', '${inputData.chieuCao ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('soTang', '${inputData.soTang ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('tongDienTichSan', '${inputData.tongDienTichSan ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('khoiTich', '${inputData.khoiTich ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('soNguoiSuDung', '${inputData.soNguoiSuDung ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('dienTichKhuVuc', '${inputData.dienTichKhuVuc ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('dienTichCoSo', '${inputData.dienTichCoSo ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('khoangCachDenTruNuocCongCong', '${inputData.khoangCachDenTruNuocCongCong ?? 0}');
      evaluatedCondition = evaluatedCondition.replaceAll('tiLePhongCanCC', '${inputData.tiLePhongCanCC ?? 0}');

      // Thay thế các biến boolean
      evaluatedCondition = evaluatedCondition.replaceAll('coTangHam', '${inputData.coTangHam ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('coPhongNgu', '${inputData.coPhongNgu ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('coPhongOnLon', '${inputData.coPhongOnLon ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('coVatCan', '${inputData.coVatCan ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('khuVucKhoTiepCan', '${inputData.khuVucKhoTiepCan ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('khaNangKetNoiNuocSinhHoat', '${inputData.khaNangKetNoiNuocSinhHoat ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('suDungChatKiNuoc', '${inputData.suDungChatKiNuoc ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('viTriBoTriPhongTruc', '${inputData.viTriBoTriPhongTruc ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('coKhuyenKhichMatNaLocDoc', '${inputData.coKhuyenKhichMatNaLocDoc ?? false}');
      evaluatedCondition = evaluatedCondition.replaceAll('mucDichSuDungDacBiet', '${inputData.mucDichSuDungDacBiet ?? false}');

      // Xử lý các điều kiện phức tạp với condition đã được thay thế
      return _evaluateComplexConditionAfterReplacement(evaluatedCondition, inputData);
    } catch (e) {
      return false;
    }
  }

  // Đánh giá điều kiện phức tạp sau khi đã thay thế variables
  static bool _evaluateComplexConditionAfterReplacement(String condition, PCCCInputData inputData) {
    // Remove parentheses và xử lý
    condition = condition.trim();
    if (condition.startsWith('(') && condition.endsWith(')')) {
      condition = condition.substring(1, condition.length - 1);
    }

    // Xử lý IN operator trong mixed conditions
    if (condition.contains(' IN ')) {
      return _evaluateInConditionAfterReplacement(condition, inputData);
    }

    // Xử lý AND/OR operators
    if (condition.contains(' AND ') || condition.contains(' OR ')) {
      return _evaluateLogicalConditionAfterReplacement(condition, inputData);
    }

    // Xử lý các điều kiện đơn giản
    return _evaluateSimpleCondition(condition);
  }

  // Đánh giá điều kiện IN sau khi đã thay thế (cho mixed conditions)
  static bool _evaluateInConditionAfterReplacement(String condition, PCCCInputData inputData) {
    // Xử lý AND/OR với IN
    if (condition.contains(' AND ')) {
      final parts = condition.split(' AND ');
      return parts.every((part) => _evaluateComplexConditionAfterReplacement(part.trim(), inputData));
    }
    
    if (condition.contains(' OR ')) {
      final parts = condition.split(' OR ');
      return parts.any((part) => _evaluateComplexConditionAfterReplacement(part.trim(), inputData));
    }

    // Single IN condition - evaluate the replaced condition directly
    return _evaluateInConditionWithReplacedValues(condition);
  }

  // Đánh giá IN condition khi values đã được thay thế
  static bool _evaluateInConditionWithReplacedValues(String condition) {
    final parts = condition.split(' IN ');
    if (parts.length != 2) return false;

    final valueStr = parts[0].trim();
    final listStr = parts[1].trim();
    
    // Extract list values
    final listMatch = RegExp(r'\[(.*?)\]').firstMatch(listStr);
    if (listMatch == null) return false;
    
    final listValues = listMatch.group(1)!
        .split(',')
        .map((e) => e.trim().replaceAll("'", ""))
        .toList();

    // Get actual value (remove quotes if present)
    final actualValue = valueStr.replaceAll("'", "");
    
    return listValues.contains(actualValue);
  }

  // Đánh giá điều kiện logic sau khi đã thay thế
  static bool _evaluateLogicalConditionAfterReplacement(String condition, PCCCInputData inputData) {
    // Xử lý OR trước
    if (condition.contains(' OR ')) {
      final parts = condition.split(' OR ');
      return parts.any((part) => _evaluateComplexConditionAfterReplacement(part.trim(), inputData));
    }

    // Xử lý AND
    if (condition.contains(' AND ')) {
      final parts = condition.split(' AND ');
      return parts.every((part) => _evaluateComplexConditionAfterReplacement(part.trim(), inputData));
    }

    return _evaluateSimpleCondition(condition);
  }

  // Đánh giá điều kiện IN
  static bool _evaluateInCondition(String condition, PCCCInputData inputData) {
    final parts = condition.split(' IN ');
    if (parts.length != 2) return false;

    final variable = parts[0].trim();
    final listStr = parts[1].trim();
    
    // Extract list values
    final listMatch = RegExp(r'\[(.*?)\]').firstMatch(listStr);
    if (listMatch == null) return false;
    
    final listValues = listMatch.group(1)!
        .split(',')
        .map((e) => e.trim().replaceAll("'", ""))
        .toList();

    // Get actual value
    String? actualValue;
    switch (variable) {
      case 'loaiNha':
        actualValue = inputData.loaiNha;
        break;
      case 'hangNguyHiemChay':
        actualValue = inputData.hangNguyHiemChay;
        break;
      case 'loaiCoSo':
        actualValue = inputData.loaiCoSo;
        break;
      case 'loaiBinhChuaChay':
        actualValue = inputData.loaiBinhChuaChay;
        break;
      case 'loaiPhuongTienCoGioi':
        actualValue = inputData.loaiPhuongTienCoGioi;
        break;
    }
    
    return actualValue != null && listValues.contains(actualValue);
  }

  // Đánh giá điều kiện đơn giản
  static bool _evaluateSimpleCondition(String condition) {
    // Xử lý các phép so sánh
    if (condition.contains('>=')) {
      final parts = condition.split('>=');
      if (parts.length == 2) {
        final left = double.tryParse(parts[0].trim()) ?? 0;
        final right = double.tryParse(parts[1].trim()) ?? 0;
        return left >= right;
      }
    }

    if (condition.contains('<=')) {
      final parts = condition.split('<=');
      if (parts.length == 2) {
        final left = double.tryParse(parts[0].trim()) ?? 0;
        final right = double.tryParse(parts[1].trim()) ?? 0;
        return left <= right;
      }
    }

    if (condition.contains('!=')) {
      final parts = condition.split('!=');
      if (parts.length == 2) {
        final left = parts[0].trim();
        final right = parts[1].trim();
        
        // Xử lý boolean
        if (left == 'true' || left == 'false') {
          return left != right;
        }
        
        // Xử lý string
        return left.replaceAll("'", "") != right.replaceAll("'", "");
      }
    }

    if (condition.contains('>') && !condition.contains('>=')) {
      final parts = condition.split('>');
      if (parts.length == 2) {
        final left = double.tryParse(parts[0].trim()) ?? 0;
        final right = double.tryParse(parts[1].trim()) ?? 0;
        return left > right;
      }
    }

    if (condition.contains('<') && !condition.contains('<=')) {
      final parts = condition.split('<');
      if (parts.length == 2) {
        final left = double.tryParse(parts[0].trim()) ?? 0;
        final right = double.tryParse(parts[1].trim()) ?? 0;
        return left < right;
      }
    }

    if (condition.contains('=') && !condition.contains('>=') && !condition.contains('<=') && !condition.contains('!=')) {
      final parts = condition.split('=');
      if (parts.length == 2) {
        final left = parts[0].trim();
        final right = parts[1].trim();
        
        // Xử lý boolean
        if (left == 'true' || left == 'false') {
          return left == right;
        }
        
        // Xử lý string
        return left.replaceAll("'", "") == right.replaceAll("'", "");
      }
    }

    // Xử lý boolean trực tiếp
    if (condition == 'true') return true;
    if (condition == 'false') return false;

    return false;
  }

  // Lấy gợi ý cho hệ thống
  static Future<PCCCSuggestions?> getSuggestions(String systemId) async {
    final systemsData = await loadSystemsData();
    return systemsData.suggestions[systemId];
  }

  // Lấy danh sách loại công trình
  static Future<List<BuildingType>> getBuildingTypes() async {
    final systemsData = await loadSystemsData();
    return systemsData.buildingTypes;
  }

  // Lấy danh sách hạng nguy hiểm cháy
  static Future<List<FireRiskCategory>> getFireRiskCategories() async {
    final systemsData = await loadSystemsData();
    return systemsData.fireRiskCategories;
  }

  // Tạo báo cáo tổng hợp
  static Map<String, dynamic> generateSummaryReport(List<PCCCCheckResult> results) {
    final requiredSystems = results.where((r) => r.status == 'required').toList();
    final optionalSystems = results.where((r) => r.status == 'optional').toList();
    final notRequiredSystems = results.where((r) => r.status == 'not_required').toList();
    
    return {
      'totalSystems': results.length,
      'requiredCount': requiredSystems.length,
      'optionalCount': optionalSystems.length,
      'notRequiredCount': notRequiredSystems.length,
      'requiredSystems': requiredSystems,
      'optionalSystems': optionalSystems,
      'notRequiredSystems': notRequiredSystems,
      'compliancePercentage': requiredSystems.length / results.length * 100,
    };
  }

  // Public method for testing
  static bool evaluateRuleForTesting(String condition, PCCCInputData inputData) {
    return _evaluateRule(condition, inputData);
  }
} 