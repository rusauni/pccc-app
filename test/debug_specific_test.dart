import 'package:flutter_test/flutter_test.dart';
import 'package:base_app/data/services/pccc_analysis_service.dart';
import 'package:base_app/data/models/pccc_system_model.dart';

void main() {
  group('Debug Specific Failed Cases', () {
    
    test('Debug AND case that should be TRUE', () {
      final inputData = PCCCInputData();
      inputData.hangNguyHiemChay = 'B';
      inputData.tongDienTichSan = 600.0; // > 500, should be true
      
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
      print('Expected: TRUE (since both parts should be true)');
      
      expect(part1, true);
      expect(part2, true);
      expect(fullCondition, true); // This should pass
    });

    test('Debug complex parentheses case that should be TRUE', () {
      final inputData = PCCCInputData();
      inputData.soTang = 5;
      inputData.khoiTich = 2500.0;
      inputData.loaiNha = 'chung_cu';
      
      print('\\nDebug complex case:');
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
      print('Expected: TRUE (since (true OR true) AND true = true)');
      
      expect(soTangCheck, true);
      expect(khoiTichCheck, true);
      expect(loaiNhaCheck, true);
      expect(orCondition, true);
      expect(fullCondition, true); // This should pass
    });
  });
} 