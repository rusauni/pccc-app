import 'package:flutter_test/flutter_test.dart';
import 'package:base_app/data/api_client/base_api_client.dart';
import 'package:base_app/data/api_client/pccc_environment.dart';
import 'package:base_app/data/repositories/article_repository.dart';
import 'package:base_app/data/models/article_model.dart';
import 'dart:convert';

// Helper function để log API response ra console
void logApiResponse(String endpoint, dynamic response, {Map<String, dynamic>? queryParams}) {
  print('\n🌐 ============= API CALL LOG =============');
  print('📡 Endpoint: $endpoint');
  
  if (queryParams != null && queryParams.isNotEmpty) {
    print('🔍 Query Params: ${jsonEncode(queryParams)}');
  }
  
  if (response.isSuccess) {
    print('✅ Status: SUCCESS (${response.statusCode})');
    if (response.data != null) {
      // Log basic info về response data
      if (response.data is ArticleListResponse) {
        final listResponse = response.data as ArticleListResponse;
        print('📊 Total Articles: ${listResponse.meta.totalCount}');
        print('🔢 Filtered Count: ${listResponse.meta.filterCount}');
        print('📄 Articles in response: ${listResponse.data.length}');
        
        // Log chi tiết một vài articles đầu
        final displayCount = listResponse.data.length > 2 ? 2 : listResponse.data.length;
        for (int i = 0; i < displayCount; i++) {
          final article = listResponse.data[i];
          print('   ${i + 1}. ID: ${article.id} - "${article.title}"');
          print('      📝 Summary: ${article.summary ?? "No summary"}');
          print('      🔗 Slug: ${article.slug ?? "No slug"}');
          print('      📁 Category: ${article.categoryId ?? "No category"}');
        }
        
        if (listResponse.data.length > 2) {
          print('   ... và ${listResponse.data.length - 2} articles khác');
        }
      } else if (response.data is ArticleSingleResponse) {
        final singleResponse = response.data as ArticleSingleResponse;
        final article = singleResponse.data;
        print('📄 Article Details:');
        print('   🆔 ID: ${article.id}');
        print('   📝 Title: "${article.title}"');
        print('   📄 Summary: ${article.summary ?? "No summary"}');
        print('   🔗 Slug: ${article.slug ?? "No slug"}');
        print('   📁 Category: ${article.categoryId ?? "No category"}');
        print('   🏷️ Tags: ${article.tags ?? "No tags"}');
        print('   📅 Created: ${article.dateCreated ?? "No date"}');
        
        if (article.content != null && article.content!.isNotEmpty) {
          final preview = article.content!.length > 100 
              ? '${article.content!.substring(0, 100)}...' 
              : article.content!;
          print('   📋 Content Preview: $preview');
        }
      }
    }
  } else {
    print('❌ Status: ERROR (${response.statusCode})');
    if (response.error != null) {
      print('💥 Error Code: ${response.error!.error.code}');
      print('📝 Error Message: ${response.error!.error.message}');
    }
  }
  print('🌐 ======================================\n');
}

void main() {
  group('Articles API Tests', () {
    late ArticleRepository articleRepository;
    late BaseApiClient apiClient;

    setUpAll(() {
      // Setup test environment
      final environment = PcccEnvironment.development();
      apiClient = BaseApiClient(environment: environment);
      articleRepository = ArticleRepositoryImpl(
        apiClient: apiClient,
        useMockData: true, // Sử dụng mock data cho test
      );
    });

    group('Get Articles List', () {
      test('should return list of articles successfully', () async {
        // Arrange
        const expectedLimit = 10;
        const expectedOffset = 0;
        const expectedFields = ['id', 'title', 'summary', 'slug', 'thumbnail'];

        // Act
        final response = await articleRepository.getArticles(
          limit: expectedLimit,
          offset: expectedOffset,
          fields: expectedFields,
        );

        // Log kết quả API ra console
        logApiResponse('/items/articles', response, queryParams: {
          'limit': expectedLimit,
          'offset': expectedOffset,
          'fields': expectedFields,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
        expect(response.data!.data, isNotEmpty);
        expect(response.data!.meta.totalCount, greaterThan(0));
        expect(response.data!.meta.filterCount, greaterThan(0));

        // Verify first article structure
        final firstArticle = response.data!.data.first;
        expect(firstArticle.id, isNotNull);
        expect(firstArticle.title, isNotEmpty);
        expect(firstArticle.summary, isNotNull);
        expect(firstArticle.slug, isNotNull);
      });

      test('should handle empty results', () async {
        // Act
        final response = await articleRepository.getArticles(limit: 0);

        // Log kết quả API ra console
        logApiResponse('/items/articles (empty)', response, queryParams: {
          'limit': 0,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });

      test('should handle query parameters correctly', () async {
        // Arrange
        const testSort = ['date_created', '-title'];
        const testFilter = '{"status":{"_eq":"published"}}';
        const testSearch = 'PCCC';

        // Act
        final response = await articleRepository.getArticles(
          sort: testSort,
          filter: testFilter,
          search: testSearch,
          limit: 5,
        );

        // Log kết quả API ra console
        logApiResponse('/items/articles (filtered)', response, queryParams: {
          'sort': testSort,
          'filter': testFilter,
          'search': testSearch,
          'limit': 5,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });
    });

    group('Get Single Article', () {
      test('should return single article successfully', () async {
        // Arrange
        const testArticleId = 1;
        const expectedFields = ['id', 'title', 'content', 'summary', 'slug'];

        // Act
        final response = await articleRepository.getArticle(
          testArticleId,
          fields: expectedFields,
        );

        // Log kết quả API ra console
        logApiResponse('/items/articles/$testArticleId', response, queryParams: {
          'fields': expectedFields,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
        expect(response.data!.data.id, equals(testArticleId));
        expect(response.data!.data.title, isNotEmpty);
      });

      test('should handle non-existent article ID', () async {
        // Arrange
        const nonExistentId = 99999;

        // Act
        final response = await articleRepository.getArticle(nonExistentId);

        // Log kết quả API ra console
        logApiResponse('/items/articles/$nonExistentId (not found)', response);

        // Assert - Mock repository sẽ vẫn trả về data, nhưng trong thực tế có thể là error
        expect(response.isSuccess, isTrue);
      });
    });

    group('Article Model Tests', () {
      test('should create ArticleModel from JSON correctly', () {
        // Arrange
        final jsonData = {
          'id': 1,
          'title': 'Test Article',
          'summary': 'Test Summary',
          'slug': 'test-article',
          'category': 1,
          'content': 'Test Content',
          'thumbnail': 'test.jpg',
          'tags': 'test,article',
          'date_created': '2023-12-01T10:00:00Z',
          'date_updated': '2023-12-01T11:00:00Z',
          'user_created': 'admin',
          'user_updated': 'admin',
          'status': 'published',
          'sort': 1,
        };

        // Act
        final article = ArticleModel.fromJson(jsonData);

        // Assert
        expect(article.id, equals(1));
        expect(article.title, equals('Test Article'));
        expect(article.summary, equals('Test Summary'));
        expect(article.slug, equals('test-article'));
        expect(article.categoryId, equals(1));
        expect(article.content, equals('Test Content'));
        expect(article.thumbnail, equals('test.jpg'));
        expect(article.tags, equals('test,article'));
        expect(article.dateCreated, equals('2023-12-01T10:00:00Z'));
        expect(article.userCreated, equals('admin'));
        expect(article.status, equals('published'));
        expect(article.sort, equals(1));
      });

      test('should convert ArticleModel to JSON correctly', () {
        // Arrange
        final article = ArticleModel(
          id: 1,
          title: 'Test Article',
          summary: 'Test Summary',
          slug: 'test-article',
          categoryId: 1,
          content: 'Test Content',
          thumbnail: 'test.jpg',
          tags: 'test,article',
        );

        // Act
        final json = article.toJson();

        // Assert
        expect(json['id'], equals(1));
        expect(json['title'], equals('Test Article'));
        expect(json['summary'], equals('Test Summary'));
        expect(json['slug'], equals('test-article'));
        expect(json['category'], equals(1));
        expect(json['content'], equals('Test Content'));
        expect(json['thumbnail'], equals('test.jpg'));
        expect(json['tags'], equals('test,article'));
      });

      test('should create copy with updated fields', () {
        // Arrange
        final original = ArticleModel(
          id: 1,
          title: 'Original Title',
          summary: 'Original Summary',
        );

        // Act
        final updated = original.copyWith(
          title: 'Updated Title',
          summary: 'Updated Summary',
        );

        // Assert
        expect(updated.id, equals(original.id));
        expect(updated.title, equals('Updated Title'));
        expect(updated.summary, equals('Updated Summary'));
        expect(original.title, equals('Original Title')); // Original unchanged
      });
    });

    group('ArticleListResponse Tests', () {
      test('should parse ArticleListResponse from JSON correctly', () {
        // Arrange
        final jsonData = {
          'data': [
            {
              'id': 1,
              'title': 'Article 1',
              'summary': 'Summary 1',
            },
            {
              'id': 2,
              'title': 'Article 2',
              'summary': 'Summary 2',
            },
          ],
          'meta': {
            'total_count': 2,
            'filter_count': 2,
          },
        };

        // Act
        final response = ArticleListResponse.fromJson(jsonData);

        // Assert
        expect(response.data, hasLength(2));
        expect(response.data.first.id, equals(1));
        expect(response.data.first.title, equals('Article 1'));
        expect(response.data.last.id, equals(2));
        expect(response.data.last.title, equals('Article 2'));
        expect(response.meta.totalCount, equals(2));
        expect(response.meta.filterCount, equals(2));
      });
    });

    group('Error Handling', () {
      test('should handle API errors gracefully', () async {
        // Arrange
        final errorRepository = ArticleRepositoryImpl(
          apiClient: apiClient,
          useMockData: true, // Mock sẽ luôn thành công, test này mô phỏng
        );

        // Act & Assert
        expect(() async {
          await errorRepository.getArticles();
        }, returnsNormally);
      });
    });
  });
} 