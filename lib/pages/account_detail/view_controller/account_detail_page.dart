import 'package:base_app/pages/account_detail/view/account_detail_view.dart';
import 'package:base_app/pages/account_detail/view_model/account_detail_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../../base/view_controller/page_view_controller.dart';

class AccountDetailPage extends PageViewController<AccountDetailPageViewModel> {
  const AccountDetailPage({super.key, required super.viewModel});

  @override
  AccountDetailPageState createState() => AccountDetailPageState();
}

class AccountDetailPageState extends PageViewControllerState<AccountDetailPage> {
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
        title: Text(widget.viewModel.title ?? 'Thông tin tài khoản'),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return AccountDetailView(viewModel: widget.viewModel.accountDetailViewModel);
  }
} 