import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/auth/login/view_model/login_view_model.dart';

class LoginPageViewModel extends PageViewModel {
  final LoginViewModel loginViewModel = LoginViewModel();

  LoginPageViewModel() {
    title = "Login";
  }
} 