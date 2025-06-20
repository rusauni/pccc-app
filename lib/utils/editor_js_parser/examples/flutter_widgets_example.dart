import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:vnl_common_ui/vnl_ui.dart';
import '../editor_js.dart';

/// Example cho việc sử dụng EditorJS Flutter Widgets
class EditorJSFlutterExample extends StatefulWidget {
  const EditorJSFlutterExample({super.key});

  @override
  State<EditorJSFlutterExample> createState() => _EditorJSFlutterExampleState();
}

class _EditorJSFlutterExampleState extends State<EditorJSFlutterExample> {
  EditorJSData? editorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    try {
      // Tạo dữ liệu mẫu với tất cả block types
      editorData = _createSampleEditorData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Lỗi tải dữ liệu: $e');
    }
  }

  EditorJSData _createSampleEditorData() {
    final blocks = [
      // Header
      EditorJSBlockBuilders.header('EditorJS Flutter Widgets Demo', 1),
      
      // Paragraph
      EditorJSBlockBuilders.paragraph(
        'Đây là ví dụ demo về cách sử dụng EditorJS Flutter Widgets để render các block types khác nhau. '
        'Các widget được tạo bằng cách sử dụng vnl_common_ui package.',
      ),
      
      // Warning
      EditorJSBlockBuilders.warning(
        'Lưu ý quan trọng',
        'Đây là example trong môi trường development. Trong production, bạn nên validate dữ liệu từ server.',
      ),
      
      // Header level 2
      EditorJSBlockBuilders.header('Các loại block được hỗ trợ', 2),
      
      // Unordered list
      EditorJSBlockBuilders.list([
        'Paragraph - Đoạn văn bản thông thường',
        'Header - Tiêu đề các cấp độ H1-H6',
        'List - Danh sách có thứ tự và không thứ tự',
        'Quote - Trích dẫn với border bên trái',
        'Code - Block code với syntax highlighting',
        'Image - Hình ảnh với caption',
        'Table - Bảng dữ liệu',
        'Delimiter - Dòng phân cách',
      ]),
      
      // Quote
      EditorJSBlockBuilders.quote(
        'EditorJS tạo ra JSON sạch thay vì HTML markup, giúp việc parse và render trở nên dễ dàng hơn.',
        caption: 'EditorJS Team',
      ),
      
      // Code block
      EditorJSBlockBuilders.code('''
// Sử dụng EditorJSFlutterWidgets
final widget = EditorJSFlutterWidgets.renderContent(
  editorData,
  options: EditorJSRenderOptions.defaultTheme(),
);

// Custom styling
final customOptions = EditorJSRenderOptions(
  blockSpacing: 20.0,
  paragraphStyle: TextStyle(fontSize: 18),
  quoteAccentColor: Colors.blue,
);
      '''),
      
      // Table
      EditorJSBlockBuilders.table([
        ['Block Type', 'Mô tả', 'Widget'],
        ['paragraph', 'Đoạn văn bản', 'Text()'],
        ['header', 'Tiêu đề', 'Text() với style lớn'],
        ['list', 'Danh sách', 'Column với bullets'],
        ['image', 'Hình ảnh', 'Image.network()'],
      ], withHeadings: true),
      
      // Delimiter
      EditorJSBlockBuilders.delimiter(),
      
      // Header level 3
      EditorJSBlockBuilders.header('Block types mới', 3),
      
      // Checklist
      EditorJSBlockBuilders.checklist([
        ChecklistItem(text: 'Embed - Nhúng video, iframe', checked: true),
        ChecklistItem(text: 'Checklist - Danh sách có checkbox', checked: true),
        ChecklistItem(text: 'Warning - Thông báo cảnh báo', checked: true),
        ChecklistItem(text: 'LinkTool - Card preview link', checked: false),
        ChecklistItem(text: 'Attaches - File đính kèm', checked: false),
        ChecklistItem(text: 'Video - Video player', checked: false),
        ChecklistItem(text: 'Raw HTML - HTML content', checked: false),
      ]),
      
      // LinkTool example
      EditorJSBlockBuilders.linkTool(
        'https://editorjs.io/',
        title: 'EditorJS - Block-style editor',
        description: 'A block-styled editor for rich media stories, outputs clean data in JSON instead of heavy HTML-markup.',
        image: 'https://editorjs.io/assets/codex-logo.svg',
      ),
      
      // Embed example (YouTube)
      EditorJSBlockBuilders.embed(
        'youtube',
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        '<iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe>',
        caption: 'Video demo từ YouTube',
      ),
      
      // Image example
      EditorJSBlockBuilders.image(
        'https://picsum.photos/800/400',
        caption: 'Hình ảnh mẫu từ Lorem Picsum',
        withBorder: true,
      ),
      
      // File attachment example
      EditorJSBlockBuilders.attaches(
        'https://example.com/document.pdf',
        'Tài liệu hướng dẫn.pdf',
        size: 1024 * 1024 * 2, // 2MB
        extension: 'pdf',
        title: 'Tài liệu hướng dẫn sử dụng',
      ),
      
      // Video example
      EditorJSBlockBuilders.video(
        'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        caption: 'Video demo',
      ),
      
      // Raw HTML example
      EditorJSBlockBuilders.raw(
        '<div style="background: linear-gradient(45deg, #ff6b6b, #4ecdc4); padding: 20px; border-radius: 8px; color: white; text-align: center;"><h3>Custom HTML Content</h3><p>Đây là nội dung HTML tùy chỉnh được nhúng trong EditorJS.</p></div>',
      ),
      
      // Final paragraph
      EditorJSBlockBuilders.paragraph(
        'Trên đây là tất cả các block types được hỗ trợ bởi EditorJS Flutter Widgets. '
        'Bạn có thể tùy chỉnh styling thông qua EditorJSRenderOptions.',
      ),
    ];

    return EditorJSData(
      time: DateTime.now().millisecondsSinceEpoch,
      blocks: blocks,
      version: '2.28.0',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditorJS Flutter Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : editorData == null
              ? const Center(
                  child: Text(
                    'Không thể tải dữ liệu',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Summary card
                      _buildSummaryCard(),
                      
                      // Content
                      EditorJSFlutterWidgets.renderContent(
                        editorData!,
                        options: EditorJSRenderOptions.defaultTheme(),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRenderOptions,
        icon: const Icon(Icons.settings),
        label: const Text('Tùy chọn'),
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (editorData == null) return const SizedBox.shrink();
    
    final summary = EditorJSParser.createSummary(editorData!);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Thống kê nội dung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatRow('Tổng số blocks', '${summary.totalBlocks}'),
          _buildStatRow('Số từ', '${EditorJSUtils.countWords(editorData!)}'),
          _buildStatRow('Số ký tự', '${EditorJSUtils.countCharacters(editorData!)}'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: summary.blockCounts.entries.map((entry) {
              return Chip(
                label: Text('${entry.key}: ${entry.value}'),
                backgroundColor: Colors.blue[100],
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRenderOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tùy chọn render',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme mặc định'),
              subtitle: const Text('Sử dụng styling mặc định'),
              onTap: () {
                Navigator.pop(context);
                _applyRenderOptions(EditorJSRenderOptions.defaultTheme());
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font lớn'),
              subtitle: const Text('Tăng kích thước font'),
              onTap: () {
                Navigator.pop(context);
                _applyRenderOptions(_createLargeFontOptions());
              },
            ),
            ListTile(
              leading: const Icon(Icons.compress),
              title: const Text('Compact'),
              subtitle: const Text('Giảm khoảng cách giữa các blocks'),
              onTap: () {
                Navigator.pop(context);
                _applyRenderOptions(_createCompactOptions());
              },
            ),
          ],
        ),
      ),
    );
  }

  EditorJSRenderOptions _createLargeFontOptions() {
    return EditorJSRenderOptions(
      blockSpacing: 20.0,
      paragraphStyle: const TextStyle(fontSize: 18, height: 1.7),
      h1Style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, height: 1.3),
      h2Style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.3),
      h3Style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
      listStyle: const TextStyle(fontSize: 18, height: 1.6),
      quoteStyle: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, height: 1.7),
      codeStyle: const TextStyle(fontFamily: 'Courier', fontSize: 16),
    );
  }

  EditorJSRenderOptions _createCompactOptions() {
    return EditorJSRenderOptions(
      blockSpacing: 8.0,
      blockPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      paragraphStyle: const TextStyle(fontSize: 14, height: 1.4),
      h1Style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
      h2Style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
      h3Style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
      listItemSpacing: 4.0,
    );
  }

  void _applyRenderOptions(EditorJSRenderOptions options) {
    // In a real app, you would update the state and re-render
    setState(() {
      // Force rebuild with new options
    });
  }
}

/// Widget đơn giản để demo việc sử dụng EditorJS
class SimpleEditorJSWidget extends StatelessWidget {
  final String jsonString;
  final EditorJSRenderOptions? options;

  const SimpleEditorJSWidget({
    super.key,
    required this.jsonString,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final editorData = EditorJSParser.parseFromString(jsonString);
      return EditorJSFlutterWidgets.renderContent(
        editorData,
        options: options ?? EditorJSRenderOptions.defaultTheme(),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lỗi parse EditorJS',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
} 