import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:base_app/pages/base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/auth/register/view_model/register_page_view_model.dart';
import 'package:base_app/pages/auth/register/view/register_view.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends PageViewController<RegisterPageViewModel> {
  const RegisterPage({super.key, required super.viewModel});
  
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends PageViewControllerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  Widget buildBody(BuildContext pageContext) {
    return RegisterView(viewModel: widget.viewModel.registerViewModel);
  }

  Widget _buildRegisterForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            // Title
            Text(
              'Đăng ký tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            // Username
            VNLTextField(
              controller: _usernameController,
              placeholder: Text('Tên đăng nhập'),
              features: [InputFeature.leading(Icon(Icons.person))],
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            // Email
            VNLTextField(
              controller: _emailController,
              placeholder: Text('Email'),
              features: [InputFeature.leading(Icon(Icons.email))],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            // Phone
            VNLTextField(
              controller: _phoneController,
              placeholder: Text('Số điện thoại'),
              features: [InputFeature.leading(Icon(Icons.phone))],
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            // Password
            VNLTextField(
              controller: _passwordController,
              placeholder: Text('Mật khẩu'),
              features: [
                InputFeature.leading(Icon(Icons.lock)),
                InputFeature.passwordToggle()
              ],
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            // Confirm Password
            VNLTextField(
              controller: _confirmPasswordController,
              placeholder: Text('Xác nhận mật khẩu'),
              features: [
                InputFeature.leading(Icon(Icons.lock_outline)),
                InputFeature.passwordToggle()
              ],
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _register(),
            ),
            SizedBox(height: 24),
            // Error message
            if (widget.viewModel.registerViewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.viewModel.registerViewModel.errorMessage!,
                  style: TextStyle(color: VNLTheme.of(context).colorScheme.destructive),
                  textAlign: TextAlign.center,
                ),
              ),
            // Register button
            VNLButton(
              style: ButtonStyle.primary(),
              onPressed: widget.viewModel.registerViewModel.isLoading ? null : _register,
              child: widget.viewModel.registerViewModel.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text('Đăng ký'),
            ),
            SizedBox(height: 24),
            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản?'),
                VNLButton(
                  style: ButtonStyle.ghost(),
                  onPressed: () => context.go('/auth/login'),
                  child: Text('Đăng nhập ngay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _register() async {
    // Basic validation
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      return;
    }
    
    await widget.viewModel.registerViewModel.register(
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );
    
    // If no error message, consider registration successful
    if (widget.viewModel.registerViewModel.errorMessage == null && mounted) {
      context.go('/auth/otp', extra: _phoneController.text);
    }
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
