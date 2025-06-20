import 'package:base_app/pages/base/view_model/base_view_model.dart';
import '../model/news_model.dart';
import '../model/news_category_model.dart';

class NewsViewModel extends BaseViewModel {
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

  NewsViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _categories = NewsCategoryModel.getDummyCategories();
      _newsList = NewsModel.getDummyNews();
      _filteredNewsList = _newsList;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Không thể tải dữ liệu tin tức: ${e.toString()}';
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
        return news.category?.id == _selectedCategoryId;
      }).toList();
    }
  }

  Future<void> refreshNews() async {
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