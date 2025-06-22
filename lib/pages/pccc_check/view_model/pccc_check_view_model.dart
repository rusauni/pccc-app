import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/data/models/pccc_system_model.dart';
import 'package:base_app/data/services/pccc_analysis_service.dart';

class PCCCCheckViewModel extends BaseViewModel {
  // Dữ liệu input từ người dùng
  final PCCCInputData _inputData = PCCCInputData();
  
  // Kết quả phân tích
  List<PCCCCheckResult> _analysisResults = [];
  
  // Danh sách loại công trình
  List<BuildingType> _buildingTypes = [];
  
  // Danh sách hạng nguy hiểm cháy
  List<FireRiskCategory> _fireRiskCategories = [];
  
  // Trạng thái loading
  bool _isLoading = false;
  bool _isAnalyzing = false;
  
  // Error handling
  String? _errorMessage;

  // Getters
  PCCCInputData get inputData => _inputData;
  List<PCCCCheckResult> get analysisResults => _analysisResults;
  List<BuildingType> get buildingTypes => _buildingTypes;
  List<FireRiskCategory> get fireRiskCategories => _fireRiskCategories;
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _analysisResults.isNotEmpty;

  PCCCCheckViewModel() {
    _initializeData();
  }

  // Khởi tạo dữ liệu ban đầu
  Future<void> _initializeData() async {
    _setLoading(true);
    try {
      _buildingTypes = await PCCCAnalysisService.getBuildingTypes();
      _fireRiskCategories = await PCCCAnalysisService.getFireRiskCategories();
      
      _clearError();
    } catch (e) {
      _setError('Không thể tải dữ liệu khởi tạo: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cập nhật dữ liệu input
  void updateInputData({
    String? loaiNha,
    double? chieuCao,
    int? soTang,
    double? tongDienTichSan,
    double? khoiTich,
    String? hangNguyHiemChay,
    bool? coTangHam,
    int? soNguoiSuDung,
    bool? coPhongNgu,
    bool? coPhongOnLon,
    double? dienTichKhuVuc,
    bool? coVatCan,
    bool? khuVucKhoTiepCan,
    String? loaiBinhChuaChay,
    double? khoangCachDenTruNuocCongCong,
    bool? khaNangKetNoiNuocSinhHoat,
    bool? suDungChatKiNuoc,
    String? loaiCoSo,
    double? dienTichCoSo,
    String? loaiPhuongTienCoGioi,
    bool? viTriBoTriPhongTruc,
    bool? coKhuyenKhichMatNaLocDoc,
    bool? mucDichSuDungDacBiet,
  }) {
    if (loaiNha != null) _inputData.loaiNha = loaiNha;
    if (chieuCao != null) _inputData.chieuCao = chieuCao;
    if (soTang != null) _inputData.soTang = soTang;
    if (tongDienTichSan != null) _inputData.tongDienTichSan = tongDienTichSan;
    if (khoiTich != null) _inputData.khoiTich = khoiTich;
    if (hangNguyHiemChay != null) _inputData.hangNguyHiemChay = hangNguyHiemChay;
    if (coTangHam != null) _inputData.coTangHam = coTangHam;
    if (soNguoiSuDung != null) _inputData.soNguoiSuDung = soNguoiSuDung;
    if (coPhongNgu != null) _inputData.coPhongNgu = coPhongNgu;
    if (coPhongOnLon != null) _inputData.coPhongOnLon = coPhongOnLon;
    if (dienTichKhuVuc != null) _inputData.dienTichKhuVuc = dienTichKhuVuc;
    if (coVatCan != null) _inputData.coVatCan = coVatCan;
    if (khuVucKhoTiepCan != null) _inputData.khuVucKhoTiepCan = khuVucKhoTiepCan;
    if (loaiBinhChuaChay != null) _inputData.loaiBinhChuaChay = loaiBinhChuaChay;
    if (khoangCachDenTruNuocCongCong != null) _inputData.khoangCachDenTruNuocCongCong = khoangCachDenTruNuocCongCong;
    if (khaNangKetNoiNuocSinhHoat != null) _inputData.khaNangKetNoiNuocSinhHoat = khaNangKetNoiNuocSinhHoat;
    if (suDungChatKiNuoc != null) _inputData.suDungChatKiNuoc = suDungChatKiNuoc;
    if (loaiCoSo != null) _inputData.loaiCoSo = loaiCoSo;
    if (dienTichCoSo != null) _inputData.dienTichCoSo = dienTichCoSo;
    if (loaiPhuongTienCoGioi != null) _inputData.loaiPhuongTienCoGioi = loaiPhuongTienCoGioi;
    if (viTriBoTriPhongTruc != null) _inputData.viTriBoTriPhongTruc = viTriBoTriPhongTruc;
    if (coKhuyenKhichMatNaLocDoc != null) _inputData.coKhuyenKhichMatNaLocDoc = coKhuyenKhichMatNaLocDoc;
    if (mucDichSuDungDacBiet != null) _inputData.mucDichSuDungDacBiet = mucDichSuDungDacBiet;
    
    notifyListeners();
  }

  // Phân tích tất cả hệ thống PCCC
  Future<void> analyzeAllSystems() async {
    _setAnalyzing(true);
    try {
      _analysisResults = await PCCCAnalysisService.analyzeAllSystems(_inputData);
      _clearError();
    } catch (e) {
      _setError('Lỗi khi phân tích hệ thống PCCC: $e');
    } finally {
      _setAnalyzing(false);
    }
  }

  // Lấy gợi ý cho hệ thống cụ thể
  Future<PCCCSuggestions?> getSuggestions(String systemId) async {
    try {
      return await PCCCAnalysisService.getSuggestions(systemId);
    } catch (e) {
      return null;
    }
  }

  // Tạo báo cáo tổng hợp
  Map<String, dynamic> generateSummaryReport() {
    if (_analysisResults.isEmpty) {
      return {};
    }
    return PCCCAnalysisService.generateSummaryReport(_analysisResults);
  }

  // Reset tất cả dữ liệu
  void resetAll() {
    _inputData.loaiNha = null;
    _inputData.chieuCao = null;
    _inputData.soTang = null;
    _inputData.tongDienTichSan = null;
    _inputData.khoiTich = null;
    _inputData.hangNguyHiemChay = null;
    _inputData.coTangHam = null;
    _inputData.soNguoiSuDung = null;
    _inputData.coPhongNgu = null;
    _inputData.coPhongOnLon = null;
    _inputData.dienTichKhuVuc = null;
    _inputData.coVatCan = null;
    _inputData.khuVucKhoTiepCan = null;
    _inputData.loaiBinhChuaChay = null;
    _inputData.khoangCachDenTruNuocCongCong = null;
    _inputData.khaNangKetNoiNuocSinhHoat = null;
    _inputData.suDungChatKiNuoc = null;
    _inputData.loaiCoSo = null;
    _inputData.dienTichCoSo = null;
    _inputData.loaiPhuongTienCoGioi = null;
    _inputData.viTriBoTriPhongTruc = null;
    _inputData.coKhuyenKhichMatNaLocDoc = null;
    _inputData.mucDichSuDungDacBiet = null;
    
    _analysisResults.clear();
    _clearError();
    notifyListeners();
  }

  // Lấy kết quả theo trạng thái
  List<PCCCCheckResult> getResultsByStatus(String status) {
    return _analysisResults.where((result) => result.status == status).toList();
  }

  // Kiểm tra xem có dữ liệu đầu vào cơ bản không
  bool get hasBasicInput {
    return _inputData.loaiNha != null || 
           _inputData.chieuCao != null || 
           _inputData.tongDienTichSan != null;
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setAnalyzing(bool analyzing) {
    _isAnalyzing = analyzing;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Lấy danh sách subcategories cho building type
  List<BuildingSubcategory> getSubcategoriesForBuildingType(String buildingTypeId) {
    final buildingType = _buildingTypes.firstWhere(
      (type) => type.id == buildingTypeId,
      orElse: () => BuildingType(id: '', name: '', subcategories: []),
    );
    return buildingType.subcategories;
  }

  // Validate input data
  List<String> validateInput() {
    final errors = <String>[];
    
    if (_inputData.loaiNha == null || _inputData.loaiNha!.isEmpty) {
      errors.add('Vui lòng chọn loại công trình');
    }
    
    if (_inputData.chieuCao != null && _inputData.chieuCao! < 0) {
      errors.add('Chiều cao không thể âm');
    }
    
    if (_inputData.soTang != null && _inputData.soTang! < 0) {
      errors.add('Số tầng không thể âm');
    }
    
    if (_inputData.tongDienTichSan != null && _inputData.tongDienTichSan! < 0) {
      errors.add('Diện tích sàn không thể âm');
    }
    
    if (_inputData.khoiTich != null && _inputData.khoiTich! < 0) {
      errors.add('Khối tích không thể âm');
    }
    
    return errors;
  }

  // Export data as JSON
  Map<String, dynamic> exportData() {
    return {
      'inputData': _inputData.toJson(),
      'analysisResults': _analysisResults.map((result) => result.toJson()).toList(),
      'summaryReport': generateSummaryReport(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
} 