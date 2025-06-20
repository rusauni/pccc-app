import 'package:vnl_common_ui/vnl_ui.dart';
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
