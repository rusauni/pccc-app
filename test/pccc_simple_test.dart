import 'package:flutter_test/flutter_test.dart';
import 'package:base_app/data/services/pccc_analysis_service.dart';
import 'package:base_app/data/models/pccc_system_model.dart';

void main() {
  group('PCCC Logic Evaluation Tests', () {
    
    test('Simple condition evaluation should work', () {
      // Test chieuCao >= 25
      final inputData = PCCCInputData();
      inputData.chieuCao = 30.0;
      
      // Manually test the evaluation logic
      final result = PCCCAnalysisService.evaluateRuleForTesting('chieuCao >= 25', inputData);
      expect(result, true);
      
      inputData.chieuCao = 20.0;
      final result2 = PCCCAnalysisService.evaluateRuleForTesting('chieuCao >= 25', inputData);
      expect(result2, false);
    });

    test('NOT EQUAL operator should work', () {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'chung_cu';
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("loaiNha != 'nha_o_rieng_le'", inputData);
      expect(result, true);
      
      inputData.loaiNha = 'nha_o_rieng_le';
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("loaiNha != 'nha_o_rieng_le'", inputData);
      expect(result2, false);
    });

    test('IN operator should work', () {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'A';
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C']", inputData);
      expect(result, true);
      
      inputData.hangNguyHiemChay = 'D';
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C']", inputData);
      expect(result2, false);
    });

    test('AND operator should work correctly', () {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'B';
      inputData.tongDienTichSan = 600.0;
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C'] AND tongDienTichSan > 500", inputData);
      expect(result, true);
      
      inputData.tongDienTichSan = 400.0;
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C'] AND tongDienTichSan > 500", inputData);
      expect(result2, false);
    });

    test('OR operator should work correctly', () {
      final inputData = PCCCInputData();
      inputData.soTang = 8;
      inputData.chieuCao = 20.0;
      
      // soTang >= 7 = true, chieuCao >= 25 = false -> true OR false = true
      final result = PCCCAnalysisService.evaluateRuleForTesting("soTang >= 7 OR chieuCao >= 25", inputData);
      expect(result, true);
      
      inputData.soTang = 5;
      inputData.chieuCao = 30.0;
      
      // soTang >= 7 = false, chieuCao >= 25 = true -> false OR true = true
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("soTang >= 7 OR chieuCao >= 25", inputData);
      expect(result2, true);
      
      inputData.soTang = 5;
      inputData.chieuCao = 20.0;
      
      // soTang >= 7 = false, chieuCao >= 25 = false -> false OR false = false
      final result3 = PCCCAnalysisService.evaluateRuleForTesting("soTang >= 7 OR chieuCao >= 25", inputData);
      expect(result3, false);
    });

    test('Complex parentheses condition should work', () {
      final inputData = PCCCInputData();
      inputData.soTang = 5;
      inputData.khoiTich = 2500.0;
      inputData.loaiNha = 'chung_cu';
      
      // (soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']
      // (true OR true) AND true = true AND true = true
      final result = PCCCAnalysisService.evaluateRuleForTesting("(soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']", inputData);
      expect(result, true);
      
      inputData.soTang = 3;
      inputData.khoiTich = 1000.0;
      inputData.loaiNha = 'chung_cu';
      
      // (false OR false) AND true = false AND true = false
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("(soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']", inputData);
      expect(result2, false);
    });

    test('Rule 40% should evaluate correctly', () {
      final inputData = PCCCInputData();
      inputData.tiLePhongCanCC = 45.0;
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("tiLePhongCanCC >= 40", inputData);
      expect(result, true);
      
      inputData.tiLePhongCanCC = 35.0;
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("tiLePhongCanCC >= 40", inputData);
      expect(result2, false);
    });

    test('Boolean conditions should work', () {
      final inputData = PCCCInputData();
      inputData.coTangHam = true;
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("coTangHam = true", inputData);
      expect(result, true);
      
      inputData.coTangHam = false;
      final result2 = PCCCAnalysisService.evaluateRuleForTesting("coTangHam = true", inputData);
      expect(result2, false);
    });
  });
} 