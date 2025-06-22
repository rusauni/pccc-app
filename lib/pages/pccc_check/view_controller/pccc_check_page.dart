import 'package:base_app/pages/pccc_check/view/pccc_check_view.dart';
import 'package:base_app/pages/pccc_check/view_model/pccc_check_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class PCCCCheckPage extends PageViewController<PCCCCheckPageViewModel> {
  const PCCCCheckPage({super.key, required super.viewModel});

  @override
  PCCCCheckPageState createState() => PCCCCheckPageState();
}

class PCCCCheckPageState extends PageViewControllerState<PCCCCheckPage> {
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
                // If we can't pop, navigate to home instead
                context.go('/home');
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
        title: Text(widget.viewModel.title ?? 'Công cụ kiểm tra PCCC'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return PCCCCheckView(viewModel: widget.viewModel.pcccCheckViewModel);
  }
} 