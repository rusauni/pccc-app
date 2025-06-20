import 'package:base_app/pages/app_base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

abstract class BaseViewController<T extends BaseViewModel> extends StatefulWidget {
  final T viewModel;

  const BaseViewController({super.key, required this.viewModel});

  @override
  BaseViewState<BaseViewController> createState(); // Bắt buộc override
}

abstract class BaseViewState<VC extends BaseViewController> extends State<VC> {
  @override
  void initState() {
    super.initState();
    onInit();
  }

  Widget buildWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    return Data.inherit(data: widget.viewModel, child: buildWidget(context));
  }

  @override
  void dispose() {
    onDispose();
    widget.viewModel.dispose();
    Logger.i("${widget.runtimeType} is denied");
    super.dispose();
  }

  /// Override nếu cần custom logic init
  void onInit() {}

  /// Override nếu cần clean up
  void onDispose() {}
}
