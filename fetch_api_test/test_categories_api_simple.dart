import 'dart:io';

/// Simple test script để kiểm tra API Categories mock data
Future<void> main() async {
  print('🚀 Bắt đầu test API Categories (Mock Data)...\n');

  await testCategoriesMockData();
  await testAPIEndpointsMockup();
  
  print('\n✅ Hoàn thành test API Categories!');
}

/// Test mock data cho Categories
Future<void> testCategoriesMockData() async {
  print('📚 Test 1: Mock data - Danh sách danh mục');
  print('=' * 50);

  try {
    // Mock data cho categories
    final mockCategories = [
      {
        'id': 1,
        'name': 'Quy định pháp luật',
        'slug': 'quy-dinh-phap-luat',
        'parentId': null,
        'order': 1,
      },
      {
        'id': 2,
        'name': 'Hướng dẫn kỹ thuật',
        'slug': 'huong-dan-ky-thuat',
        'parentId': null,
        'order': 2,
      },
      {
        'id': 3,
        'name': 'Thiết bị PCCC',
        'slug': 'thiet-bi-pccc',
        'parentId': null,
        'order': 3,
      },
      {
        'id': 4,
        'name': 'Đào tạo - Tuyên truyền',
        'slug': 'dao-tao-tuyen-truyen',
        'parentId': null,
        'order': 4,
      },
      {
        'id': 5,
        'name': 'Thiết bị báo cháy',
        'slug': 'thiet-bi-bao-chay',
        'parentId': 3, // Danh mục con của "Thiết bị PCCC"
        'order': 1,
      },
      {
        'id': 6,
        'name': 'Thiết bị chữa cháy',
        'slug': 'thiet-bi-chua-chay',
        'parentId': 3, // Danh mục con của "Thiết bị PCCC"
        'order': 2,
      }
    ];

    print('✅ Thành công! Tìm thấy ${mockCategories.length} danh mục');
    print('📊 Tổng số: ${mockCategories.length}');
    print('\n📄 Danh sách danh mục:');
    
    for (int i = 0; i < mockCategories.length; i++) {
      final category = mockCategories[i];
      final isParent = category['parentId'] == null;
      final prefix = isParent ? '📁' : '  └─ 📂';
      
      print('${i + 1}. $prefix ID: ${category['id']} - ${category['name']}');
      print('   🔗 Slug: ${category['slug']}');
      if (category['parentId'] != null) {
        print('   👆 Parent ID: ${category['parentId']}');
      }
      print('   🔢 Thứ tự: ${category['order']}');
      print('');
    }

    // Test lấy chi tiết một danh mục
    print('\n📄 Test 2: Chi tiết danh mục ID=1');
    print('=' * 50);
    
    final selectedCategory = mockCategories.firstWhere((category) => category['id'] == 1);
    print('✅ Thành công! Lấy được chi tiết danh mục');
    print('\n📄 Thông tin chi tiết:');
    print('   🆔 ID: ${selectedCategory['id']}');
    print('   📝 Tên: ${selectedCategory['name']}');
    print('   🔗 Slug: ${selectedCategory['slug']}');
    print('   📁 Parent ID: ${selectedCategory['parentId'] ?? 'Danh mục gốc'}');
    print('   🔢 Thứ tự: ${selectedCategory['order']}');
    
    // Hiển thị thông tin về cấu trúc danh mục
    if (selectedCategory['parentId'] != null) {
      print('   🏗️ Loại: Danh mục con (có danh mục cha)');
    } else {
      print('   🏗️ Loại: Danh mục gốc');
    }

    // Test filter danh mục gốc
    print('\n🔍 Test 3: Filter danh mục gốc');
    print('=' * 50);
    
    final rootCategories = mockCategories.where((cat) => cat['parentId'] == null).toList();
    print('✅ Filter thành công! Tìm thấy ${rootCategories.length} danh mục gốc:');
    for (final category in rootCategories) {
      print('   📁 ${category['name']}');
    }

    // Test filter danh mục con
    print('\n🔍 Test 4: Filter danh mục con');
    print('=' * 50);
    
    final childCategories = mockCategories.where((cat) => cat['parentId'] != null).toList();
    print('✅ Filter thành công! Tìm thấy ${childCategories.length} danh mục con:');
    for (final category in childCategories) {
      final parentName = mockCategories.firstWhere((p) => p['id'] == category['parentId'])['name'];
      print('   📂 ${category['name']} (thuộc: $parentName)');
    }

    // Test search theo tên
    print('\n🔍 Test 5: Search theo từ khóa "thiết bị"');
    print('=' * 50);
    
    final searchResults = mockCategories.where((cat) => 
      cat['name'].toString().toLowerCase().contains('thiết bị')).toList();
    print('✅ Search thành công! Tìm thấy ${searchResults.length} kết quả:');
    for (final category in searchResults) {
      print('   🔍 ${category['name']}');
    }

  } catch (e) {
    print('❌ Exception khi test Categories: $e');
  }

  print('\n' + '=' * 50 + '\n');
}

/// Test API endpoints mô phỏng
Future<void> testAPIEndpointsMockup() async {
  print('🌐 Test 6: Mock API Endpoints');
  print('=' * 50);

  // Simulate API call to categories endpoint
  print('📡 GET /items/categories');
  print('   ⏳ Đang gọi API...');
  await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": [...], "meta": {"total_count": 6}}');
  
  print('');
  
  // Simulate API call to specific category
  print('📡 GET /items/categories/1');
  print('   ⏳ Đang gọi API...');
  await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": {...}}');

  print('');

  // Simulate API call with filter
  print('📡 GET /items/categories?filter={"parent_id":{"_null":true}}');
  print('   ⏳ Đang gọi API với filter...');
  await Future.delayed(Duration(milliseconds: 400)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": [...], "meta": {"filter_count": 4}}');

  print('');

  // Simulate API call with search
  print('📡 GET /items/categories?search=thiết bị');
  print('   ⏳ Đang gọi API với search...');
  await Future.delayed(Duration(milliseconds: 350)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": [...], "meta": {"filter_count": 3}}');

  print('\n' + '=' * 50 + '\n');
} 