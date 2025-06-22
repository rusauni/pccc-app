class UrlHelper {
  static const String _baseAssetsUrl = 'https://dashboard.pccc40.com/assets/';

  /// Convert a thumbnail path to full URL if needed
  /// If the path is already a full URL (starts with http/https), return as is
  /// Otherwise, prepend the base assets URL
  static String? formatThumbnailUrl(String? thumbnail) {
    if (thumbnail == null || thumbnail.isEmpty) {
      return null;
    }

    // If already a full URL, return as is
    if (thumbnail.startsWith('http://') || thumbnail.startsWith('https://')) {
      return thumbnail;
    }

    // Otherwise, prepend base assets URL
    return '$_baseAssetsUrl$thumbnail';
  }

  /// Format asset URL for any file type
  static String? formatAssetUrl(String? assetPath) {
    return formatThumbnailUrl(assetPath);
  }
} 