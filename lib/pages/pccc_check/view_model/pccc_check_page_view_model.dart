import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/pccc_check/view_model/pccc_check_view_model.dart';

class PCCCCheckPageViewModel extends PageViewModel {
  final PCCCCheckViewModel pcccCheckViewModel = PCCCCheckViewModel();

  PCCCCheckPageViewModel() {
    title = "Công cụ kiểm tra PCCC";
  }
} 