import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/product_list/model/product_model.dart';
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

  void _loadProducts() {
    _isLoading = true;
    notifyListeners();

    // Data mẫu sản phẩm với hình ảnh từ internet
    _products = _getProductsByCategory(_categoryId);
    _filteredProducts = List.from(_products);
    _applySorting();

    _isLoading = false;
    notifyListeners();
  }

  List<Product> _getProductsByCategory(String categoryId) {
    switch (categoryId) {
      case 'fire_extinguisher':
        return [
          Product(
            id: 'fe_001',
            name: 'BÌNH CHỮA CHÁY MINI VINAFOAM',
            description: 'Bình chữa cháy mini vinafoam dạng xách tay',
            imageUrl: 'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=500&h=500&fit=crop',
              'https://images.unsplash.com/photo-1585438786827-5f4e5ef8e6b6?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'mini_foam',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Dung tích', value: '1', unit: 'lít'),
              ProductSpecification(name: 'Loại', value: 'Foam', unit: ''),
            ],
          ),
          Product(
            id: 'fe_002',
            name: 'XE ĐẨY CHỮA CHÁY FOAM 50L VINAFOAM',
            description: 'Xe đẩy chữa cháy foam công nghiệp',
            imageUrl: 'https://images.unsplash.com/photo-1573686037119-0cb0dd14a513?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1573686037119-0cb0dd14a513?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'wheeled_foam',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Dung tích', value: '50', unit: 'lít'),
              ProductSpecification(name: 'Loại', value: 'Foam', unit: ''),
            ],
          ),
          Product(
            id: 'fe_003',
            name: 'XE ĐẨY CHỮA CHÁY FOAM 25L VINAFOAM',
            description: 'Xe đẩy chữa cháy foam 25L',
            imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'wheeled_foam',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Dung tích', value: '25', unit: 'lít'),
              ProductSpecification(name: 'Loại', value: 'Foam', unit: ''),
            ],
          ),
          Product(
            id: 'fe_004',
            name: 'XE ĐẨY CHỮA CHÁY BỘT ABC 35KG VINAFOAM',
            description: 'Xe đẩy chữa cháy bột ABC 35KG',
            imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'abc_powder',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Trọng lượng', value: '35', unit: 'kg'),
              ProductSpecification(name: 'Loại', value: 'ABC Powder', unit: ''),
            ],
          ),
          Product(
            id: 'fe_005',
            name: 'BÌNH CHỮA CHÁY CO2 5KG',
            description: 'Bình chữa cháy CO2 5KG chuyên dụng cho thiết bị điện',
            imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'co2_extinguisher',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Trọng lượng', value: '5', unit: 'kg'),
              ProductSpecification(name: 'Loại', value: 'CO2', unit: ''),
            ],
          ),
          Product(
            id: 'fe_006',
            name: 'BÌNH CHỮA CHÁY CO2 3KG',
            description: 'Bình chữa cháy CO2 3KG compact',
            imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=500&fit=crop',
            ],
            category: 'fire_extinguisher',
            subCategory: 'co2_extinguisher',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Trọng lượng', value: '3', unit: 'kg'),
              ProductSpecification(name: 'Loại', value: 'CO2', unit: ''),
            ],
          ),
        ];

      case 'fire_alarm':
        return [
          Product(
            id: 'fa_001',
            name: 'ĐẦU BÁO KHÓI QUANG ĐIỆN',
            description: 'Đầu báo khói quang điện thông minh',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-7e4c1c1d9c57?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1558618666-7e4c1c1d9c57?w=500&h=500&fit=crop',
            ],
            category: 'fire_alarm',
            subCategory: 'smoke_detector',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Loại', value: 'Quang điện', unit: ''),
              ProductSpecification(name: 'Điện áp', value: '12-24', unit: 'VDC'),
            ],
          ),
          Product(
            id: 'fa_002',
            name: 'ĐẦU BÁO NHIỆT ĐỊNH NHIỆT',
            description: 'Đầu báo nhiệt định nhiệt 70°C',
            imageUrl: 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop',
            ],
            category: 'fire_alarm',
            subCategory: 'heat_detector',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Nhiệt độ kích hoạt', value: '70', unit: '°C'),
              ProductSpecification(name: 'Điện áp', value: '12-24', unit: 'VDC'),
            ],
          ),
        ];

      case 'water_sprinkler':
        return [
          Product(
            id: 'ws_001',
            name: 'VÒI CHỮA CHÁY DN65',
            description: 'Vòi chữa cháy DN65 chất lượng cao',
            imageUrl: 'https://images.unsplash.com/photo-1558168632-8b5c7e6e3cb0?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1558168632-8b5c7e6e3cb0?w=500&h=500&fit=crop',
            ],
            category: 'water_sprinkler',
            subCategory: 'fire_hose',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Đường kính', value: '65', unit: 'mm'),
              ProductSpecification(name: 'Áp lực', value: '16', unit: 'bar'),
            ],
          ),
        ];

      case 'emergency_light':
        return [
          Product(
            id: 'el_001',
            name: 'ĐÈN EXIT LED 2 MẶT',
            description: 'Đèn exit LED 2 mặt tiết kiệm điện',
            imageUrl: 'https://images.unsplash.com/photo-1558168632-8b5c7e6e3cb0?w=500&h=500&fit=crop',
            images: [
              'https://images.unsplash.com/photo-1558168632-8b5c7e6e3cb0?w=500&h=500&fit=crop',
            ],
            category: 'emergency_light',
            subCategory: 'exit_light',
            priceDisplay: 'Liên hệ báo giá',
            tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
            rating: 0,
            reviewCount: 0,
            soldCount: 0,
            hasReviews: false,
            contactInfo: '0123456789',
            specifications: [
              ProductSpecification(name: 'Loại', value: 'LED', unit: ''),
              ProductSpecification(name: 'Điện áp', value: '220', unit: 'VAC'),
            ],
          ),
        ];

      default:
        return [];
    }
  }

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