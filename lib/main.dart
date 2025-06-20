import 'dart:convert';

import 'package:base_app/app/app_theme_setting.dart';
import 'package:base_app/app/main_app.dart';
import 'package:gtd_helper/gtd_helper.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

import 'app/app_global_const.dart';
import 'pages/app_themes/theme_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load app configuration
  await loadAppConfig();
  // Initialize the app
  final prefs = CacheHelper.shared.prefs;
  var colorScheme = prefs?.getString(AppThemeSettingKey.colorScheme);
  VNLColorScheme? initialColorScheme;
  if (colorScheme != null) {
    if (colorScheme.startsWith('{')) {
      initialColorScheme = VNLColorScheme.fromMap(jsonDecode(colorScheme));
    } else {
      initialColorScheme = colorSchemes[colorScheme];
    }
  }
  double initialRadius = prefs?.getDouble('radius') ?? 0.5;
  double initialScaling = prefs?.getDouble('scaling') ?? 1.0;
  double initialSurfaceOpacity = prefs?.getDouble('surfaceOpacity') ?? 1.0;
  double initialSurfaceBlur = prefs?.getDouble('surfaceBlur') ?? 0.0;
  String initialPath = prefs?.getString('initialPath') ?? '/';
  runApp(
    VNLMainApp(
      initialColorScheme: initialColorScheme ?? colorSchemes['lightBlue']!,
      // initialColorScheme: ColorSchemes.darkRose(),
      initialRadius: initialRadius,
      initialScaling: initialScaling,
      initialSurfaceOpacity: initialSurfaceOpacity,
      initialSurfaceBlur: initialSurfaceBlur,
      initialPath: kEnablePersistentPath ? initialPath : '/',
    ),
  );
}
