import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/equipment_category/model/equipment_category_model.dart';
import 'package:base_app/utils/product_data_loader.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class EquipmentCategoryViewModel extends BaseViewModel {
  bool _isLoading = false;
  String? _errorMessage;
  List<EquipmentCategory> _categories = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<EquipmentCategory> get categories => _categories;

  EquipmentCategoryViewModel() {
    _loadCategories();
  }

  void _loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load dữ liệu từ JSON file
      final dataLoader = ProductDataLoader();
      _categories = await _loadCategoriesFromJson(dataLoader);
    } catch (e) {
      _errorMessage = 'Không thể tải dữ liệu danh mục: ${e.toString()}';
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<EquipmentCategory>> _loadCategoriesFromJson(ProductDataLoader dataLoader) async {
    final jsonData = await dataLoader.loadJsonData();
    final categories = jsonData['categories'] as List<dynamic>? ?? [];
    
    return categories.map<EquipmentCategory>((categoryJson) {
      final products = categoryJson['products'] as List<dynamic>? ?? [];
      
      return EquipmentCategory(
        id: _mapDataIdToCategoryId(categoryJson['id'] ?? ''),
        name: categoryJson['name'] ?? '',
        description: categoryJson['description'] ?? '',
        iconData: _getIconForCategory(categoryJson['id'] ?? ''),
        color: _getColorForCategory(categoryJson['id'] ?? ''),
        subCategories: _createSubCategoriesFromProducts(products),
      );
    }).toList();
  }

  String _mapDataIdToCategoryId(String dataId) {
    switch (dataId) {
      case 'fe_001':
        return 'fire_extinguisher';
      case 'fd_001':
        return 'fire_alarm';
      case 'hr_001':
        return 'fire_hose';
      case 'el_001':
        return 'emergency_light';
      case 'pw_001':
        return 'fire_pump';
      default:
        return dataId;
    }
  }

  String _getIconForCategory(String dataId) {
    switch (dataId) {
      case 'fe_001':
        return 'water_drop';
      case 'fd_001':
        return 'notifications';
      case 'hr_001':
        return 'water';
      case 'el_001':
        return 'lightbulb';
      case 'pw_001':
        return 'settings';
      default:
        return 'category';
    }
  }

  String _getColorForCategory(String dataId) {
    switch (dataId) {
      case 'fe_001':
        return 'red';
      case 'fd_001':
        return 'orange';
      case 'hr_001':
        return 'blue';
      case 'el_001':
        return 'yellow';
      case 'pw_001':
        return 'green';
      default:
        return 'gray';
    }
  }

  List<EquipmentSubCategory> _createSubCategoriesFromProducts(List<dynamic> products) {
    // Nhóm sản phẩm theo type để tạo subcategories
    final Map<String, List<dynamic>> groupedProducts = {};
    
    for (final product in products) {
      final type = product['type'] ?? 'Khác';
      if (!groupedProducts.containsKey(type)) {
        groupedProducts[type] = [];
      }
      groupedProducts[type]!.add(product);
    }

    return groupedProducts.entries.map((entry) {
      return EquipmentSubCategory(
        id: entry.key.toLowerCase().replaceAll(' ', '_'),
        name: entry.key,
        description: 'Sản phẩm loại ${entry.key}',
        productCount: entry.value.length,
      );
    }).toList();
  }

  // Data mẫu cũ - giữ lại để fallback
  List<EquipmentCategory> _getBackupCategories() {
    return [
      EquipmentCategory(
        id: 'fire_extinguisher',
        name: 'Bình chữa cháy',
        description: 'Các loại bình chữa cháy ABC, CO2, bột khô',
        iconData: 'water_drop',
        color: 'red',
        subCategories: [
          EquipmentSubCategory(
            id: 'mini_foam',
            name: 'Bình chữa cháy mini vinafoam',
            description: 'Bình chữa cháy nhỏ gọn',
            productCount: 15,
          ),
          EquipmentSubCategory(
            id: 'wheeled_foam',
            name: 'Xe đẩy chữa cháy foam',
            description: 'Xe đẩy chữa cháy công nghiệp',
            productCount: 8,
          ),
          EquipmentSubCategory(
            id: 'abc_powder',
            name: 'Bình chữa cháy bột ABC',
            description: 'Bình chữa cháy đa năng',
            productCount: 12,
          ),
          EquipmentSubCategory(
            id: 'co2_extinguisher',
            name: 'Bình chữa cháy CO2',
            description: 'Chuyên dụng cho thiết bị điện',
            productCount: 6,
          ),
        ],
      ),
      EquipmentCategory(
        id: 'fire_alarm',
        name: 'Thiết bị báo cháy',
        description: 'Đầu báo khói, nhiệt, nút nhấn báo cháy',
        iconData: 'notifications',
        color: 'orange',
        subCategories: [
          EquipmentSubCategory(
            id: 'smoke_detector',
            name: 'Đầu báo khói',
            description: 'Phát hiện khói cháy sớm',
            productCount: 20,
          ),
          EquipmentSubCategory(
            id: 'heat_detector',
            name: 'Đầu báo nhiệt',
            description: 'Cảm biến nhiệt độ cao',
            productCount: 15,
          ),
          EquipmentSubCategory(
            id: 'manual_call_point',
            name: 'Nút nhấn báo cháy',
            description: 'Báo cháy thủ công',
            productCount: 10,
          ),
          EquipmentSubCategory(
            id: 'fire_bell',
            name: 'Chuông báo cháy',
            description: 'Thiết bị cảnh báo âm thanh',
            productCount: 8,
          ),
        ],
      ),
      EquipmentCategory(
        id: 'water_sprinkler',
        name: 'Vòi chữa cháy',
        description: 'Vòi chữa cháy, cuộn vòi, làng phun',
        iconData: 'water',
        color: 'blue',
        subCategories: [
          EquipmentSubCategory(
            id: 'fire_hose',
            name: 'Vòi chữa cháy',
            description: 'Vòi chữa cháy các loại',
            productCount: 25,
          ),
          EquipmentSubCategory(
            id: 'hose_reel',
            name: 'Cuộn vòi chữa cháy',
            description: 'Hệ thống cuộn vòi tự động',
            productCount: 12,
          ),
          EquipmentSubCategory(
            id: 'sprinkler_head',
            name: 'Đầu phun sprinkler',
            description: 'Đầu phun tự động',
            productCount: 30,
          ),
          EquipmentSubCategory(
            id: 'fire_nozzle',
            name: 'Vòi phun chữa cháy',
            description: 'Vòi phun áp lực cao',
            productCount: 18,
          ),
        ],
      ),
      EquipmentCategory(
        id: 'emergency_light',
        name: 'Đèn thoát hiểm',
        description: 'Đèn Exit, đèn sự cố, đèn chiếu sáng',
        iconData: 'lightbulb',
        color: 'yellow',
        subCategories: [
          EquipmentSubCategory(
            id: 'exit_light',
            name: 'Đèn Exit',
            description: 'Đèn chỉ lối thoát',
            productCount: 22,
          ),
          EquipmentSubCategory(
            id: 'emergency_light',
            name: 'Đèn sự cố',
            description: 'Đèn chiếu sáng khẩn cấp',
            productCount: 16,
          ),
          EquipmentSubCategory(
            id: 'path_light',
            name: 'Đèn chiếu sáng lối đi',
            description: 'Đèn dẫn đường thoát hiểm',
            productCount: 14,
          ),
          EquipmentSubCategory(
            id: 'battery_light',
            name: 'Đèn dự phòng pin',
            description: 'Đèn tích điện tự động',
            productCount: 10,
          ),
        ],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void refreshCategories() {
    _loadCategories();
  }

  EquipmentCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
} 