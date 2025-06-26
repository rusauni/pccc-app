import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/api_client/base_api_client.dart';
import '../../../data/api_client/pccc_environment.dart';
import '../model/news_model.dart';
import '../model/news_category_model.dart';

class NewsDetailViewModel extends BaseViewModel {
  final ArticleRepository _articleRepository;
  final CategoryRepository _categoryRepository;
  
  NewsModel? _newsDetail;
  bool _isLoading = false;
  String? _errorMessage;
  String? _categorySlug; // Store category slug for share URL

  NewsModel? get newsDetail => _newsDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get categorySlug => _categorySlug;

  NewsDetailViewModel() : 
    _articleRepository = _createArticleRepository(),
    _categoryRepository = _createCategoryRepository();

  static ArticleRepository _createArticleRepository() {
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
    );
    return ArticleRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );
  }

  static CategoryRepository _createCategoryRepository() {
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
    );
    return CategoryRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );
  }

  Future<void> loadNewsDetail(int newsId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load article from API
      final response = await _articleRepository.getArticle(newsId);
      
      if (response.isSuccess && response.data != null) {
        final article = response.data!.data;
        
        try {
          _newsDetail = NewsModel(
            id: article.id,
            title: article.title,
            summary: article.summary ?? '',
            content: article.content ?? '',
            thumbnail: article.thumbnail, // Already formatted by ArticleModel.fromJson()
            dateCreated: article.dateCreated,
            categoryId: article.categoryId,
            slug: article.slug,
            tags: article.tags,
          );
          
          // Load category slug if categoryId exists
          if (article.categoryId != null) {
            await _loadCategorySlug(article.categoryId!);
          }
          
          Logger.i('Successfully created NewsModel from ArticleModel');
        } catch (modelError) {
          Logger.e('Error creating NewsModel from ArticleModel: $modelError');
          Logger.e('Article data: ${article.toJson()}');
          rethrow; // Re-throw to be caught by outer catch
        }
      } else {
        Logger.e('Failed to load article detail from API: ${response.error?.error.message}');
        _errorMessage = 'Không thể tải chi tiết tin tức từ máy chủ';
        
        // Fallback to dummy data if API fails
        final dummyNews = NewsModel.getDummyNews();
        _newsDetail = dummyNews.firstWhere(
          (news) => news.id == newsId,
          orElse: () => dummyNews.first,
        );
      }
    } catch (e) {
      Logger.e('Exception loading news detail: $e');
      _errorMessage = 'Không thể tải chi tiết tin tức: ${e.toString()}';
      
      // Fallback to dummy data if exception occurs
      try {
        final dummyNews = NewsModel.getDummyNews();
        _newsDetail = dummyNews.firstWhere(
          (news) => news.id == newsId,
          orElse: () => dummyNews.first,
        );
      } catch (fallbackError) {
        Logger.e('Fallback to dummy data also failed: $fallbackError');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCategorySlug(int categoryId) async {
    try {
      final response = await _categoryRepository.getCategories();
      if (response.isSuccess && response.data != null) {
        final categories = response.data!.data;
        final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => throw Exception('Category not found'),
        );
        _categorySlug = category.slug;
        Logger.i('Category slug loaded: $_categorySlug');
      }
    } catch (e) {
      Logger.e('Error loading category slug: $e');
      // Continue without category slug - will fallback in share URL
    }
  }
} 