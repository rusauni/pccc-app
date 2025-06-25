import 'package:http/http.dart' as http;

class UrlHelper {
  static const String baseUrl = 'https://dashboard.pccc40.com/assets';
  
  /// Fix URL by adding base URL if missing
  static String fixUrl(String url) {
    if (url.isEmpty) return '';
    
    // If already has protocol, return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // If it's a file ID (UUID format), build asset URL
    if (_isValidUUID(url)) {
      return '$baseUrl/$url';
    }
    
    // If starts with /, add base URL
    if (url.startsWith('/')) {
      return 'https://dashboard.pccc40.com$url';
    }
    
    // Otherwise add base URL with /
    return '$baseUrl/$url';
  }
  
  /// Check if URL is PDF file
  static bool isPdfFile(String url) {
    if (url.isEmpty) return false;
    
    // Check if file extension is PDF
    final cleanUrl = url.toLowerCase();
    if (cleanUrl.endsWith('.pdf') || 
        cleanUrl.contains('.pdf') ||
        cleanUrl.contains('pdf')) {
      return true;
    }
    
    // For UUID-based URLs (no extension), assume it could be PDF
    // The actual check will be done via HTTP Content-Type
    if (_isValidUUID(url.split('/').last)) {
      return true;
    }
    
    return false;
  }
  
  /// Check if URL is a supported document file (PDF, DOCX, XLSX, PPTX)
  static bool isSupportedDocument(String url) {
    if (url.isEmpty) return false;
    
    final cleanUrl = url.toLowerCase();
    final supportedExtensions = [
      '.pdf', 'pdf',
      '.docx', 'docx', '.doc', 'doc',
      '.xlsx', 'xlsx', '.xls', 'xls',
      '.pptx', 'pptx', '.ppt', 'ppt'
    ];
    
    for (final ext in supportedExtensions) {
      if (cleanUrl.endsWith(ext) || cleanUrl.contains(ext)) {
        return true;
      }
    }
    
    // For UUID-based URLs, assume it could be a supported document
    if (_isValidUUID(url.split('/').last)) {
      return true;
    }
    
    return false;
  }
  
  /// Extract filename from URL
  static String getFileName(String url) {
    if (url.isEmpty) return 'document';
    
    try {
      // If it's a UUID, return generic name
      if (_isValidUUID(url)) {
        return 'document.pdf';
      }
      
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      }
      return 'document.pdf';
    } catch (e) {
      return 'document.pdf';
    }
  }
  
  /// Extract file extension from URL
  static String getFileExtension(String url) {
    if (url.isEmpty) return 'pdf';
    
    try {
      // For UUIDs, assume PDF
      if (_isValidUUID(url)) {
        return 'pdf';
      }
      
      final fileName = getFileName(url);
      final lastDot = fileName.lastIndexOf('.');
      if (lastDot != -1 && lastDot < fileName.length - 1) {
        return fileName.substring(lastDot + 1).toLowerCase();
      }
      return 'pdf'; // Default to PDF
    } catch (e) {
      return 'pdf';
    }
  }
  
  /// Check if string is a valid UUID format
  static bool _isValidUUID(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    );
    return uuidRegex.hasMatch(value);
  }
  
  /// Build asset download URL with optional transformations
  static String buildAssetUrl(String fileId, {
    String? key,
    String? transforms,
    bool download = false,
  }) {
    final queryParams = <String, String>{};
    if (key != null) queryParams['key'] = key;
    if (transforms != null) queryParams['transforms'] = transforms;
    if (download) queryParams['download'] = 'true';

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    final baseAssetUrl = '$baseUrl/$fileId';
    return queryString.isEmpty ? baseAssetUrl : '$baseAssetUrl?$queryString';
  }
  
  /// Format thumbnail URL for images
  static String formatThumbnailUrl(String? thumbnail) {
    if (thumbnail == null || thumbnail.isEmpty) return '';
    return fixUrl(thumbnail);
  }
  
  /// Check if URL points to a PDF file by checking Content-Type header
  static Future<bool> isPdfFileByContentType(String url) async {
    try {
      // Use http package for HEAD request
      final response = await http.head(Uri.parse(url));
      
      final contentType = response.headers['content-type'];
      if (contentType != null) {
        return contentType.contains('application/pdf');
      }
      
      // If no content-type, fallback to URL check
      return isPdfFile(url);
    } catch (e) {
      // If HTTP check fails, fallback to URL check
      return isPdfFile(url);
    }
  }
  
  /// Check document type by Content-Type header
  static Future<DocumentType> getDocumentTypeByContentType(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      final contentType = response.headers['content-type']?.toLowerCase();
      
      if (contentType != null) {
        if (contentType.contains('application/pdf')) {
          return DocumentType.pdf;
        } else if (contentType.contains('application/vnd.openxmlformats-officedocument.wordprocessingml.document') ||
                   contentType.contains('application/msword')) {
          return DocumentType.docx;
        } else if (contentType.contains('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') ||
                   contentType.contains('application/vnd.ms-excel')) {
          return DocumentType.xlsx;
        } else if (contentType.contains('application/vnd.openxmlformats-officedocument.presentationml.presentation') ||
                   contentType.contains('application/vnd.ms-powerpoint')) {
          return DocumentType.pptx;
        }
      }
      
      // Fallback to extension-based detection
      return getDocumentTypeFromUrl(url);
    } catch (e) {
      return getDocumentTypeFromUrl(url);
    }
  }
  
  /// Get document type from URL extension
  static DocumentType getDocumentTypeFromUrl(String url) {
    final extension = getFileExtension(url).toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return DocumentType.pdf;
      case 'docx':
      case 'doc':
        return DocumentType.docx;
      case 'xlsx':
      case 'xls':
        return DocumentType.xlsx;
      case 'pptx':
      case 'ppt':
        return DocumentType.pptx;
      default:
        return DocumentType.unknown;
    }
  }

  /// Extract file ID from URL
  /// For URLs like: https://dashboard.pccc40.com/assets/90295149-642c-4e89-899c-7055861d14b3
  /// Returns: 90295149-642c-4e89-899c-7055861d14b3
  static String? extractFileIdFromUrl(String url) {
    // If URL is just a UUID, return it
    if (_isValidUUID(url)) {
      return url;
    }
    
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      // Look for assets path and get the next segment (file ID)
      for (int i = 0; i < pathSegments.length; i++) {
        if (pathSegments[i] == 'assets' && i + 1 < pathSegments.length) {
          final fileId = pathSegments[i + 1];
          // Remove query params and verify it's a UUID format
          final cleanFileId = fileId.split('?').first;
          if (_isValidUUID(cleanFileId)) {
            return cleanFileId;
          }
        }
      }
      
      // If no assets path found, check if last segment is UUID
      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last.split('?').first; // Remove query params
        if (_isValidUUID(lastSegment)) {
          return lastSegment;
        }
      }
    } catch (e) {
      // If parsing fails, try regex extraction
      final uuidRegex = RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}', caseSensitive: false);
      final match = uuidRegex.firstMatch(url);
      if (match != null) {
        return match.group(0);
      }
    }
    
    return null;
  }
}

enum DocumentType {
  pdf,
  docx,
  xlsx,
  pptx,
  unknown;
  
  String get displayName {
    switch (this) {
      case DocumentType.pdf:
        return 'PDF';
      case DocumentType.docx:
        return 'Word';
      case DocumentType.xlsx:
        return 'Excel';
      case DocumentType.pptx:
        return 'PowerPoint';
      case DocumentType.unknown:
        return 'Tài liệu';
    }
  }
  
  String get mimeType {
    switch (this) {
      case DocumentType.pdf:
        return 'application/pdf';
      case DocumentType.docx:
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case DocumentType.xlsx:
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case DocumentType.pptx:
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case DocumentType.unknown:
        return 'application/octet-stream';
    }
  }
} 