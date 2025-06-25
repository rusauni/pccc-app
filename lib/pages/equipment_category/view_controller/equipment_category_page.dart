import 'package:base_app/pages/equipment_category/view/equipment_category_view.dart';
import 'package:base_app/pages/equipment_category/view_model/equipment_category_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class EquipmentCategoryPage extends PageViewController<EquipmentCategoryPageViewModel> {
  const EquipmentCategoryPage({super.key, required super.viewModel});

  @override
  EquipmentCategoryPageState createState() => EquipmentCategoryPageState();
}

class EquipmentCategoryPageState extends PageViewControllerState<EquipmentCategoryPage> {
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
        title: Text(widget.viewModel.title ?? 'Danh mục thiết bị'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return EquipmentCategoryView(
      viewModel: widget.viewModel.equipmentCategoryViewModel,
    );
  }
} 