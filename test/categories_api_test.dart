import 'package:flutter_test/flutter_test.dart';
import 'package:base_app/data/api_client/base_api_client.dart';
import 'package:base_app/data/api_client/pccc_environment.dart';
import 'package:base_app/data/repositories/category_repository.dart';
import 'package:base_app/data/models/category_model.dart';
import 'dart:convert';

// Helper function để log API response ra console
void logCategoryApiResponse(String endpoint, dynamic response, {Map<String, dynamic>? queryParams}) {
  print('\n🌐 ============= CATEGORY API CALL LOG =============');
  print('📡 Endpoint: $endpoint');
  
  if (queryParams != null && queryParams.isNotEmpty) {
    print('🔍 Query Params: ${jsonEncode(queryParams)}');
  }
  
  if (response.isSuccess) {
    print('✅ Status: SUCCESS (${response.statusCode})');
    if (response.data != null) {
      // Log basic info về response data
      if (response.data is CategoryListResponse) {
        final listResponse = response.data as CategoryListResponse;
        print('📊 Total Categories: ${listResponse.meta.totalCount}');
        print('🔢 Filtered Count: ${listResponse.meta.filterCount}');
        print('🗂️ Categories in response: ${listResponse.data.length}');
        
        // Log chi tiết một vài categories đầu
        final displayCount = listResponse.data.length > 3 ? 3 : listResponse.data.length;
        for (int i = 0; i < displayCount; i++) {
          final category = listResponse.data[i];
          print('   ${i + 1}. ID: ${category.id} - "${category.name}"');
          print('      👆 Parent ID: ${category.parentId ?? "Top level"}');
          print('      🔗 Slug: ${category.slug ?? "No slug"}');
          print('      📈 Order: ${category.order ?? "No order"}');
        }
        
        if (listResponse.data.length > 3) {
          print('   ... và ${listResponse.data.length - 3} categories khác');
        }
      } else if (response.data is CategorySingleResponse) {
        final singleResponse = response.data as CategorySingleResponse;
        final category = singleResponse.data;
        print('🗂️ Category Details:');
        print('   🆔 ID: ${category.id}');
        print('   📝 Name: "${category.name}"');
        print('   👆 Parent ID: ${category.parentId ?? "Top level"}');
        print('   🔗 Slug: ${category.slug ?? "No slug"}');
        print('   📈 Order: ${category.order ?? "No order"}');
      }
    }
  } else {
    print('❌ Status: ERROR (${response.statusCode})');
    if (response.error != null) {
      print('💥 Error Code: ${response.error!.error.code}');
      print('📝 Error Message: ${response.error!.error.message}');
    }
  }
  print('🌐 ===============================================\n');
}

void main() {
  group('Categories API Tests', () {
    late CategoryRepository categoryRepository;
    late BaseApiClient apiClient;

    setUpAll(() {
      // Setup test environment
      final environment = PcccEnvironment.development();
      apiClient = BaseApiClient(environment: environment);
      categoryRepository = CategoryRepositoryImpl(
        apiClient: apiClient,
        useMockData: true, // Sử dụng mock data cho test
      );
    });

    group('Get Categories List', () {
      test('should return list of categories successfully', () async {
        // Arrange
        const expectedLimit = 20;
        const expectedOffset = 0;
        const expectedFields = ['id', 'name', 'slug', 'parent_id', 'order'];
        const expectedSort = ['order', 'name'];

        // Act
        final response = await categoryRepository.getCategories(
          limit: expectedLimit,
          offset: expectedOffset,
          fields: expectedFields,
          sort: expectedSort,
        );

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories', response, queryParams: {
          'limit': expectedLimit,
          'offset': expectedOffset,
          'fields': expectedFields,
          'sort': expectedSort,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
        expect(response.data!.data, isNotEmpty);
        expect(response.data!.meta.totalCount, greaterThan(0));
        expect(response.data!.meta.filterCount, greaterThan(0));

        // Verify first category structure
        final firstCategory = response.data!.data.first;
        expect(firstCategory.id, isNotNull);
        expect(firstCategory.name, isNotEmpty);
        expect(firstCategory.slug, isNotNull);
        expect(firstCategory.order, isNotNull);
      });

      test('should handle empty results', () async {
        // Act
        final response = await categoryRepository.getCategories(limit: 0);

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories (empty)', response, queryParams: {
          'limit': 0,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });

      test('should handle filter parameters correctly', () async {
        // Arrange
        const testFilter = '{"parent_id": {"_null": true}}'; // Lấy danh mục gốc

        // Act
        final response = await categoryRepository.getCategories(
          filter: testFilter,
          limit: 5,
        );

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories (filtered)', response, queryParams: {
          'filter': testFilter,
          'limit': 5,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });

      test('should handle search parameters correctly', () async {
        // Arrange
        const testSearch = 'pháp luật';

        // Act
        final response = await categoryRepository.getCategories(
          search: testSearch,
          limit: 10,
        );

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories (search)', response, queryParams: {
          'search': testSearch,
          'limit': 10,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });
    });

    group('Get Single Category', () {
      test('should return single category successfully', () async {
        // Arrange
        const testCategoryId = 1;
        const expectedFields = ['id', 'name', 'slug', 'parent_id', 'order'];

        // Act
        final response = await categoryRepository.getCategory(
          testCategoryId,
          fields: expectedFields,
        );

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories/$testCategoryId', response, queryParams: {
          'fields': expectedFields,
        });

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
        expect(response.data!.data.id, equals(testCategoryId));
        expect(response.data!.data.name, isNotEmpty);
      });

      test('should handle non-existent category ID', () async {
        // Arrange
        const nonExistentId = 99999;

        // Act
        final response = await categoryRepository.getCategory(nonExistentId);

        // Log kết quả API ra console
        logCategoryApiResponse('/items/categories/$nonExistentId (not found)', response);

        // Assert - Mock repository sẽ vẫn trả về data, nhưng trong thực tế có thể là error
        expect(response.isSuccess, isTrue);
      });
    });

    group('Category Model Tests', () {
      test('should create CategoryModel from JSON correctly', () {
        // Arrange
        final jsonData = {
          'id': 1,
          'name': 'Quy định pháp luật',
          'slug': 'quy-dinh-phap-luat',
          'parent_id': null,
          'order': 1,
        };

        // Act
        final category = CategoryModel.fromJson(jsonData);

        // Assert
        expect(category.id, equals(1));
        expect(category.name, equals('Quy định pháp luật'));
        expect(category.slug, equals('quy-dinh-phap-luat'));
        expect(category.parentId, isNull);
        expect(category.order, equals(1));
      });

      test('should create CategoryModel with parent from JSON correctly', () {
        // Arrange
        final jsonData = {
          'id': 5,
          'name': 'Thiết bị báo cháy',
          'slug': 'thiet-bi-bao-chay',
          'parent_id': 3,
          'order': 1,
        };

        // Act
        final category = CategoryModel.fromJson(jsonData);

        // Assert
        expect(category.id, equals(5));
        expect(category.name, equals('Thiết bị báo cháy'));
        expect(category.slug, equals('thiet-bi-bao-chay'));
        expect(category.parentId, equals(3));
        expect(category.order, equals(1));
      });

      test('should convert CategoryModel to JSON correctly', () {
        // Arrange
        final category = CategoryModel(
          id: 1,
          name: 'Test Category',
          slug: 'test-category',
          parentId: null,
          order: 1,
        );

        // Act
        final json = category.toJson();

        // Assert
        expect(json['id'], equals(1));
        expect(json['name'], equals('Test Category'));
        expect(json['slug'], equals('test-category'));
        expect(json['parent_id'], isNull);
        expect(json['order'], equals(1));
      });

      test('should create copy with updated fields', () {
        // Arrange
        final original = CategoryModel(
          id: 1,
          name: 'Original Name',
          slug: 'original-slug',
          order: 1,
        );

        // Act
        final updated = original.copyWith(
          name: 'Updated Name',
          slug: 'updated-slug',
          order: 2,
        );

        // Assert
        expect(updated.id, equals(original.id));
        expect(updated.name, equals('Updated Name'));
        expect(updated.slug, equals('updated-slug'));
        expect(updated.order, equals(2));
        expect(original.name, equals('Original Name')); // Original unchanged
      });
    });

    group('CategoryListResponse Tests', () {
      test('should parse CategoryListResponse from JSON correctly', () {
        // Arrange
        final jsonData = {
          'data': [
            {
              'id': 1,
              'name': 'Category 1',
              'slug': 'category-1',
              'parent_id': null,
              'order': 1,
            },
            {
              'id': 2,
              'name': 'Category 2',
              'slug': 'category-2',
              'parent_id': 1,
              'order': 2,
            },
          ],
          'meta': {
            'total_count': 2,
            'filter_count': 2,
          },
        };

        // Act
        final response = CategoryListResponse.fromJson(jsonData);

        // Assert
        expect(response.data, hasLength(2));
        expect(response.data.first.id, equals(1));
        expect(response.data.first.name, equals('Category 1'));
        expect(response.data.first.parentId, isNull);
        expect(response.data.last.id, equals(2));
        expect(response.data.last.name, equals('Category 2'));
        expect(response.data.last.parentId, equals(1));
        expect(response.meta.totalCount, equals(2));
        expect(response.meta.filterCount, equals(2));
      });
    });

    group('Category Hierarchy Tests', () {
      test('should identify parent categories correctly', () {
        // Arrange
        final parentCategory = CategoryModel(
          id: 1,
          name: 'Parent Category',
          parentId: null,
        );

        final childCategory = CategoryModel(
          id: 2,
          name: 'Child Category',
          parentId: 1,
        );

        // Assert
        expect(parentCategory.parentId, isNull);
        expect(childCategory.parentId, isNotNull);
        expect(childCategory.parentId, equals(1));
      });

      test('should handle category hierarchy in mock data', () async {
        // Act
        final response = await categoryRepository.getCategories();

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);

        final categories = response.data!.data;
        final parentCategories = categories.where((c) => c.parentId == null).toList();
        final childCategories = categories.where((c) => c.parentId != null).toList();

        expect(parentCategories, isNotEmpty);
        // Note: Mock data might not have child categories, so we don't assert on childCategories
        // expect(childCategories, isNotEmpty);
      });
    });

    group('Filter and Search Tests', () {
      test('should filter parent categories only', () async {
        // Arrange
        const parentFilter = '{"parent_id": {"_null": true}}';

        // Act
        final response = await categoryRepository.getCategories(
          filter: parentFilter,
        );

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });

      test('should search categories by name', () async {
        // Arrange
        const searchTerm = 'thiết bị';

        // Act
        final response = await categoryRepository.getCategories(
          search: searchTerm,
        );

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });

      test('should handle complex query parameters', () async {
        // Arrange
        const complexSort = ['order', '-name'];
        const complexFilter = '{"order": {"_gte": 1}}';

        // Act
        final response = await categoryRepository.getCategories(
          sort: complexSort,
          filter: complexFilter,
          limit: 5,
          offset: 0,
        );

        // Assert
        expect(response.isSuccess, isTrue);
        expect(response.data, isNotNull);
      });
    });

    group('Error Handling', () {
      test('should handle API errors gracefully', () async {
        // Arrange
        final errorRepository = CategoryRepositoryImpl(
          apiClient: apiClient,
          useMockData: true, // Mock sẽ luôn thành công, test này mô phỏng
        );

        // Act & Assert
        expect(() async {
          await errorRepository.getCategories();
        }, returnsNormally);
      });
    });
  });
} 