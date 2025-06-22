import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/featured_articles_repository.dart';
import '../model/news_model.dart';
import '../model/news_category_model.dart';

class NewsViewModel extends BaseViewModel {
  final ArticleRepository _articleRepository;
  final CategoryRepository _categoryRepository;
  final FeaturedArticlesRepository _featuredArticlesRepository;
  
  List<NewsModel> _newsList = [];
  List<NewsModel> _filteredNewsList = [];
  List<NewsModel> _featuredNewsList = [];
  List<NewsCategoryModel> _categories = [];
  String _selectedCategoryId = 'all';
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get newsList => _filteredNewsList;
  List<NewsModel> get featuredNewsList => _featuredNewsList;
  List<NewsCategoryModel> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NewsViewModel({
    required ArticleRepository articleRepository,
    required CategoryRepository categoryRepository,
    required FeaturedArticlesRepository featuredArticlesRepository,
  }) : _articleRepository = articleRepository,
       _categoryRepository = categoryRepository,
       _featuredArticlesRepository = featuredArticlesRepository {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load categories from API
      final categoriesResponse = await _categoryRepository.getCategories();
      if (categoriesResponse.isSuccess && categoriesResponse.data != null) {
        final apiCategories = categoriesResponse.data!.data;
        
        // Filter out video and document categories since they have separate tabs
        final filteredCategories = apiCategories.where((category) {
          final categoryName = category.name.toLowerCase();
          final categorySlug = (category.slug ?? '').toLowerCase();
          
          // Exclude video and tài liệu categories
          return !categoryName.contains('video') && 
                 !categoryName.contains('tài liệu') &&
                 !categoryName.contains('tai lieu') &&
                 !categorySlug.contains('video') &&
                 !categorySlug.contains('tai-lieu') &&
                 !categorySlug.contains('document');
        }).toList();
        
        _categories = [
          NewsCategoryModel(id: 'all', name: 'Tất cả', slug: 'all'),
          ...filteredCategories.map((category) => NewsCategoryModel(
            id: category.id.toString(),
            name: category.name,
            slug: category.slug ?? '',
          )),
        ];
      } else {
        Logger.e('Failed to load categories from API: ${categoriesResponse.error?.error.message}');
        _errorMessage = 'Không thể tải danh mục từ máy chủ';
        _categories = [NewsCategoryModel(id: 'all', name: 'Tất cả', slug: 'all')]; // Only default category
        return; // Don't proceed if categories fail
      }

      // Load featured articles for Breaking News
      final featuredResponse = await _featuredArticlesRepository.getFeaturedArticles(
        fields: [
          'id',
          'title',
          'articles.articles_id.id',
          'articles.articles_id.title',
          'articles.articles_id.slug',
          'articles.articles_id.thumbnail',
          'articles.articles_id.date_created',
          'articles.articles_id.category.name',
          'articles.articles_id.category.slug',
          'articles.articles_id.category.id'
        ],
        limit: 5, // Get top 5 featured articles collections
      );
      
      Logger.i('Featured articles response: ${featuredResponse.isSuccess}');
      Logger.i('Featured articles data count: ${featuredResponse.data?.data.length ?? 0}');
      
      if (featuredResponse.isSuccess && featuredResponse.data != null && featuredResponse.data!.data.isNotEmpty) {
        final featuredCollections = featuredResponse.data!.data;
        
        // Parse featured articles from all collections
        List<NewsModel> allFeaturedNews = [];
        for (final featuredCollection in featuredCollections) {
          if (featuredCollection.articles != null && featuredCollection.articles!.isNotEmpty) {
            final collectionNews = featuredCollection.articles!
                .where((item) => item.articlesId != null)
                .map((item) {
                  final articleData = item.articlesId!;
                  return NewsModel(
                    id: articleData.id,
                    title: articleData.title ?? '',
                    summary: '', // Summary not included in featured articles fields
                    content: '', // Content not included in featured articles fields
                    thumbnail: articleData.thumbnail,
                    dateCreated: articleData.dateCreated,
                    slug: articleData.slug,
                    categoryId: articleData.category?.id,
                    isFeatured: true,
                    // Create category info if available
                    category: articleData.category != null 
                        ? NewsCategoryModel(
                            id: articleData.category!.id.toString(),
                            name: articleData.category!.name ?? '',
                            slug: articleData.category!.slug ?? '',
                          )
                        : null,
                  );
                })
                .toList();
            allFeaturedNews.addAll(collectionNews);
          }
        }
        
        // Remove duplicates by ID and take max 10 featured articles for carousel
        final Map<int, NewsModel> uniqueFeatured = {};
        for (final news in allFeaturedNews) {
          if (news.id != null && !uniqueFeatured.containsKey(news.id)) {
            uniqueFeatured[news.id!] = news;
          }
        }
        _featuredNewsList = uniqueFeatured.values.take(10).toList();
        
        Logger.i('Successfully loaded ${_featuredNewsList.length} featured articles from API');
      } else {
        Logger.e('Failed to load featured articles from API: ${featuredResponse.error?.error.message}');
      }

      // Load regular articles
      final articlesResponse = await _articleRepository.getArticles(
        limit: 50,
        sort: ['-date_created'],
      );
      
      Logger.i('Articles response: ${articlesResponse.isSuccess}');
      Logger.i('Articles data count: ${articlesResponse.data?.data.length ?? 0}');
      
      if (articlesResponse.isSuccess && articlesResponse.data != null) {
        final apiArticles = articlesResponse.data!.data;
        _newsList = apiArticles.map((article) => NewsModel(
          id: article.id,
          title: article.title,
          summary: article.summary ?? '',
          content: article.content ?? '',
          thumbnail: article.thumbnail,
          dateCreated: article.dateCreated,
          categoryId: article.categoryId,
          slug: article.slug,
          tags: article.tags,
        )).toList();
        Logger.i('Successfully loaded ${_newsList.length} articles from API');
        
        // If we don't have featured articles, create mock ones from regular articles
        if (_featuredNewsList.isEmpty && _newsList.isNotEmpty) {
          _featuredNewsList = _newsList.take(3).map((news) => NewsModel(
            id: news.id,
            title: news.title,
            summary: news.summary,
            content: news.content,
            thumbnail: news.thumbnail,
            dateCreated: news.dateCreated,
            categoryId: news.categoryId,
            slug: news.slug,
            tags: news.tags,
            isFeatured: true,
          )).toList();
          Logger.i('Created ${_featuredNewsList.length} mock featured articles from regular news');
        }
      } else {
        Logger.e('Failed to load articles from API: ${articlesResponse.error?.error.message}');
        _errorMessage = 'Không thể tải tin tức từ máy chủ';
        _newsList = []; // Empty list instead of dummy data
      }
      
      _filteredNewsList = _newsList;
      _errorMessage = null;
      
      Logger.i('Final featured news count: ${_featuredNewsList.length}');
      Logger.i('Final regular news count: ${_newsList.length}');
    } catch (e, stackTrace) {
      Logger.e('Error loading news data: $e\nStackTrace: $stackTrace');
      _errorMessage = 'Lỗi kết nối: ${e.toString()}';
      // NO DUMMY DATA FALLBACK - Show error instead
      _categories = [NewsCategoryModel(id: 'all', name: 'Tất cả', slug: 'all')];
      _newsList = [];
      _filteredNewsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _filterNews();
    notifyListeners();
  }

  void _filterNews() {
    if (_selectedCategoryId == 'all') {
      _filteredNewsList = _newsList;
    } else {
      _filteredNewsList = _newsList.where((news) {
        return news.categoryId?.toString() == _selectedCategoryId;
      }).toList();
    }
  }

  Future<void> refreshNews() async {
    Logger.i('Refreshing news data...');
    await _loadData();
  }

  NewsModel? getNewsById(int id) {
    try {
      return _newsList.firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }
} 