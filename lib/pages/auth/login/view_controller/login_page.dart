import 'package:flutter/material.dart'
    hide
        TextField,
        ElevatedButton,
        OutlinedButton,
        TextButton,
        IconButton,
        Icon,
        CircularProgressIndicator,
        ButtonStyle;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:base_app/pages/base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/auth/login/view_model/login_page_view_model.dart';
import 'package:base_app/pages/auth/login/view/login_view.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter/services.dart'; // Không cần thiết vì đã được bao gồm trong material.dart

class LoginPage extends PageViewController<LoginPageViewModel> {
  const LoginPage({super.key, required super.viewModel});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends PageViewControllerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _obscurePassword = true; // Không thể là final vì cần thay đổi khi người dùng nhấn nút hiển thị/ẩn mật khẩu

  @override
  Widget buildBody(BuildContext pageContext) {
    return LoginView(viewModel: widget.viewModel.loginViewModel);
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            // Logo
            Center(
              child: Icon(BootstrapIcons.google),
            ),
            SizedBox(height: 40),
            // Title
            Text(
              'Đăng nhập',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            // Username field
            VNLTextField(
              controller: _usernameController,
              placeholder: Text('Tên đăng nhập'),
              features: [InputFeature.leading(Icon(Icons.person))],
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            // Password field
            VNLTextField(
              controller: _passwordController,
              placeholder: Text('Mật khẩu'),
              features: [InputFeature.leading(Icon(Icons.lock)), InputFeature.passwordToggle()],
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),
            ),
            SizedBox(height: 8),
            // Forgot password button
            Align(
              alignment: Alignment.centerRight,
              child: VNLButton(
                style: ButtonStyle.ghost(),
                onPressed: () {
                  // Navigate to forgot password page
                  context.push('/auth/forgot-password');
                },
                child: Text('Quên mật khẩu?'),
              ),
            ),
            SizedBox(height: 24),
            // Error message
            if (widget.viewModel.loginViewModel.errorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.viewModel.loginViewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            // Login button
            VNLButton(
              style: ButtonStyle.primary(),
              onPressed: widget.viewModel.loginViewModel.isLoading ? null : _login,
              child: widget.viewModel.loginViewModel.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text('\u0110\u0103ng nh\u1eadp'),
            ),
            SizedBox(height: 16),
            // Google login button
            VNLButton(
              style: ButtonStyle.outline(),
              onPressed: widget.viewModel.loginViewModel.isLoading ? null : _loginWithGoogle,
              child: widget.viewModel.loginViewModel.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(BootstrapIcons.google),
                        SizedBox(width: 8),
                        Text('Đăng nhập với Google'),
                      ],
                    ),
            ),
            SizedBox(height: 32),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chưa có tài khoản?'),
                VNLButton(
                  style: ButtonStyle.ghost(),
                  onPressed: () => context.go('/auth/register'),
                  child: Text('Đăng ký ngay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    await widget.viewModel.loginViewModel.login(
      _usernameController.text,
      _passwordController.text,
    );
    // If no error message, consider login successful
    if (widget.viewModel.loginViewModel.errorMessage == null && mounted) {
      context.go('/');
    }
  }

  void _loginWithGoogle() async {
    await widget.viewModel.loginViewModel.loginWithGoogle();
    // If no error message, consider login successful
    if (widget.viewModel.loginViewModel.errorMessage == null && mounted) {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
