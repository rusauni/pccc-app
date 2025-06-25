import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/account_detail/view_model/account_detail_view_model.dart';

class AccountDetailPageViewModel extends PageViewModel {
  final AccountDetailViewModel accountDetailViewModel = AccountDetailViewModel();

  AccountDetailPageViewModel() {
    title = "Thông tin tài khoản";
  }
} 