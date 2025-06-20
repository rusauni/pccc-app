import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'news_detail_view_model.dart';

class NewsDetailPageViewModel extends PageViewModel {
  final NewsDetailViewModel newsDetailViewModel = NewsDetailViewModel();
  final int newsId;

  NewsDetailPageViewModel({required this.newsId}) {
    title = "Chi tiết tin tức";
    newsDetailViewModel.loadNewsDetail(newsId);
  }
} 