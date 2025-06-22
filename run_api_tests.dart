#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('🤖 📁 PCCC API Test Runner with Detailed Logging');
  print('=================================================');
  print('');

  // Colors for terminal output
  const green = '\x1B[32m';
  const blue = '\x1B[34m';
  const yellow = '\x1B[33m';
  const red = '\x1B[31m';
  const reset = '\x1B[0m';

  print('${blue}📊 Chạy test API với logging chi tiết...${reset}');
  print('');

  try {
    // Run Flutter tests with verbose output
    final result = await Process.run(
      'flutter',
      ['test', 'test/articles_api_test.dart', 'test/categories_api_test.dart', '--verbose'],
      runInShell: true,
    );

    // Print the output
    print(result.stdout);
    
    if (result.stderr.isNotEmpty) {
      print('${red}Errors:${reset}');
      print(result.stderr);
    }

    if (result.exitCode == 0) {
      print('');
      print('${green}✅ Tất cả tests đã pass thành công!${reset}');
      print('');
      print('${yellow}📋 Thông tin API Logging:${reset}');
      print('   🌐 Hiển thị endpoint và query parameters');
      print('   📊 Thống kê response data (total, filtered count)'); 
      print('   📄 Chi tiết articles với content Vietnamese');
      print('   🗂️ Chi tiết categories với parent-child hierarchy');
      print('   ✅ Status codes và error handling');
      print('');
      print('${blue}🔧 Các lệnh khác:${reset}');
      print('   dart run run_api_tests.dart  - Chạy script này');
      print('   ./test_with_logs.sh          - Chạy bash script');
      print('   flutter test test/articles_api_test.dart     - Chỉ test articles');
      print('   flutter test test/categories_api_test.dart   - Chỉ test categories');
      print('');
    } else {
      print('${red}❌ Tests failed với exit code: ${result.exitCode}${reset}');
      exit(result.exitCode);
    }
  } catch (e) {
    print('${red}💥 Lỗi khi chạy tests: $e${reset}');
    exit(1);
  }
} 