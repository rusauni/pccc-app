import 'dart:convert';
import 'editor_js_models.dart';

/// Parser chính cho dữ liệu EditorJS
class EditorJSParser {
  /// Parse chuỗi JSON thành đối tượng EditorJSData
  static EditorJSData parseFromString(String jsonString) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return EditorJSData.fromJson(jsonMap);
    } catch (e) {
      throw EditorJSParseException('Lỗi parse JSON: $e');
    }
  }

  /// Parse Map thành đối tượng EditorJSData
  static EditorJSData parseFromMap(Map<String, dynamic> jsonMap) {
    try {
      return EditorJSData.fromJson(jsonMap);
    } catch (e) {
      throw EditorJSParseException('Lỗi parse Map: $e');
    }
  }

  /// Chuyển đổi EditorJSData thành chuỗi JSON
  static String toJsonString(EditorJSData data) {
    try {
      return json.encode(data.toJson());
    } catch (e) {
      throw EditorJSParseException('Lỗi chuyển đổi thành JSON: $e');
    }
  }

  /// Parse một block cụ thể theo type
  static T parseBlockData<T>(EditorJSBlock block) {
    switch (block.type) {
      case 'paragraph':
        return ParagraphBlockData.fromJson(block.data) as T;
      case 'header':
        return HeaderBlockData.fromJson(block.data) as T;
      case 'list':
        return ListBlockData.fromJson(block.data) as T;
      case 'image':
        return ImageBlockData.fromJson(block.data) as T;
      case 'quote':
        return QuoteBlockData.fromJson(block.data) as T;
      case 'code':
        return CodeBlockData.fromJson(block.data) as T;
      case 'delimiter':
        return DelimiterBlockData.fromJson(block.data) as T;
      case 'table':
        return TableBlockData.fromJson(block.data) as T;
      case 'embed':
        return EmbedBlockData.fromJson(block.data) as T;
      case 'checklist':
        return ChecklistBlockData.fromJson(block.data) as T;
      case 'warning':
        return WarningBlockData.fromJson(block.data) as T;
      case 'raw':
        return RawBlockData.fromJson(block.data) as T;
      case 'linkTool':
        return LinkToolBlockData.fromJson(block.data) as T;
      case 'attaches':
        return AttachesBlockData.fromJson(block.data) as T;
      case 'video':
        return VideoBlockData.fromJson(block.data) as T;
      default:
        throw EditorJSParseException('Loại block không được hỗ trợ: ${block.type}');
    }
  }

  /// Validate cấu trúc EditorJS cơ bản
  static bool validateStructure(Map<String, dynamic> jsonMap) {
    try {
      // Kiểm tra có blocks array không
      if (!jsonMap.containsKey('blocks') || jsonMap['blocks'] is! List) {
        return false;
      }

      final blocks = jsonMap['blocks'] as List;
      
      // Kiểm tra từng block có type và data không
      for (final block in blocks) {
        if (block is! Map<String, dynamic>) return false;
        if (!block.containsKey('type') || !block.containsKey('data')) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Lấy danh sách các loại block có trong dữ liệu
  static List<String> getBlockTypes(EditorJSData data) {
    return data.blocks.map((block) => block.type).toSet().toList();
  }

  /// Lọc blocks theo type
  static List<EditorJSBlock> filterBlocksByType(EditorJSData data, String type) {
    return data.blocks.where((block) => block.type == type).toList();
  }

  /// Đếm số lượng blocks theo type
  static Map<String, int> countBlocksByType(EditorJSData data) {
    final Map<String, int> counts = {};
    for (final block in data.blocks) {
      counts[block.type] = (counts[block.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Tạo summary từ dữ liệu EditorJS
  static EditorJSSummary createSummary(EditorJSData data) {
    final blockCounts = countBlocksByType(data);
    
    return EditorJSSummary(
      totalBlocks: data.blocks.length,
      blockCounts: blockCounts,
      hasImages: blockCounts.containsKey('image'),
      hasTables: blockCounts.containsKey('table'),
      hasCode: blockCounts.containsKey('code'),
      hasHeaders: blockCounts.containsKey('header'),
      hasLists: blockCounts.containsKey('list'),
      hasQuotes: blockCounts.containsKey('quote'),
      hasEmbeds: blockCounts.containsKey('embed'),
      hasChecklists: blockCounts.containsKey('checklist'),
      hasWarnings: blockCounts.containsKey('warning'),
      hasAttaches: blockCounts.containsKey('attaches'),
      hasVideos: blockCounts.containsKey('video'),
    );
  }

  /// Lấy tất cả text từ các blocks (hữu ích cho search)
  static List<String> extractTextsFromBlocks(EditorJSData data) {
    final List<String> texts = [];
    
    for (final block in data.blocks) {
      switch (block.type) {
        case 'paragraph':
          final paragraphData = ParagraphBlockData.fromJson(block.data);
          if (paragraphData.text.isNotEmpty) {
            texts.add(paragraphData.text);
          }
          break;
        case 'header':
          final headerData = HeaderBlockData.fromJson(block.data);
          if (headerData.text.isNotEmpty) {
            texts.add(headerData.text);
          }
          break;
        case 'quote':
          final quoteData = QuoteBlockData.fromJson(block.data);
          if (quoteData.text.isNotEmpty) {
            texts.add(quoteData.text);
          }
          if (quoteData.caption != null && quoteData.caption!.isNotEmpty) {
            texts.add(quoteData.caption!);
          }
          break;
        case 'list':
          final listData = ListBlockData.fromJson(block.data);
          texts.addAll(listData.items.where((item) => item.isNotEmpty));
          break;
        case 'code':
          final codeData = CodeBlockData.fromJson(block.data);
          if (codeData.code.isNotEmpty) {
            texts.add(codeData.code);
          }
          break;
        case 'image':
          final imageData = ImageBlockData.fromJson(block.data);
          if (imageData.caption != null && imageData.caption!.isNotEmpty) {
            texts.add(imageData.caption!);
          }
          break;
        case 'table':
          final tableData = TableBlockData.fromJson(block.data);
          for (final row in tableData.content) {
            texts.addAll(row.where((cell) => cell.isNotEmpty));
          }
          break;
        case 'checklist':
          final checklistData = ChecklistBlockData.fromJson(block.data);
          texts.addAll(checklistData.items.map((item) => item.text).where((text) => text.isNotEmpty));
          break;
        case 'warning':
          final warningData = WarningBlockData.fromJson(block.data);
          if (warningData.title.isNotEmpty) {
            texts.add(warningData.title);
          }
          if (warningData.message.isNotEmpty) {
            texts.add(warningData.message);
          }
          break;
        case 'linkTool':
          final linkData = LinkToolBlockData.fromJson(block.data);
          if (linkData.meta.title != null && linkData.meta.title!.isNotEmpty) {
            texts.add(linkData.meta.title!);
          }
          if (linkData.meta.description != null && linkData.meta.description!.isNotEmpty) {
            texts.add(linkData.meta.description!);
          }
          break;
        case 'attaches':
          final attachData = AttachesBlockData.fromJson(block.data);
          if (attachData.title != null && attachData.title!.isNotEmpty) {
            texts.add(attachData.title!);
          }
          break;
        case 'video':
          final videoData = VideoBlockData.fromJson(block.data);
          if (videoData.caption != null && videoData.caption!.isNotEmpty) {
            texts.add(videoData.caption!);
          }
          break;
        case 'embed':
          final embedData = EmbedBlockData.fromJson(block.data);
          if (embedData.caption != null && embedData.caption!.isNotEmpty) {
            texts.add(embedData.caption!);
          }
          break;
      }
    }
    
    return texts;
  }
}

/// Thông tin tóm tắt về dữ liệu EditorJS
class EditorJSSummary {
  final int totalBlocks;
  final Map<String, int> blockCounts;
  final bool hasImages;
  final bool hasTables;
  final bool hasCode;
  final bool hasHeaders;
  final bool hasLists;
  final bool hasQuotes;
  final bool hasEmbeds;
  final bool hasChecklists;
  final bool hasWarnings;
  final bool hasAttaches;
  final bool hasVideos;

  EditorJSSummary({
    required this.totalBlocks,
    required this.blockCounts,
    required this.hasImages,
    required this.hasTables,
    required this.hasCode,
    required this.hasHeaders,
    required this.hasLists,
    required this.hasQuotes,
    required this.hasEmbeds,
    required this.hasChecklists,
    required this.hasWarnings,
    required this.hasAttaches,
    required this.hasVideos,
  });

  @override
  String toString() {
    return 'EditorJSSummary(totalBlocks: $totalBlocks, blockTypes: ${blockCounts.keys.toList()})';
  }
}

/// Exception cho các lỗi parse EditorJS
class EditorJSParseException implements Exception {
  final String message;
  
  EditorJSParseException(this.message);
  
  @override
  String toString() => 'EditorJSParseException: $message';
} 