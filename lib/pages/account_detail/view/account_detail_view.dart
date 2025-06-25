import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/account_detail/view_model/account_detail_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class AccountDetailView extends BaseView<AccountDetailViewModel> {
  const AccountDetailView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: VNLProgress(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              const Gap(24),
              _buildPersonalInfoSection(context),
              const Gap(24),
              _buildContactInfoSection(context),
              const Gap(24),
              _buildWorkInfoSection(context),
              const Gap(32),
              _buildActionButtons(context),
              if (viewModel.errorMessage != null) ...[
                const Gap(16),
                _buildErrorMessage(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: VNLTheme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              BootstrapIcons.person,
              size: 40,
              color: VNLTheme.of(context).colorScheme.primaryForeground,
            ),
          ),
          const Gap(12),
          Text(
            viewModel.accountDetail?.fullName ?? 'Đang tải...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            viewModel.accountDetail?.email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return VNLCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            _buildInfoField(
              context,
              'Họ và tên',
              viewModel.fullNameController,
              BootstrapIcons.person,
            ),
            const Gap(12),
            _buildInfoField(
              context,
              'Ngày sinh',
              viewModel.dateOfBirthController,
              BootstrapIcons.calendar,
            ),
            const Gap(12),
            _buildGenderField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    return VNLCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin liên hệ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            _buildInfoField(
              context,
              'Email',
              viewModel.emailController,
              BootstrapIcons.envelope,
            ),
            const Gap(12),
            _buildInfoField(
              context,
              'Số điện thoại',
              viewModel.phoneController,
              BootstrapIcons.telephone,
            ),
            const Gap(12),
            _buildInfoField(
              context,
              'Địa chỉ',
              viewModel.addressController,
              BootstrapIcons.geoAlt,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfoSection(BuildContext context) {
    return VNLCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin công việc',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            _buildInfoField(
              context,
              'Nghề nghiệp',
              viewModel.occupationController,
              BootstrapIcons.briefcase,
            ),
            const Gap(12),
            _buildInfoField(
              context,
              'Công ty',
              viewModel.companyController,
              BootstrapIcons.building,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: VNLTheme.of(context).colorScheme.mutedForeground,
          ),
        ),
        const Gap(8),
        VNLTextField(
          controller: controller,
          enabled: viewModel.isEditing,
          maxLines: maxLines,
          features: [
            InputFeature.leading(Icon(icon, size: 18)),
          ],
          placeholder: Text('Nhập $label'),
        ),
      ],
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới tính',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: VNLTheme.of(context).colorScheme.mutedForeground,
          ),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: VNLTheme.of(context).colorScheme.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(BootstrapIcons.genderAmbiguous, size: 18),
              const Gap(12),
              Expanded(child: Text(viewModel.selectedGender)),
              if (viewModel.isEditing)
                Icon(BootstrapIcons.chevronDown, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VNLButton(
            style: viewModel.isEditing 
                ? ButtonStyle.outline() 
                : ButtonStyle.primary(),
            onPressed: viewModel.isLoading ? null : () {
              viewModel.toggleEditMode();
            },
            child: Text(viewModel.isEditing ? 'Hủy' : 'Chỉnh sửa'),
          ),
        ),
        if (viewModel.isEditing) ...[
          const Gap(12),
          Expanded(
            child: VNLButton(
              style: ButtonStyle.primary(),
              onPressed: viewModel.isLoading ? null : () async {
                final success = await viewModel.saveAccountDetail();
                if (success) {
                  // Success feedback handled in ViewModel
                }
              },
              child: viewModel.isLoading
                  ? const VNLProgress()
                  : Text('Lưu'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.destructive.withOpacity(0.1),
        border: Border.all(color: VNLTheme.of(context).colorScheme.destructive.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(BootstrapIcons.exclamationTriangle, 
               color: VNLTheme.of(context).colorScheme.destructive, size: 16),
          const Gap(8),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(color: VNLTheme.of(context).colorScheme.destructive),
            ),
          ),
          VNLButton.ghost(
            onPressed: viewModel.clearError,
            child: Icon(BootstrapIcons.x, size: 16),
          ),
        ],
      ),
    );
  }
} 