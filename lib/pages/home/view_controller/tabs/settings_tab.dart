import 'package:base_app/router/app_router.dart';
import 'package:flutter/material.dart' hide IconButton, ButtonStyle, ElevatedButton;
import 'package:go_router/go_router.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = VNLTheme.of(context);
    bool isEnglish = true;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: theme.colorScheme.primaryForeground,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Login Section
          _buildSettingSection(
            title: 'Login',
            children: [
              ListTile(
                leading: Icon(RadixIcons.enter),
                title: Text('Login'),
                onTap: () {
                  context.pushNamed(AppRouterPath.login);
                },
              ),
              ListTile(
                leading: Icon(RadixIcons.pencil2),
                title: Text('Register'),
                onTap: () {
                  context.pushNamed(AppRouterPath.register);
                },
              ),
            ],
          ),
          // Theme Section
          _buildSettingSection(
            title: 'Theme',
            children: [
              ListTile(
                leading: Icon(RadixIcons.colorWheel),
                title: Text('Theme Settings'),
                onTap: () {
                  context.pushNamed(AppRouterPath.theme);
                },
              ),
            ],
          ),
          // Language Section
          _buildSettingSection(
            title: 'Language',
            children: [
              SwitchListTile(
                title: Text(isEnglish ? 'English' : 'Tiếng Việt'),
                value: isEnglish,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        Divider(),
      ],
    );
  }
}
