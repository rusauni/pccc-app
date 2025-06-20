// No need for material import
import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/repositories/auth_repository.dart';
import 'package:gtd_helper/gtd_helper.dart';

class RegisterViewModel extends BaseViewModel {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  
  RegisterViewModel();
  
  Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String phone,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final model = RegisterModel(
        username: username,
        password: password,
        email: email,
        phone: phone,
      );
      
      final result = await _repository.register(model);
      return result;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
