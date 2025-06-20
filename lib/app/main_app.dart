import 'dart:io';

import 'package:base_app/app/app_theme_setting.dart';
import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/app_themes/theme_page.dart';
import 'package:base_app/pages/home/view_controller/setting_theme_page.dart';
import 'package:base_app/pages/splash/view_controller/splash_view_controller.dart';
import 'package:base_app/pages/auth/login/view_controller/login_page.dart';
import 'package:base_app/pages/auth/login/view_model/login_page_view_model.dart';
import 'package:base_app/pages/auth/otp/view_controller/otp_page.dart';
import 'package:base_app/pages/auth/otp/view_model/otp_page_view_model.dart';
import 'package:base_app/pages/auth/register/view_controller/register_page.dart';
import 'package:base_app/pages/auth/register/view_model/register_page_view_model.dart';
import 'package:base_app/pages/home/view_controller/navigate_page.dart';
import 'package:base_app/pages/home/view_model/home_page_view_model.dart';
import 'package:base_app/router/app_router.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_helper/gtd_helper.dart';

import 'app_global_const.dart';

class _DesktopNavigatorObserver extends NavigatorObserver {
  final ValueChanged<String> onRouteChanged;

  _DesktopNavigatorObserver({this.onRouteChanged = print});

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    var settings = topRoute.settings as NoTransitionPage;
    var key = settings.key as ValueKey<String>;
    onRouteChanged(key.value);
  }
}

class VNLMainApp extends StatefulWidget {
  final VNLColorScheme initialColorScheme;
  final double initialRadius;
  final double initialScaling;
  final double initialSurfaceOpacity;
  final double initialSurfaceBlur;
  final String initialPath;
  const VNLMainApp({
    super.key,
    required this.initialColorScheme,
    required this.initialRadius,
    required this.initialScaling,
    required this.initialSurfaceOpacity,
    required this.initialSurfaceBlur,
    required this.initialPath,
  });

  @override
  State<VNLMainApp> createState() => VNLMainAppState();
}

class VNLMainAppState extends State<VNLMainApp> {
  final List<GoRoute> routes = [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen(), name: AppRouterPath.splash),
    GoRoute(
      path: '/${AppRouterPath.home}',
      builder: (context, state) => NavigatePage(viewModel: HomePageViewModel()),
      name: AppRouterPath.home,
    ),
    GoRoute(
        path: '/${AppRouterPath.theme}',
        builder: (context, state) => SettingThemePage(viewModel: PageViewModel()),
        name: AppRouterPath.theme),
    GoRoute(
      path: '/auth',
      builder: (context, state) => LoginPage(viewModel: LoginPageViewModel()),
      name: AppRouterPath.login,
      routes: [
        GoRoute(
          path: AppRouterPath.register,
          builder: (context, state) => RegisterPage(viewModel: RegisterPageViewModel()),
          name: AppRouterPath.register,
        ),
        GoRoute(
          path: AppRouterPath.otp,
          builder: (context, state) {
            final phone = state.extra != null ? (state.extra as Map<String, dynamic>)['phone'] as String? ?? '' : '';
            return OtpPage(viewModel: OtpPageViewModel(), phone: phone);
          },
          name: AppRouterPath.otp,
        ),
      ],
    ),
  ];
  late VNLColorScheme colorScheme;
  late double radius;
  late double scaling;
  late double surfaceOpacity;
  late double surfaceBlur;
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    colorScheme = widget.initialColorScheme;
    radius = widget.initialRadius;
    scaling = widget.initialScaling;
    surfaceOpacity = widget.initialSurfaceOpacity;
    surfaceBlur = widget.initialSurfaceBlur;
    router = GoRouter(
      routes: routes,
      initialLocation: widget.initialPath,
      observers: [
        if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux) && kEnablePersistentPath)
          _DesktopNavigatorObserver(
            onRouteChanged: (path) {
              CacheHelper.shared.prefs?.setString(AppThemeSettingKey.initialPath, path);
              // SharedPreferences.getInstance().then((prefs) {
              //   prefs.setString('initialPath', path);
              // });
            },
          ),
      ],
    );
  }
  // This widget is the root of your application.

  void changeColorScheme(VNLColorScheme colorScheme) {
    setState(() {
      this.colorScheme = colorScheme;
      String name = nameFromColorScheme(colorScheme) ?? 'lightBlue';
      CacheHelper.shared.prefs?.setString(AppThemeSettingKey.colorScheme, name);
      // SharedPreferences.getInstance().then((prefs) {
      //   // prefs.setString('colorScheme', nameFromColorScheme(colorScheme));
      //   String? name = nameFromColorScheme(colorScheme);
      //   prefs.setString('colorScheme', name);
      // });
    });
  }

  void changeRadius(double radius) {
    setState(() {
      this.radius = radius;
      CacheHelper.shared.prefs?.setDouble(AppThemeSettingKey.radius, radius);
      // SharedPreferences.getInstance().then((prefs) {
      //   prefs.setDouble('radius', radius);
      // });
    });
  }

  void changeScaling(double scaling) {
    setState(() {
      this.scaling = scaling;
      CacheHelper.shared.prefs?.setDouble(AppThemeSettingKey.scaling, scaling);
      // SharedPreferences.getInstance().then((value) {
      //   value.setDouble('scaling', scaling);
      // });
    });
  }

  void changeSurfaceOpacity(double surfaceOpacity) {
    setState(() {
      this.surfaceOpacity = surfaceOpacity;
      CacheHelper.shared.prefs?.setDouble(AppThemeSettingKey.surfaceOpacity, surfaceOpacity);
      // SharedPreferences.getInstance().then((value) {
      //   value.setDouble('surfaceOpacity', surfaceOpacity);
      // });
    });
  }

  void changeSurfaceBlur(double surfaceBlur) {
    setState(() {
      this.surfaceBlur = surfaceBlur;
      CacheHelper.shared.prefs?.setDouble(AppThemeSettingKey.surfaceBlur, surfaceBlur);
      // SharedPreferences.getInstance().then((value) {
      //   value.setDouble('surfaceBlur', surfaceBlur);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Data.inherit(
      data: this,
      child: VNLookApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'VNL UI Flutter',
        scaling: AdaptiveScaling(scaling),
        enableScrollInterception: true,
        // popoverHandler: DialogOverlayHandler(),
        theme: VNLThemeData(
          colorScheme: colorScheme,
          radius: radius,
          surfaceBlur: surfaceBlur,
          surfaceOpacity: surfaceOpacity,
        ),
      ),
    );
  }
}
