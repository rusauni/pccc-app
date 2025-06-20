import 'package:vnl_common_ui/vnl_ui.dart';

final PageStorageBucket docsBucket = PageStorageBucket();

extension Keyed on Widget {
  KeyedSubtree keyed(Key key) {
    return KeyedSubtree(key: key, child: this);
  }
}

