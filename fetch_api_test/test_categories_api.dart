import 'dart:io';
import '../lib/data/api_client/base_api_client.dart';
import '../lib/data/api_client/pccc_environment.dart';
import '../lib/data/repositories/category_repository.dart';
import '../lib/data/models/category_model.dart';

/// Test script để kiểm tra API lấy danh sách danh mục và chi tiết danh mục
Future<void> main() async {
  print('🚀 Bắt đầu test API Categories...\n');

  // Khởi tạo environment và API client
  final environment = PcccEnvironment.development();
  final apiClient = BaseApiClient(environment: environment);
  final categoryRepository = CategoryRepositoryImpl(
    apiClient: apiClient,
    useMockData: false, // Sử dụng mock data để test
  );

  await testGetCategoriesList(categoryRepository);
  await testGetSingleCategory(categoryRepository);
  
  print('\n✅ Hoàn thành test API Categories!');
}

/// Test lấy danh sách danh mục
Future<void> testGetCategoriesList(CategoryRepository repository) async {
  print('📚 Test 1: Lấy danh sách danh mục');
  print('=' * 50);

  try {
    final response = await repository.getCategories(
      limit: 20,
      offset: 0,
      fields: ['id', 'name', 'slug', 'parent_id', 'order'],
      sort: ['order', 'name'],
    );

    if (response.isSuccess && response.data != null) {
      final categories = response.data!;
      print('✅ Thành công! Tìm thấy ${categories.data.length} danh mục');
      print('📊 Tổng số: ${categories.meta.totalCount}');
      print('🔍 Số lượng lọc: ${categories.meta.filterCount}');
      print('\n📄 Danh sách danh mục:');
      
      for (int i = 0; i < categories.data.length; i++) {
        final category = categories.data[i];
        print('${i + 1}. ID: ${category.id} - ${category.name}');
        print('   🔗 Slug: ${category.slug ?? 'Không có slug'}');
        print('   📁 Parent ID: ${category.parentId ?? 'Danh mục gốc'}');
        print('   🔢 Thứ tự: ${category.order ?? 'Không có'}');
        print('');
      }
    } else {
      print('❌ Lỗi khi lấy danh sách danh mục:');
      if (response.error != null) {
        print('   Code: ${response.error!.error.code}');
        print('   Message: ${response.error!.error.message}');
      }
      print('   Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Exception khi test getCategories: $e');
  }

  print('\n' + '=' * 50 + '\n');
}

/// Test lấy chi tiết một danh mục
Future<void> testGetSingleCategory(CategoryRepository repository) async {
  print('📄 Test 2: Lấy chi tiết danh mục');
  print('=' * 50);

  try {
    const testCategoryId = 1;
    final response = await repository.getCategory(
      testCategoryId,
      fields: ['id', 'name', 'slug', 'parent_id', 'order'],
    );

    if (response.isSuccess && response.data != null) {
      final category = response.data!.data;
      print('✅ Thành công! Lấy được chi tiết danh mục');
      print('\n📄 Thông tin chi tiết:');
      print('   🆔 ID: ${category.id}');
      print('   📝 Tên: ${category.name}');
      print('   🔗 Slug: ${category.slug ?? 'Không có slug'}');
      print('   📁 Parent ID: ${category.parentId ?? 'Danh mục gốc'}');
      print('   🔢 Thứ tự: ${category.order ?? 'Không có'}');
      
      // Hiển thị thông tin về cấu trúc danh mục
      if (category.parentId != null) {
        print('   🏗️ Loại: Danh mục con (có danh mục cha)');
      } else {
        print('   🏗️ Loại: Danh mục gốc');
      }
    } else {
      print('❌ Lỗi khi lấy chi tiết danh mục:');
      if (response.error != null) {
        print('   Code: ${response.error!.error.code}');
        print('   Message: ${response.error!.error.message}');
      }
      print('   Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Exception khi test getCategory: $e');
  }

  print('\n' + '=' * 50 + '\n');
}

/// Test với các tham số filter và search
Future<void> testAdvancedQueries(CategoryRepository repository) async {
  print('🔍 Test 3: Test các query nâng cao');
  print('=' * 50);

  try {
    // Test filter theo parent_id
    print('🔸 Test filter theo parent_id...');
    final filterResponse = await repository.getCategories(
      filter: '{"parent_id": {"_null": true}}', // Lấy danh mục gốc
      limit: 5,
    );

    if (filterResponse.isSuccess && filterResponse.data != null) {
      print('✅ Filter thành công! Tìm thấy ${filterResponse.data!.data.length} danh mục gốc');
    } else {
      print('❌ Filter thất bại');
    }

    print('');

    // Test search theo tên
    print('🔸 Test search theo tên...');
    final searchResponse = await repository.getCategories(
      search: 'pháp luật',
      limit: 10,
    );

    if (searchResponse.isSuccess && searchResponse.data != null) {
      print('✅ Search thành công! Tìm thấy ${searchResponse.data!.data.length} kết quả');
      for (final category in searchResponse.data!.data) {
        print('   - ${category.name}');
      }
    } else {
      print('❌ Search thất bại');
    }

  } catch (e) {
    print('❌ Exception khi test advanced queries: $e');
  }

  print('\n' + '=' * 50 + '\n');
} 