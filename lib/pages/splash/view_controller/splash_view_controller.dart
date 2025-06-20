import 'package:base_app/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_helper/gtd_helper.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (context.mounted) {
        context.pushReplacementNamed(AppRouterPath.home);
      }
    });
    return ColoredBox(
      color: const Color(0xfffffdfa),
      // color: const Color(0xff2A2438),
      // color: secondrycolor,
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(child: GtdImage.lottieImage(assetName: "assets/icons/logocicimedia1.json", repeat: false)),
      ),
    );
  }
}
