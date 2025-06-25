import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/product_list/view_model/product_list_view_model.dart';
import 'package:base_app/utils/product_data_loader.dart';

class ProductListPageViewModel extends PageViewModel {
  late final ProductListViewModel productListViewModel;

  ProductListPageViewModel({required String categoryId}) {
    productListViewModel = ProductListViewModel(categoryId);
    title = "Tất cả sản phẩm";
    _loadCategoryTitle(categoryId);
  }

  void _loadCategoryTitle(String categoryId) async {
    try {
      final dataLoader = ProductDataLoader();
      final mappedCategoryId = ProductDataLoader.mapCategoryIdToDataId(categoryId);
      final categoryName = await dataLoader.getCategoryName(mappedCategoryId);
      title = categoryName;
      notifyListeners();
    } catch (e) {
      // Keep default title if error
    }
  }
} 