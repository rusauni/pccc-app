import 'package:base_app/router/app_router.dart';
import 'package:flutter/material.dart' hide IconButton, ButtonStyle, ElevatedButton, showDialog;
import 'package:go_router/go_router.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String selectedLanguage = 'Tiếng Việt';
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings title with minimal spacing
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          
          // Your account section
          _buildSectionHeader('Tài khoản của bạn'),
          Gap(12),
          _buildAccountSection(),
          Gap(24),
          
          // About us section
          _buildSectionHeader('Về chúng tôi'),
          Gap(12),
          _buildAboutSection(),
          Gap(32),
          
          // Logout button
          _buildLogoutButton(),
          Gap(24),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: VNLTheme.of(context).colorScheme.mutedForeground,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: BootstrapIcons.person,
          title: 'Tài khoản',
          subtitle: '+84 123 456 789',
          onTap: () => context.pushNamed(AppRouterPath.accountDetail),
        ),
        Gap(8),
        _buildSettingItem(
          icon: BootstrapIcons.bell,
          title: 'Thông báo',
          subtitle: 'Đã bật',
          onTap: () {},
        ),
        Gap(8),
        _buildSettingItem(
          icon: BootstrapIcons.globe,
          title: 'Ngôn ngữ',
          subtitle: selectedLanguage,
          showDropdown: true,
          onTap: () => _showLanguageSelector(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: BootstrapIcons.star,
          title: 'Đánh giá ứng dụng',
          subtitle: 'Chia sẻ trải nghiệm của bạn',
          onTap: () {},
        ),
        Gap(8),
        _buildSettingItem(
          icon: BootstrapIcons.chatDots,
          title: 'Phản hồi',
          subtitle: 'Gửi ý kiến đóng góp cho chúng tôi',
          onTap: () {},
        ),
        Gap(8),
        _buildSettingItem(
          icon: BootstrapIcons.palette,
          title: 'Giao diện',
          subtitle: 'Tùy chỉnh màu sắc và theme',
          onTap: () => context.pushNamed(AppRouterPath.theme),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDropdown = false,
  }) {
    return VNLCard(
      child: VNLButton(
        style: ButtonStyle.ghost(),
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: VNLTheme.of(context).colorScheme.muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
              ),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Gap(2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: VNLTheme.of(context).colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                showDropdown ? BootstrapIcons.chevronDown : BootstrapIcons.chevronRight,
                size: 16,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: VNLButton(
        style: ButtonStyle.destructive(),
        onPressed: () => _showLogoutDialog(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(BootstrapIcons.boxArrowRight, size: 18),
            Gap(8),
            Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'PCCC © 2025 v1.0',
        style: TextStyle(
          fontSize: 12,
          color: VNLTheme.of(context).colorScheme.mutedForeground,
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn ngôn ngữ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Gap(16),
            _buildLanguageOption('Tiếng Việt'),
            _buildLanguageOption('English'),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = selectedLanguage == language;
    return VNLButton(
      style: ButtonStyle.ghost(),
      onPressed: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? VNLTheme.of(context).colorScheme.primary : null,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                BootstrapIcons.check,
                size: 16,
                color: VNLTheme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => VNLAlertDialog(
        title: Text('Xác nhận đăng xuất'),
        content: Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
        actions: [
          VNLButton(
            style: ButtonStyle.ghost(),
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          VNLButton(
            style: ButtonStyle.destructive(),
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic here
            },
            child: Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
