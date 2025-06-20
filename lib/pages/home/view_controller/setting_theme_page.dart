import 'package:base_app/pages/base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/app_themes/theme_page.dart';
import 'package:go_router/go_router.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class SettingThemePage extends PageViewController<PageViewModel> {
  const SettingThemePage({super.key, required super.viewModel});
  @override
  SettingThemePageState createState() {
    return SettingThemePageState();
  }
}

class SettingThemePageState extends PageViewControllerState<SettingThemePage> {
  @override
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [
      VNLAppBar(
        title: Text("Theme Setting"),
        leading: [
          VNLOutlineButton(
            onPressed: () {
              pageContext.pop();
            },
            density: ButtonDensity.icon,
            child: const Icon(Icons.arrow_back),
          ),
        ],
      )
    ];
  }

  @override
  Widget buildBody(Object pageContext) {
    return FocusTraversalGroup(
        child: SingleChildScrollView(
            key: PageStorageKey("home"),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ThemePage(),
            )));
  }
}
