import 'package:base_app/pages/theme_setting/view_model/theme_setting_view_model.dart';
import 'package:base_app/pages/theme_setting/model/theme_option.dart';
import 'package:base_app/pages/app_themes/theme_page.dart';
import 'package:base_app/app/main_app.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:vnl_common_ui/vnl_ui.dart';

class ThemeSettingView extends StatefulWidget {
  final ThemeSettingViewModel viewModel;
  
  const ThemeSettingView({super.key, required this.viewModel});

  @override
  State<ThemeSettingView> createState() => _ThemeSettingViewState();
}

class _ThemeSettingViewState extends State<ThemeSettingView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize theme giống như theme page cũ
    VNLMainAppState state = Data.of(context);
    final currentThemeName = nameFromColorScheme(state.colorScheme);
    widget.viewModel.initializeTheme(currentThemeName);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        VNLMainAppState state = Data.of(context);
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn giao diện').h1(),
              Text(
                'Tùy chỉnh giao diện cho ứng dụng An Toàn PCCC',
                style: TextStyle(
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
              ).p(),
              const Gap(24),
              
              // Theme options
              ...ThemeOption.allOptions.map((option) => 
                _buildThemeOption(context, option, state)
              ),
              
              const Gap(32),
              
              // Current theme info
              _buildCurrentThemeInfo(context),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildThemeOption(BuildContext context, ThemeOption option, VNLMainAppState state) {
    final isSelected = widget.viewModel.isCurrentTheme(option.name);
    final colorScheme = colorSchemes[option.name]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: VNLCard(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.viewModel.changeTheme(option.name);
              state.changeColorScheme(colorScheme);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Theme preview
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.border,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      option.isLight ? BootstrapIcons.sun : BootstrapIcons.moon,
                      color: colorScheme.primaryForeground,
                      size: 24,
                    ),
                  ),
                  
                  const Gap(16),
                  
                  // Theme info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          option.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Selection indicator
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        BootstrapIcons.check,
                        color: colorScheme.primaryForeground,
                        size: 16,
                      ),
                    )
                  else
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: VNLTheme.of(context).colorScheme.border,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentThemeInfo(BuildContext context) {
    final currentOption = widget.viewModel.currentThemeOption;
    final colorScheme = widget.viewModel.currentColorScheme;
    
    return VNLCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giao diện hiện tại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    currentOption.isLight ? BootstrapIcons.sun : BootstrapIcons.moon,
                    color: colorScheme.primaryForeground,
                    size: 16,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentOption.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        currentOption.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 