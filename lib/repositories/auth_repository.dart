import 'package:gtd_helper/gtd_helper.dart';
import 'package:gtd_helper/helper/cached/cache_helper_extension.dart';

class AuthRepository {
  Future<bool> login(String username, String password) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    if (username == 'admin' && password == 'password') {
      // Lưu token vào SharedPreferences
      await CacheHelperExtension.saveData(key: 'token', value: 'dummy_token');
      return true;
    }
    
    throw Exception('Sai tên đăng nhập hoặc mật khẩu');
  }
  
  Future<bool> register(RegisterModel model) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    return true;
  }
  
  Future<bool> verifyOtp(String phone, String otp) async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy check
    if (otp == '123456') {
      return true;
    }
    
    throw Exception('Mã OTP không đúng');
  }
}

class RegisterModel {
  final String username;
  final String password;
  final String email;
  final String phone;
  
  RegisterModel({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });
  
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'phone': phone,
      };
}

class OtpModel {
  final String phone;
  final String otp;
  
  OtpModel({required this.phone, required this.otp});
  
  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}
