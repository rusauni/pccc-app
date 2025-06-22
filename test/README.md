# 🧪 PCCC App API Tests với Detailed Logging

## 📋 Tổng quan

Bộ test cho PCCC App bao gồm comprehensive testing cho Articles và Categories APIs với **detailed logging** hiển thị kết quả API calls ra debug console.

## 🗂️ Cấu trúc Test Files

```
test/
├── articles_api_test.dart       # Test cho Articles API (10 test cases)
├── categories_api_test.dart     # Test cho Categories API (17 test cases)  
├── README.md                    # File này
└── widget_test.dart             # Widget tests
```

## 🌐 API Logging Features

### ✨ Tính năng Logging:
- **🔍 Request Details**: Hiển thị endpoint, query parameters
- **📊 Response Statistics**: Total count, filtered count, số lượng items
- **📄 Content Preview**: Chi tiết data với Vietnamese content
- **✅ Status Tracking**: Success/error codes với chi tiết
- **🏷️ Emoji Icons**: Dễ đọc và phân biệt loại thông tin

### 📋 Log Format:
```
🌐 ============= API CALL LOG =============
📡 Endpoint: /items/articles
🔍 Query Params: {"limit":10,"offset":0}
✅ Status: SUCCESS (200)
📊 Total Articles: 2
📄 Articles in response: 2
   1. ID: 1 - "Quy định về an toàn phòng cháy chữa cháy"
      📝 Summary: Những quy định cơ bản về an toàn PCCC...
🌐 ======================================
```

## 🚀 Cách chạy Tests

### 1. Chạy tất cả API tests:
```bash
flutter test test/articles_api_test.dart test/categories_api_test.dart --verbose
```

### 2. Sử dụng script helper:
```bash
# Bash script
./test_with_logs.sh

# Dart script
dart run run_api_tests.dart
```

### 3. Chạy riêng từng loại:
```bash
# Chỉ Articles
flutter test test/articles_api_test.dart

# Chỉ Categories  
flutter test test/categories_api_test.dart
```

## 📊 Test Coverage

### Articles API Tests (10 cases):
- ✅ Get articles list với pagination
- ✅ Handle empty results
- ✅ Query parameters (sort, filter, search)
- ✅ Get single article
- ✅ Handle non-existent ID
- ✅ JSON serialization/deserialization
- ✅ Model validation
- ✅ Copy methods
- ✅ Response parsing
- ✅ Error handling

### Categories API Tests (17 cases):
- ✅ Get categories list với sorting
- ✅ Handle empty results  
- ✅ Filter parameters (parent categories)
- ✅ Search functionality
- ✅ Get single category
- ✅ Handle non-existent ID
- ✅ JSON serialization/deserialization
- ✅ Parent-child relationships
- ✅ Model validation
- ✅ Copy methods
- ✅ Response parsing
- ✅ List response parsing
- ✅ Single response parsing
- ✅ Metadata parsing
- ✅ Child categories testing
- ✅ Hierarchy validation
- ✅ Error scenarios

## 🎯 Mock Data

### Articles (2 items):
1. **"Quy định về an toàn phòng cháy chữa cháy"**
   - ID: 1, Category: 1
   - Content: Vietnamese PCCC regulations

2. **"Hướng dẫn sử dụng thiết bị chữa cháy"**
   - ID: 2, Category: 2  
   - Content: Fire equipment usage guide

### Categories (4 items):
1. **"Quy định pháp luật"** (ID: 1, Parent: null)
2. **"Hướng dẫn kỹ thuật"** (ID: 2, Parent: null)
3. **"Thiết bị PCCC"** (ID: 3, Parent: null)
4. **"Thiết bị báo cháy"** (ID: 4, Parent: 3)

## 🔧 Logging Implementation

### Helper Functions:
- `logApiResponse()` - Articles API logging
- `logCategoryApiResponse()` - Categories API logging

### Console Output Features:
- 🌐 API call boundaries với headers
- 📡 Endpoint information
- 🔍 Query parameters as JSON
- ✅/❌ Status indicators
- 📊 Response statistics
- 📄/🗂️ Detailed data preview
- 💥 Error details khi có lỗi

## 🎨 Console Styling

- **Success**: Green checkmarks ✅
- **Errors**: Red X marks ❌  
- **Info**: Blue icons 📡🔍
- **Data**: Various emojis (📊📄🗂️)
- **Separators**: Decorative borders

## 📝 Notes

- **Mock Data**: Tests sử dụng mock data, không gọi API thật
- **Vietnamese Content**: Tất cả content đều bằng tiếng Việt về PCCC
- **Real API**: Để test API thật, đổi `useMockData: false` trong repository
- **Error Handling**: Mock sẽ luôn success, real API có thể có errors

---

🔥 **PCCC App Testing Suite** - Complete API testing với detailed logging cho debugging và monitoring! 🚒 