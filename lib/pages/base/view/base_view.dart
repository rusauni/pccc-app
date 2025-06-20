import 'package:meta/meta.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

import '../view_model/base_view_model.dart';

abstract class BaseView<T extends BaseViewModel> extends StatelessWidget {
  final T viewModel;

  const BaseView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Data.inherit(data: viewModel, child: buildWidget(context));
  }

  static BaseViewModel? of(BuildContext context) {
    return Data.maybeOf<BaseViewModel>(context);
  }

  @mustBeOverridden
  Widget buildWidget(BuildContext context) {
    throw UnimplementedError();
  }
}
