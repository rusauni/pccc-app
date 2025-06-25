import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/equipment_category/view_model/equipment_category_view_model.dart';

class EquipmentCategoryPageViewModel extends PageViewModel {
  final EquipmentCategoryViewModel equipmentCategoryViewModel = EquipmentCategoryViewModel();

  EquipmentCategoryPageViewModel() {
    title = "Danh mục thiết bị";
  }
} 