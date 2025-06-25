import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/equipment_category/model/equipment_category_model.dart';
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

  void _loadCategories() {
    _isLoading = true;
    notifyListeners();

    // Data mẫu cho các danh mục thiết bị PCCC
    _categories = [
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