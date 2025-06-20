import '../editor_js.dart';

/// Ví dụ sử dụng EditorJS Parser
class EditorJSExample {
  /// Dữ liệu JSON mẫu từ EditorJS
  static const String sampleJsonString = '''
{
  "time": 1550476186479,
  "blocks": [
    {
      "id": "oUq2g_tl8y",
      "type": "header",
      "data": {
        "text": "Hướng dẫn sử dụng EditorJS Parser",
        "level": 1
      }
    },
    {
      "id": "zbGZFPM-iI",
      "type": "paragraph",
      "data": {
        "text": "Đây là một đoạn văn bản mô tả về cách sử dụng EditorJS Parser trong Flutter."
      }
    },
    {
      "id": "qYIGsjS5rt", 
      "type": "header",
      "data": {
        "text": "Các tính năng chính",
        "level": 2
      }
    },
    {
      "id": "XV87kJS_H1",
      "type": "list",
      "data": {
        "style": "unordered",
        "items": [
          "Parse JSON từ EditorJS",
          "Hỗ trợ nhiều loại block",
          "Type-safe với Dart models",
          "Utilities để làm việc với data"
        ]
      }
    },
    {
      "id": "cyZjplMOZ0",
      "type": "quote",
      "data": {
        "text": "EditorJS tạo ra JSON sạch thay vì HTML markup phức tạp.",
        "caption": "Tác giả EditorJS"
      }
    },
    {
      "id": "codeblock123",
      "type": "code",
      "data": {
        "code": "final data = EditorJSParser.parseFromString(jsonString);\\nprint('Tổng số blocks: \${data.blocks.length}');"
      }
    },
    {
      "id": "delimiter123",
      "type": "delimiter",
      "data": {}
    },
    {
      "id": "table123",
      "type": "table",
      "data": {
        "withHeadings": true,
        "content": [
          ["Block Type", "Mô tả"],
          ["paragraph", "Đoạn văn bản"],
          ["header", "Tiêu đề từ H1-H6"],
          ["list", "Danh sách có thứ tự hoặc không"],
          ["image", "Hình ảnh với caption"],
          ["quote", "Trích dẫn"],
          ["code", "Khối mã"],
          ["table", "Bảng dữ liệu"]
        ]
      }
    }
  ],
  "version": "2.8.1"
}
''';

  /// Ví dụ cơ bản về cách parse và sử dụng
  static void basicExample() {
    print('=== VÍ DỤ CƠ BẢN ===\n');
    
    // 1. Parse JSON string
    final editorData = EditorJSParser.parseFromString(sampleJsonString);
    print('✅ Parse thành công!');
    print('Tổng số blocks: ${editorData.blocks.length}');
    print('Version: ${editorData.version}');
    print('Time: ${DateTime.fromMillisecondsSinceEpoch(editorData.time ?? 0)}');
    
    // 2. Lấy summary
    final summary = EditorJSParser.createSummary(editorData);
    print('\n📊 SUMMARY:');
    print('- Tổng blocks: ${summary.totalBlocks}');
    print('- Có headers: ${summary.hasHeaders}');
    print('- Có images: ${summary.hasImages}');
    print('- Có tables: ${summary.hasTables}');
    print('- Có code: ${summary.hasCode}');
    print('- Block counts: ${summary.blockCounts}');
    
    // 3. Lấy các loại block
    final blockTypes = EditorJSParser.getBlockTypes(editorData);
    print('\n📝 BLOCK TYPES: ${blockTypes.join(', ')}');
  }

  /// Ví dụ làm việc với từng loại block
  static void blockTypesExample() {
    print('\n=== VÍ DỤ BLOCK TYPES ===\n');
    
    final editorData = EditorJSParser.parseFromString(sampleJsonString);
    
    for (int i = 0; i < editorData.blocks.length; i++) {
      final block = editorData.blocks[i];
      print('Block ${i + 1}: ${block.type} (ID: ${block.id})');
      
      switch (block.type) {
        case 'paragraph':
          final paragraphData = EditorJSParser.parseBlockData<ParagraphBlockData>(block);
          print('  📄 Text: "${paragraphData.text}"');
          break;
          
        case 'header':
          final headerData = EditorJSParser.parseBlockData<HeaderBlockData>(block);
          print('  📌 H${headerData.level}: "${headerData.text}"');
          break;
          
        case 'list':
          final listData = EditorJSParser.parseBlockData<ListBlockData>(block);
          print('  📋 ${listData.style} list (${listData.items.length} items):');
          for (final item in listData.items) {
            print('    - $item');
          }
          break;
          
        case 'quote':
          final quoteData = EditorJSParser.parseBlockData<QuoteBlockData>(block);
          print('  💬 Quote: "${quoteData.text}"');
          if (quoteData.caption != null) {
            print('     Caption: "${quoteData.caption}"');
          }
          break;
          
        case 'code':
          final codeData = EditorJSParser.parseBlockData<CodeBlockData>(block);
          print('  💻 Code:');
          print('     ${codeData.code}');
          break;
          
        case 'delimiter':
          print('  ➖ Delimiter');
          break;
          
        case 'table':
          final tableData = EditorJSParser.parseBlockData<TableBlockData>(block);
          print('  📊 Table (${tableData.content.length} rows):');
          for (int r = 0; r < tableData.content.length; r++) {
            final row = tableData.content[r];
            final isHeader = tableData.withHeadings == true && r == 0;
            print('     ${isHeader ? "HEADER" : "Row ${r + 1}"}: ${row.join(" | ")}');
          }
          break;
          
        default:
          print('  ❓ Unknown block type');
      }
      
      print('');
    }
  }

  /// Ví dụ utilities
  static void utilitiesExample() {
    print('\n=== VÍ DỤ UTILITIES ===\n');
    
    final editorData = EditorJSParser.parseFromString(sampleJsonString);
    
    // 1. Tìm kiếm
    final searchResults = EditorJSUtils.searchBlocks(editorData, 'EditorJS');
    print('🔍 Tìm kiếm "EditorJS": ${searchResults.length} kết quả');
    
    // 2. Đếm từ và ký tự
    final wordCount = EditorJSUtils.countWords(editorData);
    final charCount = EditorJSUtils.countCharacters(editorData);
    print('📊 Thống kê:');
    print('  - Tổng số từ: $wordCount');
    print('  - Tổng số ký tự: $charCount');
    
    // 3. Lấy headers
    final headers = EditorJSUtils.getHeaders(editorData);
    print('\n📑 Headers:');
    for (final header in headers) {
      print('  H${header.level}: "${header.text}" (index: ${header.index})');
    }
    
    // 4. Table of contents
    final toc = EditorJSUtils.generateTableOfContents(editorData);
    print('\n📚 Table of Contents:');
    for (final item in toc) {
      final indent = '  ' * (item.level - 1);
      print('${indent}- ${item.text}');
    }
    
    // 5. Lấy image URLs
    final imageUrls = EditorJSUtils.getImageUrls(editorData);
    print('\n🖼️ Image URLs: ${imageUrls.length} images');
    for (final url in imageUrls) {
      print('  - $url');
    }
  }

  /// Ví dụ tạo blocks mới
  static void buildersExample() {
    print('\n=== VÍ DỤ BLOCK BUILDERS ===\n');
    
    // Tạo EditorJSData mới
    var data = EditorJSUtils.createEmpty();
    print('✅ Tạo EditorJSData rỗng');
    
    // Thêm các blocks
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.header('Tiêu đề chính', 1));
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.paragraph('Đây là đoạn văn đầu tiên.'));
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.list(['Item 1', 'Item 2', 'Item 3']));
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.quote('Câu trích dẫn quan trọng', caption: 'Tác giả'));
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.code('print("Hello World!");'));
    data = EditorJSUtils.addBlock(data, EditorJSBlockBuilders.delimiter());
    
    print('✅ Đã thêm ${data.blocks.length} blocks');
    
    // Chuyển thành JSON
    final jsonString = EditorJSParser.toJsonString(data);
    print('\n📄 JSON output:');
    print(jsonString);
  }

  /// Ví dụ manipulation data
  static void manipulationExample() {
    print('\n=== VÍ DỤ MANIPULATION ===\n');
    
    var data = EditorJSParser.parseFromString(sampleJsonString);
    print('✅ Bắt đầu với ${data.blocks.length} blocks');
    
    // Xóa block đầu tiên
    data = EditorJSUtils.removeBlockAt(data, 0);
    print('🗑️ Xóa block đầu tiên, còn lại: ${data.blocks.length} blocks');
    
    // Thêm block mới vào đầu
    final newHeader = EditorJSBlockBuilders.header('Tiêu đề mới', 1);
    data = EditorJSData(
      time: data.time,
      blocks: [newHeader, ...data.blocks],
      version: data.version,
    );
    print('➕ Thêm header mới vào đầu, tổng: ${data.blocks.length} blocks');
    
    // Di chuyển block
    data = EditorJSUtils.moveBlock(data, 1, 3);
    print('🔄 Di chuyển block từ vị trí 1 đến 3');
    
    // Tìm block theo ID
    final firstBlock = data.blocks.first;
    final foundBlock = EditorJSUtils.findBlockById(data, firstBlock.id!);
    print('🔍 Tìm block theo ID: ${foundBlock != null ? "Tìm thấy" : "Không tìm thấy"}');
    
    // Clone data
    final clonedData = EditorJSUtils.clone(data);
    print('📋 Clone data thành công, blocks: ${clonedData.blocks.length}');
  }

  /// Chạy tất cả ví dụ
  static void runAllExamples() {
    basicExample();
    blockTypesExample();
    utilitiesExample();
    buildersExample();
    manipulationExample();
    
    print('\n🎉 Hoàn thành tất cả ví dụ!');
  }
} 