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
    return cleanUrl.endsWith('.pdf') || 
           cleanUrl.contains('.pdf') ||
           cleanUrl.contains('pdf');
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
} 