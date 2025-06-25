import 'package:base_app/pages/product_list/view/product_list_view.dart';
import 'package:base_app/pages/product_list/view_model/product_list_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class ProductListPage extends PageViewController<ProductListPageViewModel> {
  const ProductListPage({super.key, required super.viewModel});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends PageViewControllerState<ProductListPage> {
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
        title: Text(widget.viewModel.title ?? 'Sản phẩm'),
        trailing: [
          VNLButton.ghost(
            onPressed: () {
              // Show menu or more options
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return ProductListView(
      viewModel: widget.viewModel.productListViewModel,
    );
  }
} 