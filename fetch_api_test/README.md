# 🧪 API Test Scripts

Thư mục này chứa các file test để kiểm tra API client của ứng dụng PCCC.

## 📁 Cấu trúc file

- `test_articles_api.dart` - Test API lấy dữ liệu bài viết (với Flutter dependencies)
- `test_categories_api.dart` - Test API lấy dữ liệu danh mục (với Flutter dependencies)
- `test_articles_api_simple.dart` - Test API Articles đơn giản (standalone)
- `test_categories_api_simple.dart` - Test API Categories đơn giản (standalone)
- `run_all_tests.dart` - Chạy tất cả các test và tạo báo cáo
- `README.md` - Hướng dẫn sử dụng

## 🚀 Cách chạy test

### 1. Chạy tất cả tests (Khuyến nghị)

```bash
cd fetch_api_test
dart run run_all_tests.dart
```

**Tính năng:**
- 🧪 Chạy tất cả test cases
- 📊 Báo cáo tổng hợp kết quả
- ⚡ Nhanh chóng và tổng quan

### 2. Test API Articles (Standalone)

```bash
cd fetch_api_test
dart run test_articles_api_simple.dart
```

**Chức năng test:**
- ✅ Lấy danh sách bài viết với mock data
- ✅ Lấy chi tiết một bài viết cụ thể
- ✅ Mô phỏng API endpoints

### 3. Test API Categories (Standalone)

```bash
cd fetch_api_test
dart run test_categories_api_simple.dart
```

**Chức năng test:**
- ✅ Lấy danh sách danh mục với sắp xếp
- ✅ Lấy chi tiết một danh mục cụ thể
- ✅ Test filter, search và các query nâng cao

### 4. Test với Flutter Dependencies (Advanced)

```bash
cd fetch_api_test
dart run test_articles_api.dart
dart run test_categories_api.dart
```

**Lưu ý:** Cần Flutter environment để chạy các test này.

## 🔧 Cấu hình

Các test hiện tại sử dụng **mock data** để tránh phụ thuộc vào API thật. Để test với API thật:

1. Mở file test tương ứng
2. Thay đổi `useMockData: true` thành `useMockData: false`
3. Đảm bảo API server đang chạy và có thể truy cập

## 📊 Kết quả test

Test sẽ hiển thị kết quả chi tiết trên console bao gồm:
- 🎯 Status của từng test
- 📄 Dữ liệu trả về từ API
- ❌ Thông tin lỗi (nếu có)
- 📈 Metadata (tổng số records, số lượng filter, ...)

## 🛠️ Tùy chỉnh test

Bạn có thể chỉnh sửa các tham số test trong từng file:

### Articles API
```dart
final response = await repository.getArticles(
  limit: 10,              // Số lượng bài viết
  offset: 0,              // Vị trí bắt đầu
  fields: ['id', 'title'], // Các field cần lấy
  sort: ['date_created'],  // Sắp xếp
  filter: '...',          // Điều kiện lọc
  search: 'keyword',      // Từ khóa tìm kiếm
);
```

### Categories API
```dart
final response = await repository.getCategories(
  limit: 20,                    // Số lượng danh mục
  offset: 0,                    // Vị trí bắt đầu
  fields: ['id', 'name'],       // Các field cần lấy
  sort: ['order', 'name'],      // Sắp xếp
  filter: '{"parent_id": null}', // Lọc danh mục gốc
  search: 'pháp luật',          // Tìm kiếm
);
```

## 🌐 API Endpoints

Test sẽ gọi đến các endpoint sau:

### Articles
- `GET /items/articles` - Lấy danh sách bài viết
- `GET /items/articles/{id}` - Lấy chi tiết bài viết

### Categories  
- `GET /items/categories` - Lấy danh sách danh mục
- `GET /items/categories/{id}` - Lấy chi tiết danh mục

## 🔍 Debug

Nếu gặp lỗi, kiểm tra:
1. ✅ API server đang chạy
2. ✅ Network connection
3. ✅ API endpoints đúng
4. ✅ Authentication (nếu cần)
5. ✅ Tham số request hợp lệ 