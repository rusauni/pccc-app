import 'package:vnl_common_ui/vnl_ui.dart';
import 'side_bar_button.dart';
import 'side_bar_nav.dart';
import 'side_bar_section.dart';

const double breakpointMedium = 768;
const double breakpointLarge = 1024;

class MultiPanelLayout extends StatefulWidget {
  const MultiPanelLayout({super.key, required this.leftPanel, required this.centerPanel, required this.rightPanel});

  final Widget leftPanel;
  final Widget centerPanel;
  final Widget rightPanel;

  @override
  State<MultiPanelLayout> createState() => _MultiPanelLayoutState();
}

class _MultiPanelLayoutState extends State<MultiPanelLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = VNLTheme.of(context);

    return StageContainer(
      builder: (context, padding) {
        return VNLScaffold(
          headers: [
            Container(
              color: theme.colorScheme.background.scaleAlpha(0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App bar with responsive layout
                  MediaQueryVisibility(
                    minWidth: breakpointMedium,
                    alternateChild: VNLAppBar(
                      padding: EdgeInsets.symmetric(vertical: 12 * theme.scaling, horizontal: 18 * theme.scaling),
                      leading: [
                        VNLGhostButton(
                          density: ButtonDensity.icon,
                          onPressed: () {
                            _openDrawer(context);
                          },
                          child: const Icon(Icons.menu),
                        ),
                      ],
                      child: const Text('Three Panel Layout').textLarge(),
                    ),
                    child: VNLAppBar(
                      padding: padding.copyWith(top: 12, bottom: 12) * theme.scaling,
                      title: const Text('Three Panel Layout').textLarge(),
                    ),
                  ),
                  const VNLDivider(),
                ],
              ),
            ),
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left panel - only visible on medium and large screens
              MediaQueryVisibility(
                minWidth: breakpointMedium,
                child: FocusTraversalGroup(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 32, left: 24 + padding.left, bottom: 32) * theme.scaling,
                    child: SizedBox(width: 200 * theme.scaling, child: widget.leftPanel),
                  ),
                ),
              ),

              // Center panel - always visible
              Expanded(
                child: FocusTraversalGroup(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 32).copyWith(
                          right: MediaQuery.of(context).size.width >= breakpointLarge ? 24 : padding.right + 32,
                        ) *
                        theme.scaling,
                    child: widget.centerPanel,
                  ),
                ),
              ),

              // Right panel - only visible on large screens
              MediaQueryVisibility(
                minWidth: breakpointLarge,
                child: Container(
                  width: (padding.right + 180) * theme.scaling,
                  alignment: Alignment.topLeft,
                  child: FocusTraversalGroup(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 32, right: 24, bottom: 32, left: 24) * theme.scaling,
                      child: widget.rightPanel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDrawer(BuildContext context) {
    final theme = VNLTheme.of(context);

    openSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 300) * theme.scaling,
          padding: const EdgeInsets.only(top: 32) * theme.scaling,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text('Menu').textLarge(),
                  const Spacer(),
                  VNLGhostButton(
                    density: ButtonDensity.icon,
                    onPressed: () {
                      closeDrawer(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ).withPadding(horizontal: 24 * theme.scaling),

              Gap(32 * theme.scaling),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16) * theme.scaling,
                  child: widget.leftPanel,
                ),
              ),
            ],
          ),
        );
      },
      position: OverlayPosition.left,
    );
  }
}

// Ví dụ sử dụng
class ThreePanelExample extends StatefulWidget {
  const ThreePanelExample({super.key});

  @override
  State<ThreePanelExample> createState() => _ThreePanelExampleState();
}

class _ThreePanelExampleState extends State<ThreePanelExample> {
  int _selectedLeftIndex = 0;
  int _selectedRightIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = VNLTheme.of(context);

    return MultiPanelLayout(
      leftPanel: SidebarNav(
        children: [
          SidebarSection(
            header: const Text('Navigation'),
            children: List.generate(
              10,
              (index) => SidebarButton(
                selected: _selectedLeftIndex == index,
                child: Text('Navigation Item $index'),
                onPressed: () {
                  setState(() {
                    _selectedLeftIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),

      centerPanel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          10,
          (index) => VNLCard(
            padding: const EdgeInsets.only(bottom: 16) * theme.scaling,
            child: Container(
              padding: const EdgeInsets.all(16) * theme.scaling,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Content Section $index').textLarge(),
                  Gap(8 * theme.scaling),
                  const Text('This is the main content area that expands to fill available space.'),
                  index == _selectedLeftIndex
                      ? const Text('Currently selected in left panel').textLarge().mono
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),

      rightPanel: SidebarNav(
        children: [
          SidebarSection(
            header: const Text('On This Page'),
            children: List.generate(
              10,
              (index) => SidebarButton(
                selected: _selectedRightIndex == index,
                child: Text('Section $index'),
                onPressed: () {
                  setState(() {
                    _selectedRightIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
