import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/customer/view_model/customer_view_model.dart';

class CustomerPageViewModel extends PageViewModel {
  final CustomerViewModel customerViewModel = CustomerViewModel();
  
  CustomerPageViewModel() {
    title = "Customer";
  }
} 