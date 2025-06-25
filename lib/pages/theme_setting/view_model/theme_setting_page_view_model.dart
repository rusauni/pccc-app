import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/theme_setting/view_model/theme_setting_view_model.dart';

class ThemeSettingPageViewModel extends PageViewModel {
  final ThemeSettingViewModel themeSettingViewModel = ThemeSettingViewModel();

  ThemeSettingPageViewModel() {
    title = "Cài đặt giao diện";
  }
} 