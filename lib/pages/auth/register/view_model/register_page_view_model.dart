import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/auth/register/view_model/register_view_model.dart';

class RegisterPageViewModel extends PageViewModel {
  final RegisterViewModel registerViewModel = RegisterViewModel();

  RegisterPageViewModel() {
    title = "Register";
  }
} 