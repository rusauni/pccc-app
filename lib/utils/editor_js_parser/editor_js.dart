/// EditorJS Parser for Flutter
/// 
/// Thư viện parse dữ liệu JSON từ EditorJS thành các đối tượng Dart
/// để sử dụng trong ứng dụng Flutter.
/// 
/// EditorJS là một editor block-style tạo ra JSON sạch thay vì HTML markup.
/// 
/// Example:
/// ```dart
/// import 'package:your_app/utils/editor_js_parser/editor_js.dart';
/// 
/// // Parse từ JSON string
/// final editorData = EditorJSParser.parseFromString(jsonString);
/// 
/// // Render thành Flutter widgets
/// final widget = EditorJSFlutterWidgets.renderContent(
///   editorData,
///   options: EditorJSRenderOptions.defaultTheme(),
/// );
/// 
/// // Lấy summary
/// final summary = EditorJSParser.createSummary(editorData);
/// 
/// // Lọc blocks theo type
/// final paragraphs = EditorJSParser.filterBlocksByType(editorData, 'paragraph');
/// 
/// // Parse từng block cụ thể
/// for (final block in editorData.blocks) {
///   switch (block.type) {
///     case 'paragraph':
///       final paragraphData = EditorJSParser.parseBlockData<ParagraphBlockData>(block);
///       print(paragraphData.text);
///       break;
///     case 'header':
///       final headerData = EditorJSParser.parseBlockData<HeaderBlockData>(block);
///       print('H${headerData.level}: ${headerData.text}');
///       break;
///   }
/// }
/// ```

library editor_js;

// Export models
export 'editor_js_models.dart';

// Export parser
export 'editor_js_parser.dart';

// Export utilities
export 'editor_js_utils.dart';

// Export Flutter widgets
export 'editor_js_flutter_widgets.dart'; 