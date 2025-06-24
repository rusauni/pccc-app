import 'package:flutter_test/flutter_test.dart';
import 'package:base_app/data/services/pccc_analysis_service.dart';
import 'package:base_app/data/models/pccc_system_model.dart';

void main() {
  group('Debug PCCC Logic', () {
    
    test('Debug NOT EQUAL operator', () {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'nha_o_rieng_le';
      
      print('Input: loaiNha = ${inputData.loaiNha}');
      print('Condition: loaiNha != \'nha_o_rieng_le\'');
      
      final result = PCCCAnalysisService.evaluateRuleForTesting("loaiNha != 'nha_o_rieng_le'", inputData);
      print('Result: $result');
      print('Expected: false');
      
      // This should be false but our test shows it's true
      // Let's check what's happening with the evaluation
    });

    test('Debug AND operator', () {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'B';
      inputData.tongDienTichSan = 400.0; // This should make condition false
      
      print('Input: hangNguyHiemChay = ${inputData.hangNguyHiemChay}');
      print('Input: tongDienTichSan = ${inputData.tongDienTichSan}');
      print('Condition: hangNguyHiemChay IN [\'A\', \'B\', \'C\'] AND tongDienTichSan > 500');
      
      // Test parts separately
      final part1 = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C']", inputData);
      final part2 = PCCCAnalysisService.evaluateRuleForTesting("tongDienTichSan > 500", inputData);
      final fullCondition = PCCCAnalysisService.evaluateRuleForTesting("hangNguyHiemChay IN ['A', 'B', 'C'] AND tongDienTichSan > 500", inputData);
      
      print('Part 1 (IN condition): $part1');
      print('Part 2 (area > 500): $part2');
      print('Full AND condition: $fullCondition');
      print('Expected: false (since part2 should be false)');
    });

    test('Debug simple AND without IN', () {
      final inputData = PCCCInputData();
      inputData.chieuCao = 30.0;
      inputData.tongDienTichSan = 400.0; // This should make condition false
      
      print('\\nTesting simple AND without IN operator:');
      print('Input: chieuCao = ${inputData.chieuCao}');
      print('Input: tongDienTichSan = ${inputData.tongDienTichSan}');
      print('Condition: chieuCao >= 25 AND tongDienTichSan > 500');
      
      // Test parts separately
      final part1 = PCCCAnalysisService.evaluateRuleForTesting("chieuCao >= 25", inputData);
      final part2 = PCCCAnalysisService.evaluateRuleForTesting("tongDienTichSan > 500", inputData);
      final fullCondition = PCCCAnalysisService.evaluateRuleForTesting("chieuCao >= 25 AND tongDienTichSan > 500", inputData);
      
      print('Part 1 (height >= 25): $part1');
      print('Part 2 (area > 500): $part2');
      print('Full AND condition: $fullCondition');
      print('Expected: false (since part2 should be false)');
    });

    test('Debug parentheses condition', () {
      final inputData = PCCCInputData();
      inputData.soTang = 3;
      inputData.khoiTich = 1000.0;
      inputData.loaiNha = 'chung_cu';
      
      print('Input: soTang = ${inputData.soTang}');
      print('Input: khoiTich = ${inputData.khoiTich}');
      print('Input: loaiNha = ${inputData.loaiNha}');
      print('Condition: (soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN [\'chung_cu\', \'tap_the\', \'ky_tuc_xa\', \'truong_hoc\']');
      
      // Test parts separately
      final soTangCheck = PCCCAnalysisService.evaluateRuleForTesting("soTang >= 5", inputData);
      final khoiTichCheck = PCCCAnalysisService.evaluateRuleForTesting("khoiTich >= 2500", inputData);
      final loaiNhaCheck = PCCCAnalysisService.evaluateRuleForTesting("loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']", inputData);
      final orCondition = PCCCAnalysisService.evaluateRuleForTesting("soTang >= 5 OR khoiTich >= 2500", inputData);
      final fullCondition = PCCCAnalysisService.evaluateRuleForTesting("(soTang >= 5 OR khoiTich >= 2500) AND loaiNha IN ['chung_cu', 'tap_the', 'ky_tuc_xa', 'truong_hoc']", inputData);
      
      print('soTang >= 5: $soTangCheck');
      print('khoiTich >= 2500: $khoiTichCheck');
      print('loaiNha IN [...]: $loaiNhaCheck');
      print('OR condition: $orCondition');
      print('Full condition: $fullCondition');
      print('Expected: false (since OR should be false AND true = false)');
    });

    test('Simple string comparison test', () {
      final inputData = PCCCInputData();
      inputData.loaiNha = 'chung_cu';
      
      print('Testing simple string comparison');
      print('Input: ${inputData.loaiNha}');
      
      final equalResult = PCCCAnalysisService.evaluateRuleForTesting("loaiNha = 'chung_cu'", inputData);
      final notEqualResult = PCCCAnalysisService.evaluateRuleForTesting("loaiNha != 'chung_cu'", inputData);
      
      print('Equal test: $equalResult');
      print('Not equal test: $notEqualResult');
    });
  });
} 