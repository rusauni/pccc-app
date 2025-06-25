import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/product_list/view_model/product_list_view_model.dart';

class ProductListPageViewModel extends PageViewModel {
  late final ProductListViewModel productListViewModel;

  ProductListPageViewModel({required String categoryId}) {
    productListViewModel = ProductListViewModel(categoryId);
    title = "Tất cả sản phẩm";
  }
} 