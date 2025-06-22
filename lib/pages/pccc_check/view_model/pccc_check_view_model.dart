import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/pccc_check/model/pccc_check_model.dart';

class PCCCCheckViewModel extends BaseViewModel {
  // Các hệ thống kiểm tra
  final List<PCCCSystemCheck> _systems = [
    PCCCSystemCheck(
      id: 'auto_fire_suppression',
      name: 'Hệ Thống Chữa Cháy Tự Động',
      parameters: {
        'loaiNha': null,
        'chieuCao': null,
        'tongDienTichSan': null,
        'khoiTich': null,
        'hangNguyHiemChay': null,
        'tiLePhongCanCC': null,
        'coHangMucDacBiet': false,
      },
    ),
    PCCCSystemCheck(
      id: 'auto_fire_alarm',
      name: 'Hệ Thống Báo Cháy Tự Động',
      parameters: {
        'loaiNha': null,
        'chieuCao': null,
        'soTang': null,
        'dienTichSan': null,
        'khoiTich': null,
        'coTangHam': false,
        'hangNguyHiemChay': null,
        'choPhepThayTheCucBo': false,
      },
    ),
    PCCCSystemCheck(
      id: 'external_water_supply',
      name: 'Hệ Thống Cấp Nước Chữa Cháy Ngoài Nhà',
      parameters: {
        'khoangCachNguonCap': null,
        'luuLuongCapNuoc': null,
        'truLuongCapNuoc': null,
        'coHeThongNuocNgoaiNha': false,
        'ketHopCapNuocSinhHoat': false,
        'loaiNha': null,
      },
    ),
    PCCCSystemCheck(
      id: 'internal_hydrant',
      name: 'Hệ Thống Họng Nước Chữa Cháy Trong Nhà',
      parameters: {
        'loaiNha': null,
        'chieuCao': null,
        'hangNguyHiemChay': null,
        'coTangHam': false,
        'suDungChatKiNuoc': false,
        'yeuCauDuyTriApSuat': false,
      },
    ),
    PCCCSystemCheck(
      id: 'initial_fire_equipment',
      name: 'Thiết Bị Chữa Cháy Ban Đầu',
      parameters: {
        'dienTichKhuVuc': null,
        'coVatCan': false,
        'loaiNha': null,
        'khuVucNgotNgach': false,
        'loaiBinhChuaChay': null,
      },
    ),
    PCCCSystemCheck(
      id: 'escape_notification',
      name: 'Thiết Bị Thoát Nạn & Thông Báo',
      parameters: {
        'loaiNha': null,
        'soNguoiSuDung': null,
        'coPhongNgu': false,
        'coPhongOnLon': false,
      },
    ),
    PCCCSystemCheck(
      id: 'mechanical_vehicles',
      name: 'Phương Tiện Chữa Cháy Cơ Giới',
      parameters: {
        'loaiCoSo': null,
        'dienTichCoSo': null,
        'loaiPhuongTienCoGioi': null,
      },
    ),
    PCCCSystemCheck(
      id: 'demolition_masks',
      name: 'Thiết Bị Phá Dỡ Thô Sơ & Mặt Nạ Phòng Độc',
      parameters: {
        'loaiNha': null,
        'viTriBoTriPhongTruc': null,
        'coKhuyenKhichMatNaLocDoc': false,
      },
    ),
  ];

  List<PCCCSystemCheck> get systems => _systems;

  PCCCCheckViewModel();

  // Cập nhật parameter cho hệ thống
  void updateSystemParameter(String systemId, String paramKey, dynamic value) {
    final systemIndex = _systems.indexWhere((s) => s.id == systemId);
    if (systemIndex != -1) {
      final system = _systems[systemIndex];
      final updatedParameters = Map<String, dynamic>.from(system.parameters);
      updatedParameters[paramKey] = value;
      
      _systems[systemIndex] = system.copyWith(parameters: updatedParameters);
      notifyListeners();
    }
  }

  // Phân tích hệ thống
  void analyzeSystem(String systemId) {
    final systemIndex = _systems.indexWhere((s) => s.id == systemId);
    if (systemIndex != -1) {
      final system = _systems[systemIndex];
      final result = _performAnalysis(system);
      
      _systems[systemIndex] = system.copyWith(result: result);
      notifyListeners();
    }
  }

  // Reset hệ thống
  void resetSystem(String systemId) {
    final systemIndex = _systems.indexWhere((s) => s.id == systemId);
    if (systemIndex != -1) {
      final system = _systems[systemIndex];
      final resetParameters = <String, dynamic>{};
      
      // Reset tất cả parameters về null hoặc false
      system.parameters.forEach((key, value) {
        if (value is bool) {
          resetParameters[key] = false;
        } else {
          resetParameters[key] = null;
        }
      });
      
      _systems[systemIndex] = system.copyWith(
        parameters: resetParameters,
        result: null,
      );
      notifyListeners();
    }
  }

  // Reset tất cả
  void resetAll() {
    for (int i = 0; i < _systems.length; i++) {
      final system = _systems[i];
      final resetParameters = <String, dynamic>{};
      
      system.parameters.forEach((key, value) {
        if (value is bool) {
          resetParameters[key] = false;
        } else {
          resetParameters[key] = null;
        }
      });
      
      _systems[i] = system.copyWith(
        parameters: resetParameters,
        result: null,
      );
    }
    notifyListeners();
  }

  // Logic phân tích (đơn giản hóa)
  PCCCCheckResult _performAnalysis(PCCCSystemCheck system) {
    // Đây là logic phân tích đơn giản, thực tế sẽ phức tạp hơn
    String status = 'not_required';
    String result = 'Chưa đủ thông tin để phân tích';
    String reference = 'TCVN 3890:2023';

    switch (system.id) {
      case 'auto_fire_suppression':
        result = _analyzeAutoFireSuppression(system.parameters);
        break;
      case 'auto_fire_alarm':
        result = _analyzeAutoFireAlarm(system.parameters);
        break;
      case 'external_water_supply':
        result = _analyzeExternalWaterSupply(system.parameters);
        break;
      case 'internal_hydrant':
        result = _analyzeInternalHydrant(system.parameters);
        break;
      case 'initial_fire_equipment':
        result = _analyzeInitialFireEquipment(system.parameters);
        break;
      case 'escape_notification':
        result = _analyzeEscapeNotification(system.parameters);
        break;
      case 'mechanical_vehicles':
        result = _analyzeMechanicalVehicles(system.parameters);
        break;
      case 'demolition_masks':
        result = _analyzeDemolitionMasks(system.parameters);
        break;
    }

    // Xác định status dựa trên kết quả
    if (result.contains('Bắt buộc')) {
      status = 'required';
    } else if (result.contains('Nên cân nhắc') || result.contains('Khuyến nghị')) {
      status = 'consider';
    }

    return PCCCCheckResult(
      category: system.name,
      result: result,
      status: status,
      reference: reference,
    );
  }

  String _analyzeAutoFireSuppression(Map<String, dynamic> params) {
    final loaiNha = params['loaiNha'] as LoaiNha?;
    final chieuCao = params['chieuCao'] as double?;
    final hangNguyHiem = params['hangNguyHiemChay'] as HangNguyHiemChay?;

    if (loaiNha == null || chieuCao == null) {
      return 'Vui lòng nhập đầy đủ thông tin loại nhà và chiều cao';
    }

    if (chieuCao > 100) {
      return 'Bắt buộc lắp đặt hệ thống chữa cháy tự động cho công trình trên 100m';
    } else if (chieuCao > 25) {
      return 'Nên cân nhắc lắp đặt hệ thống chữa cháy tự động cho công trình từ 25-100m';
    } else if (hangNguyHiem == HangNguyHiemChay.d || hangNguyHiem == HangNguyHiemChay.e) {
      return 'Bắt buộc lắp đặt do hạng nguy hiểm cháy cao';
    } else {
      return 'Không bắt buộc lắp đặt hệ thống chữa cháy tự động';
    }
  }

  String _analyzeAutoFireAlarm(Map<String, dynamic> params) {
    final loaiNha = params['loaiNha'] as LoaiNha?;
    final chieuCao = params['chieuCao'] as double?;
    final soTang = params['soTang'] as int?;

    if (loaiNha == null || chieuCao == null) {
      return 'Vui lòng nhập đầy đủ thông tin loại nhà và chiều cao';
    }

    if (chieuCao > 50 || (soTang != null && soTang > 17)) {
      return 'Bắt buộc lắp đặt hệ thống báo cháy tự động';
    } else if (chieuCao > 25 || (soTang != null && soTang > 7)) {
      return 'Nên cân nhắc lắp đặt hệ thống báo cháy tự động';
    } else {
      return 'Không bắt buộc lắp đặt hệ thống báo cháy tự động';
    }
  }

  String _analyzeExternalWaterSupply(Map<String, dynamic> params) {
    final coHeThong = params['coHeThongNuocNgoaiNha'] as bool;
    final loaiNha = params['loaiNha'] as LoaiNha?;

    if (coHeThong) {
      return 'Đã có hệ thống cấp nước ngoài nhà';
    } else if (loaiNha == LoaiNha.sanXuat || loaiNha == LoaiNha.khoThap) {
      return 'Bắt buộc có hệ thống cấp nước chữa cháy ngoài nhà';
    } else {
      return 'Nên cân nhắc lắp đặt hệ thống cấp nước ngoài nhà';
    }
  }

  String _analyzeInternalHydrant(Map<String, dynamic> params) {
    final loaiNha = params['loaiNha'] as LoaiNha?;
    final chieuCao = params['chieuCao'] as double?;

    if (loaiNha == null || chieuCao == null) {
      return 'Vui lòng nhập đầy đủ thông tin';
    }

    if (chieuCao > 25) {
      return 'Bắt buộc lắp đặt hệ thống họng nước chữa cháy trong nhà';
    } else {
      return 'Không bắt buộc lắp đặt hệ thống họng nước trong nhà';
    }
  }

  String _analyzeInitialFireEquipment(Map<String, dynamic> params) {
    return 'Bắt buộc trang bị thiết bị chữa cháy ban đầu cho mọi công trình';
  }

  String _analyzeEscapeNotification(Map<String, dynamic> params) {
    final loaiNha = params['loaiNha'] as LoaiNha?;
    final soNguoi = params['soNguoiSuDung'] as int?;

    if (loaiNha == LoaiNha.khachSan || loaiNha == LoaiNha.benhVien) {
      return 'Bắt buộc trang bị thiết bị thoát nạn và thông báo';
    } else if (soNguoi != null && soNguoi > 100) {
      return 'Bắt buộc trang bị do số lượng người sử dụng lớn';
    } else {
      return 'Nên cân nhắc trang bị thiết bị thoát nạn và thông báo';
    }
  }

  String _analyzeMechanicalVehicles(Map<String, dynamic> params) {
    final dienTich = params['dienTichCoSo'] as double?;

    if (dienTich != null && dienTich > 10000) {
      return 'Bắt buộc có phương tiện chữa cháy cơ giới';
    } else {
      return 'Không bắt buộc có phương tiện chữa cháy cơ giới';
    }
  }

  String _analyzeDemolitionMasks(Map<String, dynamic> params) {
    final loaiNha = params['loaiNha'] as LoaiNha?;

    if (loaiNha == LoaiNha.sanXuat || loaiNha == LoaiNha.khoThap) {
      return 'Bắt buộc trang bị thiết bị phá dỡ thô sơ và mặt nạ phòng độc';
    } else {
      return 'Nên cân nhắc trang bị thiết bị phá dỡ và mặt nạ phòng độc';
    }
  }
} 