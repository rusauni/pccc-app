import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:base_app/data/services/pccc_analysis_service.dart';
import 'package:base_app/data/models/pccc_system_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PCCC Analysis Logic Tests', () {
    
    setUpAll(() async {
      // Mock the asset loading for tests
      const channel = MethodChannel('flutter/assets');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'loadString') {
          final String key = methodCall.arguments as String;
          if (key == 'assets/data/pccc_systems_data.json') {
            return '''
{
  "pccSystemsData": {
    "systems": [
      {
        "id": "he_thong_chua_chay_tu_dong",
        "name": "Hệ Thống Chữa Cháy Tự Động",
        "description": "Hệ thống tự động phát hiện và dập tắt đám cháy",
        "inputFields": ["loaiNha", "chieuCao", "tongDienTichSan", "khoiTich", "hangNguyHiemChay", "soTang", "mucDichSuDungDacBiet", "tiLePhongCanCC"],
        "conditions": {
          "required": true,
          "rules": [
            {
              "condition": "chieuCao >= 25",
              "description": "Công trình cao từ 25m trở lên"
            },
            {
              "condition": "hangNguyHiemChay IN ['A', 'B', 'C']",
              "description": "Nhà xưởng/kho hạng nguy hiểm A, B, C"
            },
            {
              "condition": "loaiNha IN ['duong_lao', 'cham_soc_khuyet_tat']",
              "description": "Nhà dưỡng lão, chăm sóc người khuyết tật (không phụ thuộc quy mô)"
            },
            {
              "condition": "tiLePhongCanCC >= 40",
              "description": "Toàn bộ nhà nếu tổng diện tích các gian phòng thuộc diện trang bị ≥ 40% tổng diện tích sàn"
            }
          ]
        },
        "reference": "Điều 5.1, Phụ lục A (Bảng A.1, A.2, A.3, A.4)",
        "priority": "high"
      },
      {
        "id": "he_thong_bao_chay_tu_dong",
        "name": "Hệ Thống Báo Cháy Tự Động",
        "description": "Hệ thống phát hiện và cảnh báo cháy tự động",
        "inputFields": ["loaiNha", "chieuCao", "soTang", "tongDienTichSan", "khoiTich", "hangNguyHiemChay", "coTangHam", "soNguoiSuDung"],
        "conditions": {
          "required": true,
          "rules": [
            {
              "condition": "soTang >= 7 OR chieuCao >= 25",
              "description": "Công trình từ 7 tầng hoặc 25m trở lên"
            },
            {
              "condition": "(soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']",
              "description": "Từ 5 tầng hoặc 2.500m³ cho chung cư, trường học"
            }
          ]
        },
        "reference": "Điều 5.2, Phụ lục A (Bảng A.1, A.2, A.3, A.4)",
        "priority": "high"
      },
      {
        "id": "he_thong_hong_nuoc_trong_nha",
        "name": "Hệ Thống Họng Nước Chữa Cháy Trong Nhà",
        "description": "Hệ thống cung cấp nước chữa cháy trong nhà",
        "inputFields": ["loaiNha", "chieuCao", "soTang", "tongDienTichSan", "hangNguyHiemChay", "coTangHam", "suDungChatKiNuoc"],
        "conditions": {
          "required": true,
          "rules": [
            {
              "condition": "hangNguyHiemChay IN ['A', 'B', 'C'] AND tongDienTichSan > 500",
              "description": "Nhà xưởng/kho hạng A,B,C diện tích > 500m²"
            }
          ]
        },
        "reference": "Điều 5.4, Phụ lục B",
        "priority": "medium"
      },
      {
        "id": "he_thong_cap_nuoc_ngoai_nha",
        "name": "Hệ Thống Cấp Nước Chữa Cháy Ngoài Nhà",
        "description": "Hệ thống cung cấp nước chữa cháy ngoài nhà",
        "inputFields": ["loaiNha", "tongDienTichSan", "khoiTich", "khoangCachDenTruNuocCongCong", "khaNangKetNoiNuocSinhHoat"],
        "conditions": {
          "required": false,
          "rules": []
        },
        "reference": "Điều 5.3, Phụ lục C",
        "priority": "medium"
      },
      {
        "id": "thiet_bi_chua_chay_ban_dau",
        "name": "Thiết Bị Chữa Cháy Ban Đầu",
        "description": "Bình chữa cháy, cát, nước và các thiết bị chữa cháy cơ bản",
        "inputFields": ["loaiNha", "dienTichKhuVuc", "coVatCan", "khuVucKhoTiepCan", "loaiBinhChuaChay"],
        "conditions": {
          "required": true,
          "rules": [
            {
              "condition": "loaiNha != 'nha_o_rieng_le'",
              "description": "Hầu hết công trình (trừ nhà ở riêng lẻ không thuộc diện)"
            }
          ]
        },
        "reference": "Điều 5.8, Phụ lục H",
        "priority": "high"
      }
    ],
    "buildingTypes": [
      {
        "id": "nha_o",
        "name": "Nhà ở",
        "subcategories": [
          {"id": "nha_o_rieng_le", "name": "Nhà ở riêng lẻ"},
          {"id": "chung_cu", "name": "Chung cư"},
          {"id": "tap_the", "name": "Nhà tập thể"},
          {"id": "ky_tuc_xa", "name": "Ký túc xá"}
        ]
      },
      {
        "id": "nha_cong_cong",
        "name": "Nhà công cộng",
        "subcategories": [
          {"id": "truong_hoc", "name": "Trường học"},
          {"id": "duong_lao", "name": "Nhà dưỡng lão"},
          {"id": "cham_soc_khuyet_tat", "name": "Nhà chăm sóc người khuyết tật"}
        ]
      }
    ],
    "fireRiskCategories": [
      {"id": "A", "name": "Hạng A - Rất nguy hiểm", "description": "Chất lỏng dễ cháy, khí dễ cháy"},
      {"id": "B", "name": "Hạng B - Nguy hiểm", "description": "Chất rắn dễ cháy, bột dễ cháy"},
      {"id": "C", "name": "Hạng C - Trung bình", "description": "Chất rắn khó cháy"}
    ],
    "suggestions": {}
  }
}
            ''';
          }
        }
        return null;
      });
    });
    
    test('AND logic should work correctly with proper input data', () async {
      final inputData = PCCCInputData();
      inputData.soTang = 5;
      inputData.khoiTich = 2500.0;
      inputData.loaiNha = 'chung_cu';
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      // Hệ thống báo cháy tự động phải bắt buộc với chung cư 5 tầng + 2500m³
      final baoChatSystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_bao_chay_tu_dong'
      );
      
      expect(baoChatSystem.status, 'required');
      expect(baoChatSystem.matchedRules.length, greaterThan(0));
    });

    test('Rule 40% should trigger correctly', () async {
      final inputData = PCCCInputData();
      inputData.tiLePhongCanCC = 45.0; // > 40%
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final chuaChaySystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_chua_chay_tu_dong'
      );
      
      expect(chuaChaySystem.status, 'required');
      expect(chuaChaySystem.matchedRules.any(
        (rule) => rule.contains('40%')
      ), true);
    });

    test('Height condition should work correctly', () async {
      final inputData = PCCCInputData();
      inputData.chieuCao = 30.0; // > 25m
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final chuaChaySystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_chua_chay_tu_dong'
      );
      
      expect(chuaChaySystem.status, 'required');
      expect(chuaChaySystem.matchedRules.any(
        (rule) => rule.contains('25m')
      ), true);
    });

    test('Building type mapping should work', () async {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'duong_lao';
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final chuaChaySystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_chua_chay_tu_dong'
      );
      
      // Nhà dưỡng lão phải bắt buộc không phụ thuộc quy mô
      expect(chuaChaySystem.status, 'required');
      expect(chuaChaySystem.matchedRules.any(
        (rule) => rule.contains('dưỡng lão')
      ), true);
    });

    test('Fire risk category should work', () async {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'A';
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final chuaChaySystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_chua_chay_tu_dong'
      );
      
      expect(chuaChaySystem.status, 'required');
      expect(chuaChaySystem.matchedRules.any(
        (rule) => rule.contains('hạng nguy hiểm A')
      ), true);
    });

    test('Complex AND condition should work', () async {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'B';
      inputData.tongDienTichSan = 600.0;
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final hongNuocSystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_hong_nuoc_trong_nha'
      );
      
      // Với hạng B + > 500m² phải bắt buộc
      expect(hongNuocSystem.status, 'required');
    });

    test('NOT EQUAL operator should work', () async {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'chung_cu'; // != 'nha_o_rieng_le'
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final thieBiSystem = results.firstWhere(
        (r) => r.systemId == 'thiet_bi_chua_chay_ban_dau'
      );
      
      expect(thieBiSystem.status, 'required');
    });

    test('OR logic should work correctly', () async {
      final inputData = PCCCInputData();
      inputData.soTang = 8; // >= 7 (OR condition)
      inputData.chieuCao = 10; // < 25 
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final baoChatSystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_bao_chay_tu_dong'
      );
      
      // Với >= 7 tầng phải bắt buộc dù chiều cao < 25m
      expect(baoChatSystem.status, 'required');
    });

    test('Optional system should not be required without conditions', () async {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'nha_o_rieng_le';
      inputData.chieuCao = 10.0;
      inputData.soTang = 2;
      inputData.tongDienTichSan = 200.0;
      
      final results = await PCCCAnalysisService.analyzeAllSystems(inputData);
      
      final capNuocSystem = results.firstWhere(
        (r) => r.systemId == 'he_thong_cap_nuoc_ngoai_nha'
      );
      
      // Hệ thống này optional và không thỏa điều kiện nào
      expect(capNuocSystem.status, 'optional');
    });
  });

  group('Data Consistency Tests', () {
    
    test('All building types should be available in JSON', () async {
      final systemsData = await PCCCAnalysisService.loadSystemsData();
      
      final allBuildingIds = <String>{};
      for (final type in systemsData.buildingTypes) {
        for (final sub in type.subcategories) {
          allBuildingIds.add(sub.id);
        }
      }
      
      // Các ID được sử dụng trong conditions phải có trong building types
      final requiredIds = {
        'nha_hon_hop', 'dich_vu_luu_tru', 'buu_dien', 'truyen_thanh',
        'van_hoa', 'thu_vien', 'an_uong', 'tham_my', 'vui_choi_giai_tri',
        'hanh_chinh', 'chung_cu', 'tap_the', 'ky_tuc_xa', 'ga_san_bay',
        'ga_duong_sat', 'ben_xe', 'duong_lao', 'cham_soc_khuyet_tat',
        'benh_vien', 'tram_y_te', 'phong_kham', 'nha_o_rieng_le',
        'truong_hoc', 'nha_tre', 'mau_giao', 'nha_xuong', 'nha_kho'
      };
      
      for (final id in requiredIds) {
        expect(allBuildingIds.contains(id), true, 
          reason: 'Building type ID "$id" used in conditions but not found in buildingTypes');
      }
    });

    test('All input fields should be supported in models', () async {
      final systemsData = await PCCCAnalysisService.loadSystemsData();
      final inputData = PCCCInputData();
      
      final supportedFields = inputData.toJson().keys.toSet();
      
      for (final system in systemsData.systems) {
        for (final field in system.inputFields) {
          expect(supportedFields.contains(field), true,
            reason: 'Field "$field" required by ${system.name} but not supported in PCCCInputData');
        }
      }
    });
  });
} 