import 'package:base_app/pages/base/view_model/base_view_model.dart';
import '../model/news_model.dart';

class NewsDetailViewModel extends BaseViewModel {
  NewsModel? _newsDetail;
  bool _isLoading = false;
  String? _errorMessage;

  NewsModel? get newsDetail => _newsDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNewsDetail(int newsId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final dummyNews = NewsModel.getDummyNews();
      _newsDetail = dummyNews.firstWhere((news) => news.id == newsId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Không thể tải chi tiết tin tức: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 