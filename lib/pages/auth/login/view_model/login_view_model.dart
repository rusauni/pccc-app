
import 'package:base_app/pages/app_base/view_model/page_view_model.dart';
import 'package:base_app/repositories/auth_repository.dart';
import 'package:gtd_helper/gtd_helper.dart';
// import 'package:gtd_helper/helper/cached/cache_helper_extension.dart'; // Không cần thiết vì đã được bao gồm trong gtd_helper.dart

class LoginViewModel extends PageViewModel {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  
  LoginViewModel() {
    title = 'Đăng nhập';
  }
  
  Future<void> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _repository.login(username, password);
      if (result) {
        // Save token to cache (using a dummy token for now)
        await CacheHelperExtension.saveData(key: 'token', value: 'dummy_token');
      }
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loginWithGoogle() async {
    // Triển khai đăng nhập với Google
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      // Giả lập đăng nhập thành công
      await Future.delayed(Duration(seconds: 1));
      await CacheHelperExtension.saveData(key: 'token', value: 'google_dummy_token');
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
