import '../view/news_detail_view.dart';
import '../view_model/news_detail_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class NewsDetailPage extends PageViewController<NewsDetailPageViewModel> {
  const NewsDetailPage({super.key, required super.viewModel});

  @override
  NewsDetailPageState createState() => NewsDetailPageState();
}

class NewsDetailPageState extends PageViewControllerState<NewsDetailPage> {
  @override
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [
              VNLAppBar(
        leading: [
          VNLButton.ghost(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                // If we can't pop, navigate back to home with tab preserved
                final state = GoRouterState.of(context);
                final tabIndex = state.uri.queryParameters['tab'] ?? '0';
                context.go('/home?tab=$tabIndex');
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
        title: Text(widget.viewModel.title ?? 'Chi tiết tin tức'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return NewsDetailView(viewModel: widget.viewModel.newsDetailViewModel);
  }
} 