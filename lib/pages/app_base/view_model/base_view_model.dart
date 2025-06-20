import 'package:flutter/material.dart';
import 'package:gtd_helper/gtd_helper.dart';

class BaseViewModel with ChangeNotifier {
  BaseViewModel();
  @override
  void dispose() {
    super.dispose();

    Logger.i("$runtimeType is denied");
  }

  void reloadView({GtdVoidCallback? callback}) {
    notifyListeners();
  }
}
