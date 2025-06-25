import 'package:base_app/pages/search/view/search_view.dart';
import 'package:base_app/pages/search/view_model/search_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class SearchPage extends PageViewController<SearchPageViewModel> {
  const SearchPage({super.key, required super.viewModel});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends PageViewControllerState<SearchPage> {
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
                context.go('/home');
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
        title: Text(widget.viewModel.title ?? 'Tìm kiếm'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return SearchView(
      viewModel: widget.viewModel.searchViewModel,
    );
  }
} 