import 'dart:convert';
import 'lib/utils/editor_js_parser/editor_js_models.dart';
import 'lib/utils/editor_js_parser/editor_js_flutter_widgets.dart';

void main() {
  // JSON sample từ user
  final jsonString = '''
  {
    "id": "2aC87aarnd",
    "type": "image",
    "data": {
      "caption": "",
      "withBorder": false,
      "withBackground": false,
      "stretched": false,
      "file": {
        "width": 960,
        "height": 696,
        "size": "158262",
        "name": "1.jpg",
        "title": "1",
        "extension": "jpg",
        "fileId": "c7c5a221-7ccd-48c8-88fa-d02da5bf2851",
        "fileURL": "/files/c7c5a221-7ccd-48c8-88fa-d02da5bf2851",
        "url": "/assets/c7c5a221-7ccd-48c8-88fa-d02da5bf2851"
      }
    }
  }
  ''';

  // Parse JSON
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  final EditorJSBlock block = EditorJSBlock.fromJson(jsonData);
  
  // Test ImageBlockData parsing
  final ImageBlockData imageData = ImageBlockData.fromJson(block.data);
  
  print('Block ID: ${block.id}');
  print('Block Type: ${block.type}');
  print('File URL: ${imageData.file.url}');
  print('File URL (fallback): ${imageData.file.fileURL}');
  print('File Name: ${imageData.file.name}');
  print('File Size: ${imageData.file.size}');
  print('File Width: ${imageData.file.width}');
  print('File Height: ${imageData.file.height}');
  print('File Title: ${imageData.file.title}');
  print('File ID: ${imageData.file.fileId}');
  print('Caption: ${imageData.caption}');
  print('With Border: ${imageData.withBorder}');
  
  // Test URL processing (simulate the logic from widgets)
  final originalUrl = imageData.file.url ?? imageData.file.fileURL;
  print('Original URL: $originalUrl');
  
  // Simulate URL processing (can't call _processUrl directly as it's private)
  String processedUrl = '';
  if (originalUrl != null && originalUrl.isNotEmpty) {
    final Uri? uri = Uri.tryParse(originalUrl);
    if (uri != null && uri.hasScheme) {
      processedUrl = originalUrl;
    } else {
      const String baseDomain = 'https://dashboard.pccc40.com';
      if (originalUrl.startsWith('/')) {
        processedUrl = '$baseDomain$originalUrl';
      } else {
        processedUrl = '$baseDomain/assets/$originalUrl';
      }
    }
  }
  
  print('Processed URL: $processedUrl');
  print('Expected: https://dashboard.pccc40.com/assets/c7c5a221-7ccd-48c8-88fa-d02da5bf2851');
  print('Match: ${processedUrl == "https://dashboard.pccc40.com/assets/c7c5a221-7ccd-48c8-88fa-d02da5bf2851"}');
} 