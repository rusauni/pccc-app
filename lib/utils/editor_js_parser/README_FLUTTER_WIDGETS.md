# 🎨 EditorJS Flutter Widgets

Hệ thống render EditorJS blocks thành Flutter widgets với UI đẹp và hiệu năng cao.

## ✨ Tính năng

- **15+ Block Types**: Hỗ trợ đầy đủ các loại block phổ biến
- **Customizable Styling**: Tùy chỉnh giao diện theo ý muốn
- **Error Handling**: Xử lý lỗi graceful với UI feedback
- **Performance**: Render hiệu quả cho nội dung lớn
- **Material Design**: Tuân thủ Material Design principles

## 📱 Block Types được hỗ trợ

| Block Type | Mô tả | Widget Flutter |
|------------|-------|----------------|
| `paragraph` | Đoạn văn bản | `Text()` |
| `header` | Tiêu đề H1-H6 | `Text()` với style lớn |
| `list` | Danh sách ul/ol | `Column` với bullets |
| `quote` | Trích dẫn | `Container` với border trái |
| `code` | Mã code | `SelectableText()` trong Container |
| `image` | Hình ảnh | `Image.network()` |
| `table` | Bảng dữ liệu | `Table()` |
| `delimiter` | Dòng phân cách | `Divider()` |
| `embed` | Video/iframe nhúng | Interactive container |
| `checklist` | Danh sách checkbox | `CheckBox` với Text |
| `warning` | Thông báo cảnh báo | Orange themed container |
| `linkTool` | Preview link | Card với metadata |
| `attaches` | File đính kèm | Download button với icon |
| `video` | Video player | Video thumbnail với play button |
| `raw` | HTML content | Styled container với HTML preview |

## 🚀 Cách sử dụng cơ bản

```dart
import 'package:your_app/utils/editor_js_parser/editor_js.dart';

// Parse JSON và render
final editorData = EditorJSParser.parseFromString(jsonString);

Widget content = EditorJSFlutterWidgets.renderContent(
  editorData,
  options: EditorJSRenderOptions.defaultTheme(),
);
```

## 🎨 Tùy chỉnh giao diện

### Theme mặc định
```dart
final widget = EditorJSFlutterWidgets.renderContent(
  editorData,
  options: EditorJSRenderOptions.defaultTheme(),
);
```

### Custom styling
```dart
final customOptions = EditorJSRenderOptions(
  // Spacing
  blockSpacing: 20.0,
  blockPadding: EdgeInsets.symmetric(horizontal: 16.0),
  listItemSpacing: 8.0,
  
  // Text styles
  paragraphStyle: TextStyle(fontSize: 16, height: 1.6),
  h1Style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  h2Style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  listStyle: TextStyle(fontSize: 16),
  codeStyle: TextStyle(fontFamily: 'Courier', fontSize: 14),
  
  // Colors
  quoteAccentColor: Colors.blue,
  quoteBackgroundColor: Colors.blue[50],
  codeBackgroundColor: Colors.grey[100],
  
  // Error handling
  showUnknownBlocks: false,
  showErrors: true,
);

final widget = EditorJSFlutterWidgets.renderContent(
  editorData,
  options: customOptions,
);
```

### Dark theme
```dart
final darkOptions = EditorJSRenderOptions(
  paragraphStyle: TextStyle(fontSize: 16, color: Colors.white),
  h1Style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
  quoteBackgroundColor: Colors.grey[800],
  quoteAccentColor: Colors.blueAccent,
  codeBackgroundColor: Colors.black87,
);
```

## 📱 Widget đơn giản

Để sử dụng nhanh, bạn có thể dùng `SimpleEditorJSWidget`:

```dart
SimpleEditorJSWidget(
  jsonString: '''
  {
    "time": 1550476186479,
    "blocks": [
      {
        "type": "header",
        "data": {
          "text": "Tiêu đề bài viết",
          "level": 1
        }
      },
      {
        "type": "paragraph", 
        "data": {
          "text": "Nội dung bài viết..."
        }
      }
    ],
    "version": "2.28.0"
  }
  ''',
  options: EditorJSRenderOptions.defaultTheme(),
)
```

## 🎯 Ví dụ nâng cao

### Render riêng từng block
```dart
for (final block in editorData.blocks) {
  final widget = EditorJSFlutterWidgets.renderBlock(
    block,
    options: options,
  );
  
  if (widget != null) {
    // Thêm widget vào UI
  }
}
```

### Tạo Table of Contents
```dart
final headers = EditorJSUtils.getHeaders(editorData);
final toc = EditorJSUtils.generateTableOfContents(editorData);

Widget buildToc() {
  return Column(
    children: toc.map((item) {
      return ListTile(
        title: Text(item.text),
        leading: Text('H${item.level}'),
        onTap: () {
          // Scroll to block
        },
      );
    }).toList(),
  );
}
```

### Search trong content
```dart
final searchResults = EditorJSUtils.searchBlocks(editorData, 'từ khóa');

// Highlight search results
final highlightedWidgets = EditorJSFlutterWidgets.renderBlocks(
  EditorJSData(blocks: searchResults, time: editorData.time),
  options: options,
);
```

## 🔧 Error Handling

```dart
try {
  final widget = EditorJSFlutterWidgets.renderContent(
    editorData,
    options: EditorJSRenderOptions(
      showErrors: true, // Hiển thị lỗi trong UI
      showUnknownBlocks: false, // Ẩn block types không hỗ trợ
    ),
  );
} catch (e) {
  // Handle parsing errors
  return ErrorWidget('Lỗi render EditorJS: $e');
}
```

## 📊 Performance Tips

1. **Lazy Loading**: Dùng `ListView.builder` cho nội dung dài
2. **Image Caching**: Sử dụng `CachedNetworkImage` thay vì `Image.network`
3. **Text Rendering**: Cân nhắc `SelectableText` vs `Text` based on needs
4. **Memory Management**: Dispose các controllers khi không cần

### Lazy loading example:
```dart
ListView.builder(
  itemCount: editorData.blocks.length,
  itemBuilder: (context, index) {
    final block = editorData.blocks[index];
    return EditorJSFlutterWidgets.renderBlock(block, options: options);
  },
)
```

## 🎨 Custom Block Renderer

Để tạo renderer tùy chỉnh cho block type mới:

```dart
Widget customBlockRenderer(EditorJSBlock block, EditorJSRenderOptions opts) {
  switch (block.type) {
    case 'custom_block':
      return CustomWidget(data: block.data);
    default:
      return EditorJSFlutterWidgets.renderBlock(block, options: opts);
  }
}
```

## 📋 Best Practices

1. **Responsive Design**: Sử dụng responsive layouts
2. **Accessibility**: Thêm semantic labels
3. **Testing**: Test với nhiều loại content
4. **Error Boundaries**: Wrap trong try-catch
5. **Performance**: Profile với Flutter Inspector

## 🔗 Tích hợp với Page System

```dart
class ArticleView extends BaseView<ArticleViewModel> {
  @override
  Widget buildWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // EditorJS Content  
          if (viewModel.article?.content != null)
            EditorJSFlutterWidgets.renderContent(
              EditorJSParser.parseFromString(viewModel.article!.content!),
              options: EditorJSRenderOptions.defaultTheme(),
            ),
            
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }
}
```

## 🌐 Localization

```dart
final vietnameseOptions = EditorJSRenderOptions(
  // Vietnamese specific styling
  paragraphStyle: TextStyle(
    fontSize: 16,
    height: 1.8, // Tăng line height cho tiếng Việt
  ),
);
```

## 📝 Notes

- Tất cả widgets đều responsive
- Hỗ trợ dark mode
- Compatible với Material Design 3
- Optimized cho performance
- Full error handling
- Vietnamese language support 