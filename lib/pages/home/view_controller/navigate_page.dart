import 'package:base_app/pages/base/view_controller/page_view_controller.dart';
import 'package:base_app/pages/home/view_model/home_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:base_app/pages/home/view_controller/tabs/home_tab.dart';
import 'package:base_app/pages/home/view_controller/tabs/news_tab.dart';
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
    return [const VNLDivider(), _buildVNLNavigationBar()];
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
        mainContent = NewsTab();
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

  // Navigation bar configuration variables
  final NavigationBarAlignment _alignment = NavigationBarAlignment.spaceAround;
  final bool _expands = true;
  final NavigationLabelType _labelType = NavigationLabelType.none;
  final bool _customButtonStyle = true;
  final bool _expanded = true;

  NavigationItem _buildNavigationItem(String label, IconData icon) {
    return NavigationItem(
      style: _customButtonStyle ? const ButtonStyle.muted(density: ButtonDensity.icon) : null,
      selectedStyle: _customButtonStyle ? const ButtonStyle.fixed(density: ButtonDensity.icon) : null,
      label: Text(label),
      child: Icon(icon),
    );
  }

  Widget _buildVNLNavigationBar() {
    return VNLNavigationBar(
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
        _buildNavigationItem('Home', RadixIcons.home),
        _buildNavigationItem('News', RadixIcons.fileText),
        _buildNavigationItem('Documents', RadixIcons.fileText),
        _buildNavigationItem('Videos', RadixIcons.video),
        _buildNavigationItem('Settings', RadixIcons.gear),
      ],
    );
  }
}
