import 'package:vnl_common_ui/vnl_ui.dart';

class SidebarNav extends StatefulWidget {
  final List<Widget> children;

  const SidebarNav({super.key, required this.children});

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = join(widget.children, const Gap(16)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _children,
      ),
    );
  }
}
