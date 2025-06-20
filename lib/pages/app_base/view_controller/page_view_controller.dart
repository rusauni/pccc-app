import 'package:meta/meta.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

import '../view_model/page_view_model.dart';
import 'base_view_controller.dart';

class PageViewController<T extends PageViewModel> extends BaseViewController<T> {
  static String get route => "pageRoute";
  String getRoute() => route;
  const PageViewController({super.key, required super.viewModel});

  @override
  BaseViewState<PageViewController> createState() {
    return PageViewControllerState();
  }
}

class PageViewControllerState<S extends PageViewController> extends BaseViewState<S> {
  @protected
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [];
  }

  @protected
  List<Widget> buildFooters(BuildContext pageContext) {
    return [];
  }

  @mustBeOverridden
  Widget buildBody(BuildContext pageContext) {
    throw UnimplementedError();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StageContainer(
      builder: (context, padding) {
        return VNLScaffold(
          key: widget.viewModel.scaffoldKey,
          headers: buildHeaders(context),
          footers: buildFooters(context),
          loadingProgressIndeterminate: widget.viewModel.loadingProgressIndeterminate ?? false,
          loadingProgress: widget.viewModel.loadingProgress,
          floatingHeader: widget.viewModel.floatingHeader ?? false,
          floatingFooter: widget.viewModel.floatingFooter ?? false,
          backgroundColor: widget.viewModel.backgroundColor,
          headerBackgroundColor: widget.viewModel.headerBackgroundColor,
          footerBackgroundColor: widget.viewModel.footerBackgroundColor,
          showLoadingSparks: widget.viewModel.showLoadingSparks ?? false,
          resizeToAvoidBottomInset: widget.viewModel.resizeToAvoidBottomInset ?? true,
          child: buildBody(context),
        );
      },
    );
  }
}
