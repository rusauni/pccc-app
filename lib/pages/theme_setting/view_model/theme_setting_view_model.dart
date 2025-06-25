import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/theme_setting/model/theme_option.dart';
import 'package:base_app/pages/app_themes/theme_page.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class ThemeSettingViewModel extends BaseViewModel {
  String _currentTheme = 'lightRed';
  
  ThemeSettingViewModel();
  
  void initializeTheme(String? currentThemeName) {
    if (currentThemeName != null && 
        (currentThemeName == 'lightRed' || currentThemeName == 'darkRed')) {
      _currentTheme = currentThemeName;
      notifyListeners();
    }
  }

  String get currentTheme => _currentTheme;
  
  List<ThemeOption> get availableThemes => ThemeOption.allOptions;
  
  bool isCurrentTheme(String themeName) => _currentTheme == themeName;
  
  VNLColorScheme get currentColorScheme => colorSchemes[_currentTheme]!;
  
  void changeTheme(String themeName) {
    if (themeName != _currentTheme && colorSchemes.containsKey(themeName)) {
      _currentTheme = themeName;
      notifyListeners();
    }
  }
  
  ThemeOption get currentThemeOption {
    return ThemeOption.allOptions.firstWhere(
      (option) => option.name == _currentTheme,
      orElse: () => ThemeOption.lightRed,
    );
  }
} 