import 'package:base_app/pages/app_themes/theme_page.dart';
import 'package:base_app/pages/app_base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/home/view_model/home_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class HomePage extends PageViewController<HomePageViewModel> {
  const HomePage({super.key, required super.viewModel});
  @override
  HomeViewControllerState createState() {
    return HomeViewControllerState();
  }
}

class HomeViewControllerState extends PageViewControllerState<HomePage> {
  @override
  Widget buildBody(Object pageContext) {
    return FocusTraversalGroup(child: SingleChildScrollView(key: PageStorageKey("home"), child: ThemePage()));
  }
}
