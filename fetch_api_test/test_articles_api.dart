import 'dart:io';
import '../lib/data/api_client/base_api_client.dart';
import '../lib/data/api_client/pccc_environment.dart';
import '../lib/data/repositories/article_repository.dart';
import '../lib/data/models/article_model.dart';

/// Test script để kiểm tra API lấy danh sách bài viết và chi tiết bài viết
Future<void> main() async {
  print('🚀 Bắt đầu test API Articles...\n');

  // Khởi tạo environment và API client
  final environment = PcccEnvironment.development();
  final apiClient = BaseApiClient(environment: environment);
  final articleRepository = ArticleRepositoryImpl(
    apiClient: apiClient,
    useMockData: false, // Sử dụng mock data để test
  );

  await testGetArticlesList(articleRepository);
  await testGetSingleArticle(articleRepository);
  
  print('\n✅ Hoàn thành test API Articles!');
}

/// Test lấy danh sách bài viết
Future<void> testGetArticlesList(ArticleRepository repository) async {
  print('📚 Test 1: Lấy danh sách bài viết');
  print('=' * 50);

  try {
    final response = await repository.getArticles(
      limit: 10,
      offset: 0,
      fields: ['id', 'title', 'summary', 'slug', 'thumbnail'],
    );

    if (response.isSuccess && response.data != null) {
      final articles = response.data!;
      print('✅ Thành công! Tìm thấy ${articles.data.length} bài viết');
      print('📊 Tổng số: ${articles.meta.totalCount}');
      print('🔍 Số lượng lọc: ${articles.meta.filterCount}');
      print('\n📄 Danh sách bài viết:');
      
      for (int i = 0; i < articles.data.length; i++) {
        final article = articles.data[i];
        print('${i + 1}. ID: ${article.id} - ${article.title}');
        print('   📝 Tóm tắt: ${article.summary ?? 'Không có tóm tắt'}');
        print('   🔗 Slug: ${article.slug ?? 'Không có slug'}');
        print('   📁 Category ID: ${article.categoryId ?? 'Không có'}');
        print('   🏷️ Tags: ${article.tags ?? 'Không có'}');
        print('   📅 Ngày tạo: ${article.dateCreated ?? 'Không có'}');
        print('');
      }
    } else {
      print('❌ Lỗi khi lấy danh sách bài viết:');
      if (response.error != null) {
        print('   Code: ${response.error!.error.code}');
        print('   Message: ${response.error!.error.message}');
      }
      print('   Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Exception khi test getArticles: $e');
  }

  print('\n' + '=' * 50 + '\n');
}

/// Test lấy chi tiết một bài viết
Future<void> testGetSingleArticle(ArticleRepository repository) async {
  print('📄 Test 2: Lấy chi tiết bài viết');
  print('=' * 50);

  try {
    const testArticleId = 1;
    final response = await repository.getArticle(
      testArticleId,
      fields: ['id', 'title', 'content', 'summary', 'slug', 'thumbnail', 'category'],
    );

    if (response.isSuccess && response.data != null) {
      final article = response.data!.data;
      print('✅ Thành công! Lấy được chi tiết bài viết');
      print('\n📄 Thông tin chi tiết:');
      print('   🆔 ID: ${article.id}');
      print('   📝 Tiêu đề: ${article.title}');
      print('   📄 Tóm tắt: ${article.summary ?? 'Không có tóm tắt'}');
      print('   🔗 Slug: ${article.slug ?? 'Không có slug'}');
      print('   🖼️ Thumbnail: ${article.thumbnail ?? 'Không có'}');
      print('   📁 Category ID: ${article.categoryId ?? 'Không có'}');
      print('   🏷️ Tags: ${article.tags ?? 'Không có'}');
      print('   📅 Ngày tạo: ${article.dateCreated ?? 'Không có'}');
      print('   📅 Ngày cập nhật: ${article.dateUpdated ?? 'Không có'}');
      print('   👤 Người tạo: ${article.userCreated ?? 'Không có'}');
      print('   🔢 Sort: ${article.sort ?? 'Không có'}');
      
      if (article.content != null && article.content!.isNotEmpty) {
        final contentPreview = article.content!.length > 100 
            ? '${article.content!.substring(0, 100)}...' 
            : article.content!;
        print('   📋 Nội dung (preview): $contentPreview');
      } else {
        print('   📋 Nội dung: Không có');
      }
    } else {
      print('❌ Lỗi khi lấy chi tiết bài viết:');
      if (response.error != null) {
        print('   Code: ${response.error!.error.code}');
        print('   Message: ${response.error!.error.message}');
      }
      print('   Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Exception khi test getArticle: $e');
  }

  print('\n' + '=' * 50 + '\n');
} 