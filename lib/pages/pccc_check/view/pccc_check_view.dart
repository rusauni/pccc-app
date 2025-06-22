import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/pccc_check/view_model/pccc_check_view_model.dart';
import 'package:base_app/data/models/pccc_system_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator, showDialog;

class PCCCCheckView extends BaseView<PCCCCheckViewModel> {
  const PCCCCheckView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return SafeArea(
      top: false,
      child: viewModel.isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                const Gap(24),
                
                // Error Display
                if (viewModel.errorMessage != null)
                  _buildErrorCard(context),
                
                // Input Form
                _buildInputForm(context),
                const Gap(24),
                
                // Analysis Button
                _buildAnalysisButton(context),
                const Gap(24),
                
                // Results Display
                if (viewModel.hasResults)
                  _buildResultsSection(context),
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

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: VNLTheme.of(context).colorScheme.destructive,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: VNLTheme.of(context).colorScheme.destructive,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông Tin Công Trình',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              VNLButton(
                style: ButtonVariance.secondary,
                onPressed: () => viewModel.resetAll(),
                child: const Text('Reset'),
              ),
            ],
          ),
          const Gap(20),
          
          // Basic form fields using simple TextField widgets
          _buildBasicFields(context),
        ],
      ),
    );
  }

  Widget _buildBasicFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông Tin Cơ Bản',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(16),
        
        // Building Type Selection
        const Text('Loại Công Trình *'),
        const Gap(8),
        VNLSelect<String>(
          value: viewModel.inputData.loaiNha,
          placeholder: const Text('Chọn loại công trình'),
          onChanged: (value) {
            if (value != null) {
              viewModel.updateInputData(loaiNha: value);
            }
          },
          popup: SelectPopup.builder(
            searchPlaceholder: const Text('Tìm kiếm loại công trình'),
            builder: (context, searchQuery) {
              // Filter building types based on search query
              final filteredTypes = searchQuery == null || searchQuery.isEmpty
                  ? viewModel.buildingTypes
                  : viewModel.buildingTypes.where((type) {
                      // Check if type name matches
                      if (type.name.toLowerCase().contains(searchQuery.toLowerCase())) {
                        return true;
                      }
                      // Check if any subcategory matches
                      return type.subcategories.any((sub) =>
                          sub.name.toLowerCase().contains(searchQuery.toLowerCase()));
                    }).map((type) {
                      // Filter subcategories within the type
                      final filteredSubs = type.subcategories.where((sub) =>
                          sub.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          type.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
                      return BuildingType(
                        id: type.id,
                        name: type.name,
                        subcategories: filteredSubs,
                      );
                    }).toList();

              return SelectItemList(
                children: [
                  for (final type in filteredTypes)
                    if (type.subcategories.isNotEmpty)
                      SelectGroup(
                        headers: [
                          SelectLabel(
                            child: Text(type.name),
                          ),
                        ],
                        children: [
                          for (final sub in type.subcategories)
                            SelectItemButton(
                              value: sub.id,
                              child: Text(sub.name),
                            ),
                        ],
                      ),
                ],
              );
            },
          ),
          itemBuilder: (context, value) {
            // Find the selected item
            for (final type in viewModel.buildingTypes) {
              for (final sub in type.subcategories) {
                if (sub.id == value) {
                  return Text('${type.name} - ${sub.name}');
                }
              }
            }
            return const Text('Chọn loại công trình');
          },
        ),
        const Gap(16),
        
        // Fire Risk Category
        const Text('Hạng Nguy Hiểm Cháy'),
        const Gap(8),
        VNLSelect<String>(
          value: viewModel.inputData.hangNguyHiemChay,
          placeholder: const Text('Chọn hạng nguy hiểm'),
          onChanged: (value) {
            if (value != null) {
              viewModel.updateInputData(hangNguyHiemChay: value);
            }
          },
          popup: SelectPopup.builder(
            searchPlaceholder: const Text('Tìm kiếm hạng nguy hiểm'),
            builder: (context, searchQuery) {
              // Filter fire risk categories based on search query
              final filteredCategories = searchQuery == null || searchQuery.isEmpty
                  ? viewModel.fireRiskCategories
                  : viewModel.fireRiskCategories.where((category) =>
                      category.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      category.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      category.id.toLowerCase().contains(searchQuery.toLowerCase())).toList();

              return SelectItemList(
                children: [
                  if (filteredCategories.isNotEmpty)
                    SelectGroup(
                      headers: [
                        SelectLabel(
                          child: const Text('Hạng Nguy Hiểm Cháy'),
                        ),
                      ],
                      children: [
                        for (final category in filteredCategories)
                          SelectItemButton(
                            value: category.id,
                            child: Text('${category.name} - ${category.description}'),
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
          itemBuilder: (context, value) {
            // Find the selected item
            final category = viewModel.fireRiskCategories.firstWhere(
              (cat) => cat.id == value,
              orElse: () => FireRiskCategory(id: '', name: '', description: ''),
            );
            if (category.id.isNotEmpty) {
              return Text('${category.name} - ${category.description}');
            }
            return const Text('Chọn hạng nguy hiểm');
          },
        ),
        const Gap(16),
        
        // Numeric inputs using simple TextField
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chiều Cao (m)'),
                  const Gap(8),
                  VNLTextField(
                    keyboardType: TextInputType.number,
                    placeholder: const Text('Nhập chiều cao'),
                    onChanged: (value) {
                      final height = double.tryParse(value);
                      viewModel.updateInputData(chieuCao: height);
                    },
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Số Tầng'),
                  const Gap(8),
                  VNLTextField(
                    keyboardType: TextInputType.number,
                    placeholder: const Text('Nhập số tầng'),
                    onChanged: (value) {
                      final floors = int.tryParse(value);
                      viewModel.updateInputData(soTang: floors);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(16),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Diện Tích Sàn (m²)'),
                  const Gap(8),
                  VNLTextField(
                    keyboardType: TextInputType.number,
                    placeholder: const Text('Nhập diện tích'),
                    onChanged: (value) {
                      final area = double.tryParse(value);
                      viewModel.updateInputData(tongDienTichSan: area);
                    },
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Số Người Sử Dụng'),
                  const Gap(8),
                  VNLTextField(
                    keyboardType: TextInputType.number,
                    placeholder: const Text('Nhập số người'),
                    onChanged: (value) {
                      final users = int.tryParse(value);
                      viewModel.updateInputData(soNguoiSuDung: users);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(16),
        
        // Toggle fields
        const Text('Đặc Điểm Đặc Biệt'),
        const Gap(8),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            _buildToggleField(
              'Có Tầng Hầm',
              viewModel.inputData.coTangHam ?? false,
              (value) => viewModel.updateInputData(coTangHam: value),
            ),
            _buildToggleField(
              'Có Phòng Ngủ',
              viewModel.inputData.coPhongNgu ?? false,
              (value) => viewModel.updateInputData(coPhongNgu: value),
            ),
            _buildToggleField(
              'Mục Đích Đặc Biệt',
              viewModel.inputData.mucDichSuDungDacBiet ?? false,
              (value) => viewModel.updateInputData(mucDichSuDungDacBiet: value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleField(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VNLSwitch(
          value: value,
          onChanged: onChanged,
        ),
        const Gap(8),
        Text(label),
      ],
    );
  }

  Widget _buildAnalysisButton(BuildContext context) {
    return Center(
      child: VNLButton(
        style: ButtonVariance.primary,
        onPressed: viewModel.hasBasicInput && !viewModel.isAnalyzing
            ? () => viewModel.analyzeAllSystems()
            : null,
        child: viewModel.isAnalyzing
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(),
                  ),
                  Gap(8),
                  Text('Đang Phân Tích...'),
                ],
              )
            : const Text('🔍 Phân Tích Yêu Cầu PCCC'),
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    final requiredSystems = viewModel.getResultsByStatus('required');
    final optionalSystems = viewModel.getResultsByStatus('optional');
    final notRequiredSystems = viewModel.getResultsByStatus('not_required');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kết Quả Phân Tích',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        
        // Summary
        _buildSummaryCard(context),
        const Gap(16),
        
        // Required Systems
        if (requiredSystems.isNotEmpty) ...[
          _buildResultCategory(context, 'Bắt Buộc Lắp Đặt', requiredSystems, Colors.red),
          const Gap(16),
        ],
        
        // Optional Systems
        if (optionalSystems.isNotEmpty) ...[
          _buildResultCategory(context, 'Khuyến Nghị Lắp Đặt', optionalSystems, Colors.orange),
          const Gap(16),
        ],
        
        // Not Required Systems
        if (notRequiredSystems.isNotEmpty) ...[
          _buildResultCategory(context, 'Không Bắt Buộc', notRequiredSystems, Colors.grey),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final report = viewModel.generateSummaryReport();
    
    return Container(
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
          const Text(
            'Tổng Quan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(12),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Tổng Số Hệ Thống',
                  '${report['totalSystems'] ?? 0}',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Bắt Buộc',
                  '${report['requiredCount'] ?? 0}',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Khuyến Nghị',
                  '${report['optionalCount'] ?? 0}',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildResultCategory(BuildContext context, String title, List<PCCCCheckResult> results, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${results.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          
          ...results.map((result) => _buildResultItem(context, result)),
        ],
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, PCCCCheckResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.systemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (result.suggestions != null)
                VNLButton(
                  style: ButtonVariance.secondary,
                  onPressed: () => _showSuggestionsDialog(context, result),
                  child: const Text('Xem Gợi Ý'),
                ),
            ],
          ),
          const Gap(8),
          Text(
            result.reason,
            style: TextStyle(
              fontSize: 14,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
          
          if (result.matchedRules.isNotEmpty) ...[
            const Gap(8),
            ...result.matchedRules.map((rule) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      rule,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  void _showSuggestionsDialog(BuildContext context, PCCCCheckResult result) {
    showDialog(
      context: context,
      builder: (context) => VNLAlertDialog(
        title: Text('Gợi Ý: ${result.systemName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.suggestions!.required.isNotEmpty) ...[
              const Text(
                'Thiết Bị Bắt Buộc:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              ...result.suggestions!.required.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
              const Gap(16),
            ],
            
            if (result.suggestions!.optional.isNotEmpty) ...[
              const Text(
                'Thiết Bị Tùy Chọn:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              ...result.suggestions!.optional.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
            ],
          ],
        ),
        actions: [
          VNLButton(
            style: ButtonVariance.secondary,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
} 