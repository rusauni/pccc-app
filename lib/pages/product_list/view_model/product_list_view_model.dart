import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/product_list/model/product_model.dart';
import 'package:base_app/utils/product_data_loader.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

enum SortOption {
  priceAscending('Giá thấp đến cao'),
  priceDescending('Giá cao đến thấp'),
  bestselling('Bán chạy nhất'),
  newest('Mới nhất'),
  mostReviewed('Nhiều đánh giá');

  const SortOption(this.displayName);
  final String displayName;
}

class ProductListViewModel extends BaseViewModel {
  bool _isLoading = false;
  String? _errorMessage;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _categoryId = '';
  SortOption _currentSort = SortOption.bestselling;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get products => _filteredProducts;
  String get categoryId => _categoryId;
  SortOption get currentSort => _currentSort;

  ProductListViewModel(String categoryId) {
    _categoryId = categoryId;
    _loadProducts();
  }

  void _loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load dữ liệu từ JSON file
      final dataLoader = ProductDataLoader();
      final mappedCategoryId = ProductDataLoader.mapCategoryIdToDataId(_categoryId);
      _products = await dataLoader.getProductsByCategory(mappedCategoryId);
      _filteredProducts = List.from(_products);
      _applySorting();
    } catch (e) {
      _errorMessage = 'Không thể tải dữ liệu sản phẩm: ${e.toString()}';
      _products = [];
      _filteredProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Data đã được chuyển sang JSON file, không cần hardcode nữa

  void setSortOption(SortOption sortOption) {
    _currentSort = sortOption;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    switch (_currentSort) {
      case SortOption.priceAscending:
        _filteredProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case SortOption.priceDescending:
        _filteredProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case SortOption.bestselling:
        _filteredProducts.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case SortOption.newest:
        // Giả sử sắp xếp theo ID (sản phẩm mới có ID cao hơn)
        _filteredProducts.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortOption.mostReviewed:
        _filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
  }

  void refreshProducts() {
    _loadProducts();
  }
} 