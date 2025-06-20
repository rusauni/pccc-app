import 'editor_js_models.dart';
import 'editor_js_parser.dart';

/// Utilities cho việc làm việc với EditorJS data
class EditorJSUtils {
  /// Tìm kiếm text trong các blocks
  static List<EditorJSBlock> searchBlocks(EditorJSData data, String searchText) {
    final List<EditorJSBlock> results = [];
    final searchLower = searchText.toLowerCase();
    
    for (final block in data.blocks) {
      bool found = false;
      
      switch (block.type) {
        case 'paragraph':
          final paragraphData = ParagraphBlockData.fromJson(block.data);
          if (paragraphData.text.toLowerCase().contains(searchLower)) {
            found = true;
          }
          break;
        case 'header':
          final headerData = HeaderBlockData.fromJson(block.data);
          if (headerData.text.toLowerCase().contains(searchLower)) {
            found = true;
          }
          break;
        case 'quote':
          final quoteData = QuoteBlockData.fromJson(block.data);
          if (quoteData.text.toLowerCase().contains(searchLower) ||
              (quoteData.caption?.toLowerCase().contains(searchLower) ?? false)) {
            found = true;
          }
          break;
        case 'list':
          final listData = ListBlockData.fromJson(block.data);
          for (final item in listData.items) {
            if (item.toLowerCase().contains(searchLower)) {
              found = true;
              break;
            }
          }
          break;
        case 'code':
          final codeData = CodeBlockData.fromJson(block.data);
          if (codeData.code.toLowerCase().contains(searchLower)) {
            found = true;
          }
          break;
        case 'table':
          final tableData = TableBlockData.fromJson(block.data);
          for (final row in tableData.content) {
            for (final cell in row) {
              if (cell.toLowerCase().contains(searchLower)) {
                found = true;
                break;
              }
            }
            if (found) break;
          }
          break;
        case 'checklist':
          final checklistData = ChecklistBlockData.fromJson(block.data);
          for (final item in checklistData.items) {
            if (item.text.toLowerCase().contains(searchLower)) {
              found = true;
              break;
            }
          }
          break;
        case 'warning':
          final warningData = WarningBlockData.fromJson(block.data);
          if (warningData.title.toLowerCase().contains(searchLower) ||
              warningData.message.toLowerCase().contains(searchLower)) {
            found = true;
          }
          break;
        case 'linkTool':
          final linkData = LinkToolBlockData.fromJson(block.data);
          if ((linkData.meta.title?.toLowerCase().contains(searchLower) ?? false) ||
              (linkData.meta.description?.toLowerCase().contains(searchLower) ?? false)) {
            found = true;
          }
          break;
        case 'attaches':
          final attachData = AttachesBlockData.fromJson(block.data);
          if (attachData.title?.toLowerCase().contains(searchLower) ?? false) {
            found = true;
          }
          break;
      }
      
      if (found) {
        results.add(block);
      }
    }
    
    return results;
  }

  /// Tạo EditorJSData rỗng
  static EditorJSData createEmpty() {
    return EditorJSData(
      time: DateTime.now().millisecondsSinceEpoch,
      blocks: [],
      version: '1.0.0',
    );
  }

  /// Thêm block vào EditorJSData
  static EditorJSData addBlock(EditorJSData data, EditorJSBlock block) {
    return data.copyWith(
      blocks: [...data.blocks, block],
    );
  }

  /// Xóa block theo index
  static EditorJSData removeBlockAt(EditorJSData data, int index) {
    if (index < 0 || index >= data.blocks.length) {
      return data;
    }
    
    final newBlocks = [...data.blocks];
    newBlocks.removeAt(index);
    
    return data.copyWith(blocks: newBlocks);
  }

  /// Cập nhật block theo index
  static EditorJSData updateBlockAt(EditorJSData data, int index, EditorJSBlock block) {
    if (index < 0 || index >= data.blocks.length) {
      return data;
    }
    
    final newBlocks = [...data.blocks];
    newBlocks[index] = block;
    
    return data.copyWith(blocks: newBlocks);
  }

  /// Tìm block theo ID
  static EditorJSBlock? findBlockById(EditorJSData data, String id) {
    try {
      return data.blocks.firstWhere((block) => block.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Lấy index của block theo ID
  static int? findBlockIndexById(EditorJSData data, String id) {
    for (int i = 0; i < data.blocks.length; i++) {
      if (data.blocks[i].id == id) {
        return i;
      }
    }
    return null;
  }

  /// Di chuyển block từ oldIndex đến newIndex
  static EditorJSData moveBlock(EditorJSData data, int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= data.blocks.length ||
        newIndex < 0 || newIndex >= data.blocks.length ||
        oldIndex == newIndex) {
      return data;
    }
    
    final newBlocks = [...data.blocks];
    final block = newBlocks.removeAt(oldIndex);
    newBlocks.insert(newIndex, block);
    
    return data.copyWith(blocks: newBlocks);
  }

  /// Đếm tổng số từ trong tất cả blocks
  static int countWords(EditorJSData data) {
    final texts = EditorJSParser.extractTextsFromBlocks(data);
    final allText = texts.join(' ');
    return allText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  /// Đếm tổng số ký tự trong tất cả blocks
  static int countCharacters(EditorJSData data) {
    final texts = EditorJSParser.extractTextsFromBlocks(data);
    return texts.join('').length;
  }

  /// Kiểm tra xem có block nào chứa hình ảnh không
  static bool hasImages(EditorJSData data) {
    return data.blocks.any((block) => block.type == 'image');
  }

  /// Lấy tất cả URLs của hình ảnh
  static List<String> getImageUrls(EditorJSData data) {
    final List<String> urls = [];
    
    for (final block in data.blocks) {
      if (block.type == 'image') {
        final imageData = ImageBlockData.fromJson(block.data);
        if (imageData.file.url != null && imageData.file.url!.isNotEmpty) {
          urls.add(imageData.file.url!);
        }
      }
    }
    
    return urls;
  }

  /// Lấy tất cả headers (tiêu đề)
  static List<HeaderInfo> getHeaders(EditorJSData data) {
    final List<HeaderInfo> headers = [];
    
    for (int i = 0; i < data.blocks.length; i++) {
      final block = data.blocks[i];
      if (block.type == 'header') {
        final headerData = HeaderBlockData.fromJson(block.data);
        headers.add(HeaderInfo(
          index: i,
          level: headerData.level,
          text: headerData.text,
          id: block.id,
        ));
      }
    }
    
    return headers;
  }

  /// Tạo table of contents từ headers
  static List<TocItem> generateTableOfContents(EditorJSData data) {
    final headers = getHeaders(data);
    final List<TocItem> toc = [];
    
    for (final header in headers) {
      toc.add(TocItem(
        text: header.text,
        level: header.level,
        blockIndex: header.index,
        blockId: header.id,
      ));
    }
    
    return toc;
  }

  /// Clone EditorJSData
  static EditorJSData clone(EditorJSData data) {
    final jsonMap = data.toJson();
    return EditorJSData.fromJson(jsonMap);
  }

  /// Merge hai EditorJSData
  static EditorJSData merge(EditorJSData data1, EditorJSData data2) {
    return EditorJSData(
      time: DateTime.now().millisecondsSinceEpoch,
      blocks: [...data1.blocks, ...data2.blocks],
      version: data1.version ?? data2.version,
    );
  }
}

/// Thông tin về header
class HeaderInfo {
  final int index;
  final int level;
  final String text;
  final String? id;

  HeaderInfo({
    required this.index,
    required this.level,
    required this.text,
    this.id,
  });
}

/// Item trong table of contents
class TocItem {
  final String text;
  final int level;
  final int blockIndex;
  final String? blockId;

  TocItem({
    required this.text,
    required this.level,
    required this.blockIndex,
    this.blockId,
  });
}

/// Block builders để tạo blocks mới dễ dàng
class EditorJSBlockBuilders {
  /// Tạo paragraph block
  static EditorJSBlock paragraph(String text, {String? alignment}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'paragraph',
      data: ParagraphBlockData(text: text, alignment: alignment).toJson(),
    );
  }

  /// Tạo header block
  static EditorJSBlock header(String text, int level, {String? alignment}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'header',
      data: HeaderBlockData(text: text, level: level, alignment: alignment).toJson(),
    );
  }

  /// Tạo list block
  static EditorJSBlock list(List<String> items, {String style = 'unordered'}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'list',
      data: ListBlockData(style: style, items: items).toJson(),
    );
  }

  /// Tạo quote block
  static EditorJSBlock quote(String text, {String? caption, String? alignment}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'quote',
      data: QuoteBlockData(text: text, caption: caption, alignment: alignment).toJson(),
    );
  }

  /// Tạo code block
  static EditorJSBlock code(String code) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'code',
      data: CodeBlockData(code: code).toJson(),
    );
  }

  /// Tạo delimiter block
  static EditorJSBlock delimiter() {
    return EditorJSBlock(
      id: _generateId(),
      type: 'delimiter',
      data: DelimiterBlockData().toJson(),
    );
  }

  /// Tạo image block
  static EditorJSBlock image(String url, {String? caption, bool? withBorder, bool? withBackground, bool? stretched}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'image',
      data: ImageBlockData(
        file: FileData(url: url),
        caption: caption,
        withBorder: withBorder,
        withBackground: withBackground,
        stretched: stretched,
      ).toJson(),
    );
  }

  /// Tạo table block
  static EditorJSBlock table(List<List<String>> content, {bool? withHeadings}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'table',
      data: TableBlockData(content: content, withHeadings: withHeadings).toJson(),
    );
  }

  /// Tạo embed block
  static EditorJSBlock embed(String service, String source, String embed, {int? width, int? height, String? caption}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'embed',
      data: EmbedBlockData(
        service: service,
        source: source,
        embed: embed,
        width: width,
        height: height,
        caption: caption,
      ).toJson(),
    );
  }

  /// Tạo checklist block
  static EditorJSBlock checklist(List<ChecklistItem> items) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'checklist',
      data: ChecklistBlockData(items: items).toJson(),
    );
  }

  /// Tạo warning block
  static EditorJSBlock warning(String title, String message) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'warning',
      data: WarningBlockData(title: title, message: message).toJson(),
    );
  }

  /// Tạo raw HTML block
  static EditorJSBlock raw(String html) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'raw',
      data: RawBlockData(html: html).toJson(),
    );
  }

  /// Tạo linkTool block
  static EditorJSBlock linkTool(String link, {String? title, String? description, String? image}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'linkTool',
      data: LinkToolBlockData(
        link: link,
        meta: LinkMeta(title: title, description: description, image: image),
      ).toJson(),
    );
  }

  /// Tạo attaches block
  static EditorJSBlock attaches(String url, String name, {int? size, String? extension, String? title}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'attaches',
      data: AttachesBlockData(
        file: FileData(url: url, name: name, size: size, extension: extension),
        title: title,
      ).toJson(),
    );
  }

  /// Tạo video block
  static EditorJSBlock video(String url, {String? caption}) {
    return EditorJSBlock(
      id: _generateId(),
      type: 'video',
      data: VideoBlockData(url: url, caption: caption).toJson(),
    );
  }

  static String _generateId() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch}_${now.microsecond}';
  }
} 