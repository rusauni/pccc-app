import 'package:base_app/pages/theme_setting/view/theme_setting_view.dart';
import 'package:base_app/pages/theme_setting/view_model/theme_setting_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class ThemeSettingPage extends PageViewController<ThemeSettingPageViewModel> {
  const ThemeSettingPage({super.key, required super.viewModel});

  @override
  ThemeSettingPageState createState() => ThemeSettingPageState();
}

class ThemeSettingPageState extends PageViewControllerState<ThemeSettingPage> {
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
        title: Text(widget.viewModel.title ?? 'Cài đặt giao diện'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return ThemeSettingView(viewModel: widget.viewModel.themeSettingViewModel);
  }
} 