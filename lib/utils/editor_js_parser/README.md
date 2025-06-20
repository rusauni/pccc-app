# EditorJS Parser for Flutter

Thư viện parse dữ liệu JSON từ EditorJS thành các đối tượng Dart type-safe để sử dụng trong ứng dụng Flutter.

## Giới thiệu

EditorJS là một editor block-style tạo ra JSON sạch thay vì HTML markup phức tạp. Parser này giúp bạn:

- Parse JSON từ EditorJS thành các Dart models type-safe
- Làm việc với từng loại block (paragraph, header, list, image, quote, code, table, delimiter)
- Utilities để search, manipulate và analyze dữ liệu
- Block builders để tạo EditorJS data programmatically

## Cấu trúc JSON EditorJS

```json
{
  "time": 1550476186479,
  "blocks": [
    {
      "id": "oUq2g_tl8y",
      "type": "header", 
      "data": {
        "text": "Tiêu đề",
        "level": 1
      }
    },
    {
      "id": "zbGZFPM-iI",
      "type": "paragraph",
      "data": {
        "text": "Đoạn văn bản"
      }
    }
  ],
  "version": "2.8.1"
}
```

## Cách sử dụng

### 1. Import thư viện

```dart
import 'package:your_app/utils/editor_js_parser/editor_js.dart';
```

### 2. Parse JSON từ EditorJS

```dart
// Từ JSON string
final editorData = EditorJSParser.parseFromString(jsonString);

// Từ Map
final editorData = EditorJSParser.parseFromMap(jsonMap);

// Chuyển thành JSON string
final jsonString = EditorJSParser.toJsonString(editorData);
```

### 3. Làm việc với blocks

```dart
// Lấy summary
final summary = EditorJSParser.createSummary(editorData);
print('Tổng blocks: ${summary.totalBlocks}');
print('Có images: ${summary.hasImages}');

// Lọc blocks theo type
final paragraphs = EditorJSParser.filterBlocksByType(editorData, 'paragraph');
final headers = EditorJSParser.filterBlocksByType(editorData, 'header');

// Parse từng block cụ thể
for (final block in editorData.blocks) {
  switch (block.type) {
    case 'paragraph':
      final paragraphData = EditorJSParser.parseBlockData<ParagraphBlockData>(block);
      print('Text: ${paragraphData.text}');
      break;
    case 'header':
      final headerData = EditorJSParser.parseBlockData<HeaderBlockData>(block);
      print('H${headerData.level}: ${headerData.text}');
      break;
    case 'list':
      final listData = EditorJSParser.parseBlockData<ListBlockData>(block);
      print('List (${listData.style}): ${listData.items}');
      break;
    // ... other block types
  }
}
```

### 4. Utilities

```dart
// Tìm kiếm text
final searchResults = EditorJSUtils.searchBlocks(editorData, 'keyword');

// Đếm từ và ký tự
final wordCount = EditorJSUtils.countWords(editorData);
final charCount = EditorJSUtils.countCharacters(editorData);

// Lấy headers và tạo table of contents
final headers = EditorJSUtils.getHeaders(editorData);
final toc = EditorJSUtils.generateTableOfContents(editorData);

// Lấy image URLs
final imageUrls = EditorJSUtils.getImageUrls(editorData);

// Tìm block theo ID
final block = EditorJSUtils.findBlockById(editorData, 'block_id');
```

### 5. Manipulation data

```dart
// Tạo data rỗng
var data = EditorJSUtils.createEmpty();

// Thêm block
data = EditorJSUtils.addBlock(data, someBlock);

// Xóa block
data = EditorJSUtils.removeBlockAt(data, index);

// Cập nhật block
data = EditorJSUtils.updateBlockAt(data, index, newBlock);

// Di chuyển block
data = EditorJSUtils.moveBlock(data, oldIndex, newIndex);

// Clone data
final clonedData = EditorJSUtils.clone(data);

// Merge hai data
final mergedData = EditorJSUtils.merge(data1, data2);
```

### 6. Block builders

```dart
// Tạo các loại block
final headerBlock = EditorJSBlockBuilders.header('Tiêu đề', 1);
final paragraphBlock = EditorJSBlockBuilders.paragraph('Nội dung đoạn văn');
final listBlock = EditorJSBlockBuilders.list(['Item 1', 'Item 2'], style: 'unordered');
final quoteBlock = EditorJSBlockBuilders.quote('Trích dẫn', caption: 'Tác giả');
final codeBlock = EditorJSBlockBuilders.code('print("Hello World");');
final imageBlock = EditorJSBlockBuilders.image('https://example.com/image.jpg', caption: 'Mô tả');
final tableBlock = EditorJSBlockBuilders.table([
  ['Header 1', 'Header 2'],
  ['Cell 1', 'Cell 2']
], withHeadings: true);
final delimiterBlock = EditorJSBlockBuilders.delimiter();
```

## Các loại Block được hỗ trợ

### 1. Paragraph
```dart
class ParagraphBlockData {
  final String text;
  final String? alignment; // left, center, right, justify
}
```

### 2. Header  
```dart
class HeaderBlockData {
  final String text;
  final int level; // 1-6
  final String? alignment;
}
```

### 3. List
```dart
class ListBlockData {
  final String style; // ordered, unordered
  final List<String> items;
}
```

### 4. Image
```dart
class ImageBlockData {
  final FileData file;
  final String? caption;
  final bool? withBorder;
  final bool? withBackground;
  final bool? stretched;
}
```

### 5. Quote
```dart
class QuoteBlockData {
  final String text;
  final String? caption;
  final String? alignment;
}
```

### 6. Code
```dart
class CodeBlockData {
  final String code;
}
```

### 7. Table
```dart
class TableBlockData {
  final bool? withHeadings;
  final List<List<String>> content;
}
```

### 8. Delimiter
```dart
class DelimiterBlockData {
  // Không có data, chỉ là separator
}
```

## Ví dụ hoàn chỉnh

Xem file `examples/editor_js_example.dart` để có ví dụ chi tiết về tất cả tính năng.

```dart
// Chạy tất cả ví dụ
EditorJSExample.runAllExamples();

// Hoặc chạy từng ví dụ riêng
EditorJSExample.basicExample();
EditorJSExample.blockTypesExample();
EditorJSExample.utilitiesExample();
EditorJSExample.buildersExample();
EditorJSExample.manipulationExample();
```

## Error Handling

```dart
try {
  final editorData = EditorJSParser.parseFromString(jsonString);
  // Process data
} on EditorJSParseException catch (e) {
  print('Parse error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}

// Validate trước khi parse
if (EditorJSParser.validateStructure(jsonMap)) {
  final data = EditorJSParser.parseFromMap(jsonMap);
} else {
  print('Invalid EditorJS structure');
}
```

## Lưu ý

- Thư viện này chỉ parse JSON và cung cấp models, không render UI
- Hỗ trợ tất cả block types phổ biến của EditorJS
- Type-safe với Dart models
- Có utilities để làm việc với data
- Có block builders để tạo data programmatically
- Immutable data structures với copyWith methods 