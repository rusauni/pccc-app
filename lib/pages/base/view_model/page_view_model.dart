// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vnl_common_ui/vnl_ui.dart';

import 'base_view_model.dart';

class PageViewModel extends BaseViewModel {
  late String? title;
  late String? subTitle;
  final ValueNotifier<String> subTitleNotifer = ValueNotifier("");
  GlobalKey<VNLScaffoldState> scaffoldKey = GlobalKey<VNLScaffoldState>();

  double? loadingProgress;
  bool? loadingProgressIndeterminate;
  bool? floatingHeader; // when header floats, it takes no space in the layout, and positioned on top of the content
  bool? floatingFooter;
  Color? headerBackgroundColor;
  Color? footerBackgroundColor;
  Color? backgroundColor;
  bool? showLoadingSparks;
  bool? resizeToAvoidBottomInset;

  PageViewModel({
    this.title,
    this.subTitle,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.floatingHeader = false,
    this.floatingFooter = false,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.showLoadingSparks = false,
    this.resizeToAvoidBottomInset,
  }) {
    subTitleNotifer.value = subTitle ?? "";
  }
}
