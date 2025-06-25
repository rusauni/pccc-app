import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/search/view_model/search_view_model.dart';

class SearchPageViewModel extends PageViewModel {
  final SearchViewModel searchViewModel = SearchViewModel.create();

  SearchPageViewModel() {
    title = "Tìm kiếm";
  }
} 