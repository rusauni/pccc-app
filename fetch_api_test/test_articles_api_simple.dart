import 'dart:io';

/// Simple test script để kiểm tra API Articles mock data
Future<void> main() async {
  print('🚀 Bắt đầu test API Articles (Mock Data)...\n');

  await testArticlesMockData();
  
  print('\n✅ Hoàn thành test API Articles!');
}

/// Test mock data cho Articles
Future<void> testArticlesMockData() async {
  print('📚 Test 1: Mock data - Danh sách bài viết');
  print('=' * 50);

  try {
    // Mock data cho articles
    final mockArticles = [
      {
        'id': 1,
        'title': 'Quy định về an toàn phòng cháy chữa cháy',
        'summary': 'Những quy định cơ bản về an toàn PCCC trong các tòa nhà',
        'slug': 'quy-dinh-an-toan-pccc',
        'categoryId': 1,
        'content': 'Nội dung chi tiết về quy định PCCC...',
        'thumbnail': 'thumbnail1.jpg',
        'dateCreated': DateTime.now().toIso8601String(),
        'tags': 'pccc,quy-định,an-toàn',
      },
      {
        'id': 2,
        'title': 'Hướng dẫn sử dụng thiết bị chữa cháy',
        'summary': 'Cách sử dụng các thiết bị chữa cháy cơ bản',
        'slug': 'huong-dan-thiet-bi-chua-chay',
        'categoryId': 2,
        'content': 'Hướng dẫn chi tiết về thiết bị PCCC...',
        'thumbnail': 'thumbnail2.jpg',
        'dateCreated': DateTime.now().toIso8601String(),
        'tags': 'thiết-bị,hướng-dẫn,pccc',
      },
      {
        'id': 3,
        'title': 'Kỹ thuật thoát hiểm khi có hỏa hoạn',
        'summary': 'Các kỹ thuật và phương pháp thoát hiểm an toàn',
        'slug': 'ky-thuat-thoat-hiem',
        'categoryId': 3,
        'content': 'Hướng dẫn kỹ thuật thoát hiểm...',
        'thumbnail': 'thumbnail3.jpg',
        'dateCreated': DateTime.now().toIso8601String(),
        'tags': 'thoát-hiểm,an-toàn,kỹ-thuật',
      }
    ];

    print('✅ Thành công! Tìm thấy ${mockArticles.length} bài viết');
    print('📊 Tổng số: ${mockArticles.length}');
    print('\n📄 Danh sách bài viết:');
    
    for (int i = 0; i < mockArticles.length; i++) {
      final article = mockArticles[i];
      print('${i + 1}. ID: ${article['id']} - ${article['title']}');
      print('   📝 Tóm tắt: ${article['summary']}');
      print('   🔗 Slug: ${article['slug']}');
      print('   📁 Category ID: ${article['categoryId']}');
      print('   🏷️ Tags: ${article['tags']}');
      print('   📅 Ngày tạo: ${article['dateCreated']}');
      print('');
    }

    // Test lấy chi tiết một bài viết
    print('\n📄 Test 2: Chi tiết bài viết ID=1');
    print('=' * 50);
    
    final selectedArticle = mockArticles.firstWhere((article) => article['id'] == 1);
    print('✅ Thành công! Lấy được chi tiết bài viết');
    print('\n📄 Thông tin chi tiết:');
    print('   🆔 ID: ${selectedArticle['id']}');
    print('   📝 Tiêu đề: ${selectedArticle['title']}');
    print('   📄 Tóm tắt: ${selectedArticle['summary']}');
    print('   🔗 Slug: ${selectedArticle['slug']}');
    print('   🖼️ Thumbnail: ${selectedArticle['thumbnail']}');
    print('   📁 Category ID: ${selectedArticle['categoryId']}');
    print('   🏷️ Tags: ${selectedArticle['tags']}');
    print('   📅 Ngày tạo: ${selectedArticle['dateCreated']}');
    
    final content = selectedArticle['content'].toString();
    final contentPreview = content.length > 100 
        ? '${content.substring(0, 100)}...' 
        : content;
    print('   📋 Nội dung (preview): $contentPreview');

  } catch (e) {
    print('❌ Exception khi test Articles: $e');
  }

  print('\n' + '=' * 50 + '\n');
}

/// Test API endpoints mô phỏng
Future<void> testAPIEndpointsMockup() async {
  print('🌐 Test 3: Mock API Endpoints');
  print('=' * 50);

  // Simulate API call to articles endpoint
  print('📡 GET /items/articles');
  print('   ⏳ Đang gọi API...');
  await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": [...], "meta": {"total_count": 3}}');
  
  print('');
  
  // Simulate API call to specific article
  print('📡 GET /items/articles/1');
  print('   ⏳ Đang gọi API...');
  await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
  print('   ✅ Status: 200 OK');
  print('   📊 Response: {"data": {...}}');

  print('\n' + '=' * 50 + '\n');
} 