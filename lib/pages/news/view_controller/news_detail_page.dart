import '../view/news_detail_view.dart';
import '../view_model/news_detail_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../../base/view_controller/page_view_controller.dart';

class NewsDetailPage extends PageViewController<NewsDetailPageViewModel> {
  const NewsDetailPage({super.key, required super.viewModel});

  @override
  NewsDetailPageState createState() => NewsDetailPageState();
}

class NewsDetailPageState extends PageViewControllerState<NewsDetailPage> {
  @override
  Widget buildBody(BuildContext pageContext) {
    return NewsDetailView(viewModel: widget.viewModel.newsDetailViewModel);
  }
} 