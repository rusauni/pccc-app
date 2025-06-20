import 'package:vnl_common_ui/vnl_ui.dart';

class SidebarButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool selected;

  const SidebarButton({super.key, required this.child, required this.onPressed, required this.selected});

  @override
  Widget build(BuildContext context) {
    var data = VNLTheme.of(context);
    if (selected) {
      data = data.copyWith(
        colorScheme: data.colorScheme.copyWith(mutedForeground: data.colorScheme.secondaryForeground),
      );
    }
    return VNLTheme(
      data: data,
      child: VNLButton(
        onPressed: onPressed,
        alignment: AlignmentDirectional.centerStart,
        style: ButtonVariance.text.copyWith(
          padding: (context, states, value) {
            return const EdgeInsets.symmetric(vertical: 4, horizontal: 8) * data.scaling;
          },
          textStyle: (context, states, value) {
            return value.copyWith(fontWeight: selected ? FontWeight.w500 : FontWeight.normal);
          },
        ),
        child: child.small(),
      ),
    );
  }
}
