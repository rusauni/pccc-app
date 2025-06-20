import 'package:vnl_common_ui/vnl_ui.dart';

class SidebarSection extends StatelessWidget {
  final Widget header;
  final List<Widget> children;

  const SidebarSection({super.key, required this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header.small().semiBold().withPadding(vertical: 4, horizontal: 8), const Gap(4), ...children],
    );
  }
}
