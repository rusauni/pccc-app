import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'news_view_model.dart';

class NewsPageViewModel extends PageViewModel {
  final NewsViewModel newsViewModel = NewsViewModel();

  NewsPageViewModel() {
    title = "Tin tức nổi bật";
  }
} 