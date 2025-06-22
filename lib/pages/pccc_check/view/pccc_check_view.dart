import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/pccc_check/view_model/pccc_check_view_model.dart';
import 'package:base_app/pages/pccc_check/model/pccc_check_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle;

class PCCCCheckView extends BaseView<PCCCCheckViewModel> {
  const PCCCCheckView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const Gap(24),
            
            // Reset All Button
            _buildResetAllButton(context),
            const Gap(24),
            
            // Systems List
            ...viewModel.systems.map((system) => 
              _buildSystemCard(context, system)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔥 Kiểm Tra Yêu Cầu Trang Bị Hệ Thống PCCC',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Text(
          'Xác định các yêu cầu trang bị hệ thống phòng cháy chữa cháy theo TCVN 3890:2023',
          style: TextStyle(
            fontSize: 16,
            color: VNLTheme.of(context).colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildResetAllButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: VNLButton(
        style: ButtonVariance.destructive,
        onPressed: () => viewModel.resetAll(),
        child: const Text('Reset Tất Cả'),
      ),
    );
  }

  Widget _buildSystemCard(BuildContext context, PCCCSystemCheck system) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: VNLTheme.of(context).colorScheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Title
          Row(
            children: [
              Expanded(
                child: Text(
                  system.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Reset button for individual system
              VNLButton(
                style: ButtonVariance.secondary,
                onPressed: () => viewModel.resetSystem(system.id),
                child: const Text('Reset'),
              ),
            ],
          ),
          const Gap(16),
          
          // Parameters Form
          _buildParametersForm(context, system),
          const Gap(20),
          
          // Analyze Button
          _buildAnalyzeButton(context, system),
          const Gap(16),
          
          // Result Display
          if (system.result != null)
            _buildResultDisplay(context, system.result!),
        ],
      ),
    );
  }

  Widget _buildParametersForm(BuildContext context, PCCCSystemCheck system) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: system.parameters.entries.map((entry) {
        return _buildFormField(context, system.id, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildFormField(BuildContext context, String systemId, String paramKey, dynamic value) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getFieldLabel(paramKey),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const Gap(8),
          _buildInputWidget(context, systemId, paramKey, value),
        ],
      ),
    );
  }

  Widget _buildInputWidget(BuildContext context, String systemId, String paramKey, dynamic value) {
    if (paramKey == 'loaiNha') {
      return VNLSelect<LoaiNha>(
        value: value as LoaiNha?,
        placeholder: const Text('Chọn loại nhà'),
        onChanged: (newValue) => viewModel.updateSystemParameter(systemId, paramKey, newValue),
        itemBuilder: (context, item) => Text(item.displayName),
        popup: SelectPopup.builder(
          builder: (context, searchQuery) {
            return SelectItemList(
              children: LoaiNha.values.map((loaiNha) => 
                SelectItemButton(
                  value: loaiNha,
                  child: Text(loaiNha.displayName),
                )
              ).toList(),
            );
          },
        ).asBuilder,
      );
    } else if (paramKey == 'hangNguyHiemChay') {
      return VNLSelect<HangNguyHiemChay>(
        value: value as HangNguyHiemChay?,
        placeholder: const Text('Chọn hạng nguy hiểm cháy'),
        onChanged: (newValue) => viewModel.updateSystemParameter(systemId, paramKey, newValue),
        itemBuilder: (context, item) => Text(item.displayName),
        popup: SelectPopup.builder(
          builder: (context, searchQuery) {
            return SelectItemList(
              children: HangNguyHiemChay.values.map((hang) => 
                SelectItemButton(
                  value: hang,
                  child: Text(hang.displayName),
                )
              ).toList(),
            );
          },
        ).asBuilder,
      );
    } else if (value is bool) {
      return Row(
        children: [
          VNLToggle(
            value: value,
            onChanged: (newValue) => viewModel.updateSystemParameter(systemId, paramKey, newValue),
            child: const SizedBox.shrink(),
          ),
          const Gap(8),
          Text(value ? 'Có' : 'Không'),
        ],
      );
    } else {
      return VNLTextField(
        placeholder: const Text('Nhập thông tin'),
        keyboardType: _getKeyboardType(value),
        onChanged: (text) {
          dynamic newValue;
          if (value is int?) {
            newValue = int.tryParse(text);
          } else if (value is double?) {
            newValue = double.tryParse(text);
          } else {
            newValue = text.isEmpty ? null : text;
          }
          viewModel.updateSystemParameter(systemId, paramKey, newValue);
        },
      );
    }
  }

  TextInputType _getKeyboardType(dynamic value) {
    if (value is int? || value is double?) {
      return TextInputType.number;
    }
    return TextInputType.text;
  }

  Widget _buildAnalyzeButton(BuildContext context, PCCCSystemCheck system) {
    return SizedBox(
      width: double.infinity,
      child: VNLButton(
        style: ButtonVariance.primary,
        onPressed: () => viewModel.analyzeSystem(system.id),
        child: const Text('PHÂN TÍCH'),
      ),
    );
  }

  Widget _buildResultDisplay(BuildContext context, PCCCCheckResult result) {
    Color statusColor;
    IconData statusIcon;
    
    switch (result.status) {
      case 'required':
        statusColor = VNLTheme.of(context).colorScheme.destructive;
        statusIcon = Icons.warning;
        break;
      case 'consider':
        statusColor = Colors.orange;
        statusIcon = Icons.info;
        break;
      default:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const Gap(8),
              Text(
                'Kết quả phân tích',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            result.result,
            style: const TextStyle(fontSize: 16),
          ),
          const Gap(8),
          Text(
            'Tham chiếu: ${result.reference}',
            style: TextStyle(
              fontSize: 12,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  String _getFieldLabel(String paramKey) {
    const labels = {
      'loaiNha': 'Loại công trình',
      'chieuCao': 'Chiều cao (m)',
      'tongDienTichSan': 'Tổng diện tích sàn (m²)',
      'khoiTich': 'Khối tích (m³)',
      'hangNguyHiemChay': 'Hạng nguy hiểm cháy',
      'tiLePhongCanCC': 'Tỷ lệ phòng cần CC (%)',
      'coHangMucDacBiet': 'Có hạng mục đặc biệt',
      'soTang': 'Số tầng',
      'dienTichSan': 'Diện tích sàn (m²)',
      'coTangHam': 'Có tầng hầm',
      'choPhepThayTheCucBo': 'Cho phép thay thế cục bộ',
      'khoangCachNguonCap': 'Khoảng cách nguồn cấp (m)',
      'luuLuongCapNuoc': 'Lưu lượng cấp nước (l/s)',
      'truLuongCapNuoc': 'Trữ lượng cấp nước (m³)',
      'coHeThongNuocNgoaiNha': 'Đã có hệ thống nước ngoài nhà',
      'ketHopCapNuocSinhHoat': 'Kết hợp cấp nước sinh hoạt',
      'suDungChatKiNuoc': 'Sử dụng chất kỵ nước',
      'yeuCauDuyTriApSuat': 'Yêu cầu duy trì áp suất',
      'dienTichKhuVuc': 'Diện tích khu vực (m²)',
      'coVatCan': 'Có vật cản',
      'khuVucNgotNgach': 'Khu vực ngóт ngách',
      'loaiBinhChuaChay': 'Loại bình chữa cháy',
      'soNguoiSuDung': 'Số người sử dụng',
      'coPhongNgu': 'Có phòng ngủ',
      'coPhongOnLon': 'Có khu vực ồn lớn',
      'loaiCoSo': 'Loại cơ sở',
      'dienTichCoSo': 'Diện tích cơ sở (m²)',
      'loaiPhuongTienCoGioi': 'Loại phương tiện cơ giới',
      'viTriBoTriPhongTruc': 'Vị trí bố trí phòng trực',
      'coKhuyenKhichMatNaLocDoc': 'Có khuyến khích mặt nạ lọc độc',
    };
    
    return labels[paramKey] ?? paramKey;
  }
} 