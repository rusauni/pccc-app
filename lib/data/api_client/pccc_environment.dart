import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import 'package:dio/dio.dart';

enum PcccEnvironmentType { development, staging, production }

class PcccEnvironment extends BaseEnvironment {
  static const String _devBaseUrl = 'dashboard.pccc40.com';
  static const String _stagingBaseUrl = 'dashboard.pccc40.com';
  static const String _prodBaseUrl = 'dashboard.pccc40.com';

  PcccEnvironment._({
    required String baseUrl,
    required String platformPath,
    required Map<String, String> headers,
  }) : super(
         baseUrl: baseUrl,
         platformPath: platformPath,
         headers: headers,
       );

  // Environment types for PCCC API
  static PcccEnvironment development() {
    return PcccEnvironment._(
      baseUrl: _devBaseUrl,
      platformPath: '',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PCCC-Mobile-App/1.0.0-dev',
      },
    );
  }

  static PcccEnvironment staging() {
    return PcccEnvironment._(
      baseUrl: _stagingBaseUrl,
      platformPath: '',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PCCC-Mobile-App/1.0.0-staging',
      },
    );
  }

  static PcccEnvironment production() {
    return PcccEnvironment._(
      baseUrl: _prodBaseUrl,
      platformPath: '',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PCCC-Mobile-App/1.0.0',
      },
    );
  }
}

// PCCC API Endpoints
class PcccEndpoints {
  // Base paths
  static const String items = 'items';
  static const String assets = 'assets';
  static const String api = 'api';

  // Items endpoints
  static const String articles = '$items/articles';
  static const String documents = '$items/documents';
  static const String categories = '$items/categories';
  static const String subCategories = '$items/sub_category';
  static const String documentTypes = '$items/document_type';
  static const String issuingAgencies = '$items/issuing_agency';
  static const String featuredArticles = '$items/featured_articles';
  static const String featuredArticlesArticles = '$items/featured_articles_articles';

  // API endpoints
  static const String chat = '$api/chat';

  // Helper methods for single item endpoints
  static String articleById(int id) => '$articles/$id';
  static String documentById(int id) => '$documents/$id';
  static String categoryById(int id) => '$categories/$id';
  static String subCategoryById(int id) => '$subCategories/$id';
  static String documentTypeById(int id) => '$documentTypes/$id';
  static String issuingAgencyById(int id) => '$issuingAgencies/$id';
  static String featuredArticleById(int id) => '$featuredArticles/$id';
  static String assetById(String id) => '$assets/$id';

  // File download with transformations
  static String assetWithTransforms(String id, {
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
    
    return queryString.isEmpty ? assetById(id) : '${assetById(id)}?$queryString';
  }
} 