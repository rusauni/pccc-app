import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/auth/otp/view_model/otp_view_model.dart';

class OtpPageViewModel extends PageViewModel {
  final OtpViewModel otpViewModel = OtpViewModel();

  OtpPageViewModel() {
    title = "OTP";
  }
} 