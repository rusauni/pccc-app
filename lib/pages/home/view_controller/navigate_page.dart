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
import 'package:go_router/go_router.dart';

class NavigatePage extends PageViewController<HomePageViewModel> {
  const NavigatePage({super.key, required super.viewModel});

  @override
  NavigatePageState createState() => NavigatePageState();
}

class NavigatePageState extends PageViewControllerState<NavigatePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Try to get tab index from query parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.toString();
      final uri = Uri.parse(location);
      final tabIndex = int.tryParse(uri.queryParameters['tab'] ?? '0') ?? 0;
      if (tabIndex != _selectedIndex && tabIndex >= 0 && tabIndex <= 4) {
        setState(() {
          _selectedIndex = tabIndex;
        });
      }
    });
  }

  @override
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [
      VNLAppBar(
        title: const Text('An Toàn PCCC'),
        subtitle: const Text('Quản lý phòng cháy chữa cháy'),
        leading: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/appicon/appicon.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: VNLTheme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        trailing: [
          VNLOutlineButton(
            onPressed: () {
              context.go('/search');
            },
            density: ButtonDensity.icon,
            child: const Icon(Icons.search),
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
        mainContent = SettingsTab();
        break;
      default:
        mainContent = HomeTab();
        break;
    }

    // For home tab, add navigation settings
    return mainContent;
  }

  Widget _buildModernNavigationBar() {
    final theme = VNLTheme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.border.withValues(alpha: 0.2),
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: _buildCompactNavigationItem(
                  'Trang chủ', 
                  LucideIcons.house,
                  0,
                ),
              ),
              Flexible(
                child: _buildCompactNavigationItem(
                  'Tin tức', 
                  LucideIcons.newspaper,
                  1,
                ),
              ),
              Flexible(
                child: _buildCompactNavigationItem(
                  'Tài liệu', 
                  LucideIcons.fileText,
                  2,
                ),
              ),
              Flexible(
                child: _buildCompactNavigationItem(
                  'Video', 
                  LucideIcons.video,
                  3,
                ),
              ),
              Flexible(
                child: _buildCompactNavigationItem(
                  'Cài đặt', 
                  LucideIcons.settings,
                  4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNavigationItem(String label, IconData icon, int index) {
    final theme = VNLTheme.of(context);
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.mutedForeground,
              ),
            ),
            SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
