import 'package:flutter/material.dart';
import 'package:base_app/pages/news/view/news_view.dart';
import 'package:base_app/pages/news/view_model/news_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../../base/view_controller/page_view_controller.dart';

class NewsPage extends PageViewController<NewsPageViewModel> {
  const NewsPage({super.key, required super.viewModel});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends PageViewControllerState<NewsPage> {
  @override
  Widget buildBody(BuildContext pageContext) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.viewModel.newsViewModel.refreshNews();
      },
      child: NewsView(viewModel: widget.viewModel.newsViewModel),
    );
  }
} 