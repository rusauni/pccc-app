import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/account_detail/model/account_detail_model.dart';
import 'package:flutter/material.dart';

class AccountDetailViewModel extends BaseViewModel {
  AccountDetailModel? _accountDetail;
  bool _isLoading = false;
  bool _isEditing = false;
  String? _errorMessage;

  // Controllers for form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  String _selectedGender = 'Nam';

  AccountDetailModel? get accountDetail => _accountDetail;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  String? get errorMessage => _errorMessage;
  String get selectedGender => _selectedGender;

  List<String> get genderOptions => ['Nam', 'Nữ', 'Khác'];

  AccountDetailViewModel() {
    _loadAccountDetail();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      _populateControllers();
    }
    notifyListeners();
  }

  void _populateControllers() {
    if (_accountDetail != null) {
      fullNameController.text = _accountDetail!.fullName;
      emailController.text = _accountDetail!.email;
      phoneController.text = _accountDetail!.phoneNumber;
      addressController.text = _accountDetail!.address;
      dateOfBirthController.text = _accountDetail!.dateOfBirth;
      occupationController.text = _accountDetail!.occupation;
      companyController.text = _accountDetail!.company;
      _selectedGender = _accountDetail!.gender.isNotEmpty ? _accountDetail!.gender : 'Nam';
    }
  }

  Future<void> _loadAccountDetail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call - replace with actual repository call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - replace with actual data from API
      _accountDetail = AccountDetailModel(
        fullName: 'Nguyễn Văn An',
        email: 'nguyenvanan@example.com',
        phoneNumber: '+84 123 456 789',
        address: 'Số 123, Đường ABC, Quận 1, TP.HCM',
        dateOfBirth: '15/03/1990',
        gender: 'Nam',
        occupation: 'Kỹ sư PCCC',
        company: 'Công ty TNHH An Toàn PCCC',
      );
      
      _populateControllers();
    } catch (e) {
      _errorMessage = 'Có lỗi xảy ra khi tải thông tin tài khoản';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveAccountDetail() async {
    if (!_validateForm()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create updated model
      final updatedAccount = AccountDetailModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        dateOfBirth: dateOfBirthController.text.trim(),
        gender: _selectedGender,
        occupation: occupationController.text.trim(),
        company: companyController.text.trim(),
      );

      // Simulate API call - replace with actual repository call
      await Future.delayed(const Duration(seconds: 1));
      
      _accountDetail = updatedAccount;
      _isEditing = false;
      
      return true;
    } catch (e) {
      _errorMessage = 'Có lỗi xảy ra khi lưu thông tin';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _validateForm() {
    if (fullNameController.text.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập họ và tên';
      notifyListeners();
      return false;
    }
    
    if (emailController.text.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập email';
      notifyListeners();
      return false;
    }
    
    if (phoneController.text.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập số điện thoại';
      notifyListeners();
      return false;
    }
    
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    occupationController.dispose();
    companyController.dispose();
    super.dispose();
  }
} 