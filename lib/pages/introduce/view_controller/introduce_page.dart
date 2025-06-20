import 'package:base_app/pages/introduce/view/introduce_view.dart';
import 'package:base_app/pages/introduce/view_model/introduce_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../../app_base/view_controller/page_view_controller.dart';

class IntroducePage extends PageViewController<IntroducePageViewModel> {
  const IntroducePage({super.key, required super.viewModel});
  @override
  IntroducePageState createState() => IntroducePageState();
}

class IntroducePageState extends PageViewControllerState<IntroducePage> {
  @override
  Widget buildBody(BuildContext pageContext) {
    return IntroduceView(viewModel: widget.viewModel.introduceViewModel);
  }
}
