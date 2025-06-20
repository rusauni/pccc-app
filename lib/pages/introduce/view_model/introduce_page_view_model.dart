import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/introduce/view_model/introduce_view_model.dart';

class IntroducePageViewModel extends PageViewModel {
  final IntroduceViewModel introduceViewModel = IntroduceViewModel();
  IntroducePageViewModel() {
    title = "Introduce";
  }
}
