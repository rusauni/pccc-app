// No need for material import
import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/repositories/auth_repository.dart';
import 'package:gtd_helper/gtd_helper.dart';

class OtpViewModel extends BaseViewModel {
  final _repository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  String phone = '';
  
  OtpViewModel();
  
  void setPhone(String phone) {
    this.phone = phone;
  }
  
  Future<bool> verifyOtp(String otp) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _repository.verifyOtp(phone, otp);
      return result;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> resendOtp() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      // Giả lập gửi lại OTP
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      errorMessage = ErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
