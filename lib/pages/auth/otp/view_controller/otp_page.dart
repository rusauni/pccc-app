import 'dart:async';
import 'package:flutter/material.dart' hide CircularProgressIndicator, ButtonStyle, FilledButton, TextButton;
import 'package:base_app/pages/app_base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/auth/otp/view_model/otp_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class OtpPage extends PageViewController<OtpViewModel> {
  final String phone;
  
  const OtpPage({
    super.key, 
    required super.viewModel,
    required this.phone,
  });
  
  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends PageViewControllerState<OtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  int _resendCountdown = 60;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    widget.viewModel.setPhone(widget.phone);
    _startResendTimer();
  }
  
  void _startResendTimer() {
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
  
  @override
  Widget buildBody(Object pageContext) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            // Title
            Text(
              'Xu00e1c thu1ef1c OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // Instruction
            Text(
              'Vui lu00f2ng nhu1eadp mu00e3 OTP u0111u00e3 u0111u01b0u1ee3c gu1eedi u0111u1ebfn su1ed1 u0111iu1ec7n thou1ea1i ${widget.phone}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // OTP input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  child: VNLTextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1) {
                        // Move to next field
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          // Last field, hide keyboard
                          _focusNodes[index].unfocus();
                          // Verify OTP
                          _verifyOtp();
                        }
                      }
                    },
                    // Remove counterText parameter as it's not supported
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            // Error message
            if (widget.viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.viewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            // Verify button
            ElevatedButton(
              onPressed: widget.viewModel.isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: widget.viewModel.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text('Xu00e1c thu1ef1c'),
            ),
            SizedBox(height: 24),
            // Resend OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chu01b0a nhu1eadn u0111u01b0u1ee3c mu00e3?'),
                _resendCountdown > 0
                    ? Text(
                        ' Gu1eedi lu1ea1i sau $_resendCountdown giu00e2y',
                        style: TextStyle(color: Colors.grey),
                      )
                    : VNLTextButton(
                        onPressed: _resendOtp,
                        child: Text('Gu1eedi lu1ea1i'),
                      ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }
  
  void _verifyOtp() async {
    final otpCode = _getOtpCode();
    if (otpCode.length != 6) return;
    
    final success = await widget.viewModel.verifyOtp(otpCode);
    if (success && mounted) {
      // OTP verification successful, navigate to home
      context.go('/');
    }
  }
  
  void _resendOtp() {
    // Hiển thị trạng thái loading nếu cần
    
    // Gọi hàm resendOtp và xử lý kết quả trong then()
    widget.viewModel.resendOtp().then((success) {
      if (success && mounted) {
        _startResendTimer();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mu00e3 OTP u0111u00e3 u0111u01b0u1ee3c gu1eedi lu1ea1i')),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
