import 'package:base_app/pages/base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/home/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:base_app/pages/home/view_controller/tabs/home_tab.dart';
import 'package:base_app/pages/news/view_controller/news_page.dart';
import 'package:base_app/pages/news/view_model/news_page_view_model.dart';
import 'package:base_app/pages/home/view_controller/tabs/documents_tab.dart';
import 'package:base_app/pages/home/view_controller/tabs/videos_tab.dart';
import 'package:base_app/pages/home/view_controller/tabs/settings_tab.dart';

class NavigatePage extends PageViewController<HomePageViewModel> {
  const NavigatePage({super.key, required super.viewModel});

  @override
  NavigatePageState createState() => NavigatePageState();
}

class NavigatePageState extends PageViewControllerState<NavigatePage> {
  int _selectedIndex = 0;

  @override
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [
      VNLAppBar(
        title: const Text('PCCC 40'),
        subtitle: const Text('PCCC App'),
        leading: [
          VNLOutlineButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: const Icon(Icons.menu),
          ),
        ],
        trailing: [
          VNLOutlineButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: const Icon(Icons.search),
          ),
          VNLOutlineButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      const VNLDivider(),
    ];
  }

  @override
  List<Widget> buildFooters(BuildContext pageContext) {
    return [_buildModernNavigationBar()];
  }

  @override
  Widget buildBody(Object pageContext) {
    return _buildBody();
  }

  Widget _buildBody() {
    // Determine which content to show based on selected index
    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = HomeTab();
        break;
      case 1:
        mainContent = NewsPage(viewModel: NewsPageViewModel());
        break;
      case 2:
        mainContent = DocumentsTab();
        break;
      case 3:
        mainContent = VideosTab();
        break;
      case 4:
        // Show settings tab
        mainContent = SettingsTab();

        break;
      default:
        mainContent = HomeTab();
        break;
    }

    // For home tab, add navigation settings
    return mainContent;
  }

  // Navigation bar configuration variables - updated for modern design
  final NavigationBarAlignment _alignment = NavigationBarAlignment.spaceAround;
  final bool _expands = false;
  final NavigationLabelType _labelType = NavigationLabelType.all;
  final bool _customButtonStyle = true;
  final bool _expanded = false;

  NavigationItem _buildNavigationItem(String label, IconData icon, IconData? selectedIcon) {
    return NavigationItem(
      style: _customButtonStyle 
        ? ButtonStyle.ghost(density: ButtonDensity.compact) 
        : null,
      selectedStyle: _customButtonStyle 
        ? ButtonStyle.primary(density: ButtonDensity.compact) 
        : null,
      label: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      child: Icon(icon, size: 22),
    );
  }

  Widget _buildModernNavigationBar() {
    final theme = VNLTheme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: VNLNavigationBar(
            alignment: _alignment,
            labelType: _labelType,
            expanded: _expanded,
            expands: _expands,
            onSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            index: _selectedIndex,
            children: [
              _buildNavigationItem(
                'Trang chủ', 
                BootstrapIcons.house, 
                BootstrapIcons.houseFill
              ),
              _buildNavigationItem(
                'Tin tức', 
                BootstrapIcons.newspaper, 
                null
              ),
              _buildNavigationItem(
                'Tài liệu', 
                BootstrapIcons.fileEarmark, 
                BootstrapIcons.fileEarmarkFill
              ),
              _buildNavigationItem(
                'Video', 
                BootstrapIcons.playBtn, 
                BootstrapIcons.playBtnFill
              ),
              _buildNavigationItem(
                'Cài đặt', 
                BootstrapIcons.gear, 
                BootstrapIcons.gearFill
              ),
            ],
          ),
        ),
      ),
    );
  }
}
