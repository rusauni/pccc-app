import 'package:base_app/pages/customer/view/customer_view.dart';
import 'package:base_app/pages/customer/view_model/customer_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../../base/view_controller/page_view_controller.dart';

class CustomerPage extends PageViewController<CustomerPageViewModel> {
  const CustomerPage({super.key, required super.viewModel});
  
  @override
  CustomerPageState createState() => CustomerPageState();
}

class CustomerPageState extends PageViewControllerState<CustomerPage> {
  @override
  Widget buildBody(BuildContext pageContext) {
    return CustomerView(viewModel: widget.viewModel.customerViewModel);
  }
} 