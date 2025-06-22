import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../model/news_model.dart';
import '../model/news_category_model.dart';

class NewsViewModel extends BaseViewModel {
  final ArticleRepository _articleRepository;
  final CategoryRepository _categoryRepository;
  
  List<NewsModel> _newsList = [];
  List<NewsModel> _filteredNewsList = [];
  List<NewsCategoryModel> _categories = [];
  String _selectedCategoryId = 'all';
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get newsList => _filteredNewsList;
  List<NewsCategoryModel> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NewsViewModel({
    required ArticleRepository articleRepository,
    required CategoryRepository categoryRepository,
  }) : _articleRepository = articleRepository,
       _categoryRepository = categoryRepository {
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
        _categories = [
          NewsCategoryModel(id: 'all', name: 'Tất cả', slug: 'all'),
          ...apiCategories.map((category) => NewsCategoryModel(
            id: category.id.toString(),
            name: category.name,
            slug: category.slug ?? '',
          )),
        ];
      } else {
        Logger.e('Failed to load categories from API: ${categoriesResponse.error?.error.message}');
        _categories = NewsCategoryModel.getDummyCategories();
      }

      // Load articles from API
      final articlesResponse = await _articleRepository.getArticles();
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
      } else {
        Logger.e('Failed to load articles from API: ${articlesResponse.error?.error.message}');
        _newsList = NewsModel.getDummyNews();
      }
      
      _filteredNewsList = _newsList;
      _errorMessage = null;
    } catch (e, stackTrace) {
      Logger.e('Error loading news data: $e\nStackTrace: $stackTrace');
      _errorMessage = 'Không thể tải dữ liệu tin tức: ${e.toString()}';
      // Use dummy data as fallback
      _categories = NewsCategoryModel.getDummyCategories();
      _newsList = NewsModel.getDummyNews();
      _filteredNewsList = _newsList;
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