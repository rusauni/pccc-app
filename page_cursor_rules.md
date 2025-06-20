# Flutter MVVM Page Creation Rules

## Directory Structure

```
lib/pages/feature_name/
├── model/              # Feature-specific models
├── view/
│   └── feature_name_view.dart
├── view_controller/
│   └── feature_name_page.dart
└── view_model/
    ├── feature_name_view_model.dart
    └── feature_name_page_view_model.dart
```

## Naming Conventions

- Folders must use snake_case: `feature_name`
- Files must use snake_case: `feature_name_view.dart`
- Classes must use PascalCase: `FeatureNameView`
- View files must end with `_view.dart`
- Page files must end with `_page.dart`
- ViewModel files must end with `_view_model.dart` or `_page_view_model.dart`

## File Templates

### 1. `feature_name_view.dart`

```dart
import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/feature_name/view_model/feature_name_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class FeatureNameView extends BaseView<FeatureNameViewModel> {
  const FeatureNameView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox();
  }
}
```

### 2. `feature_name_page.dart`

```dart
import 'package:base_app/pages/feature_name/view/feature_name_view.dart';
import 'package:base_app/pages/feature_name/view_model/feature_name_page_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../../base/view_controller/page_view_controller.dart';

class FeatureNamePage extends PageViewController<FeatureNamePageViewModel> {
  const FeatureNamePage({super.key, required super.viewModel});

  @override
  FeatureNamePageState createState() => FeatureNamePageState();
}

class FeatureNamePageState extends PageViewControllerState<FeatureNamePage> {
  @override
  Widget buildBody(BuildContext pageContext) {
    return FeatureNameView(viewModel: widget.viewModel.featureNameViewModel);
  }
}
```

### 3. `feature_name_view_model.dart`

```dart
import 'package:base_app/pages/base/view_model/base_view_model.dart';

class FeatureNameViewModel extends BaseViewModel {
  FeatureNameViewModel();
}
```

### 4. `feature_name_page_view_model.dart`

```dart
import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/feature_name/view_model/feature_name_view_model.dart';

class FeatureNamePageViewModel extends PageViewModel {
  final FeatureNameViewModel featureNameViewModel = FeatureNameViewModel();

  FeatureNamePageViewModel() {
    title = "FeatureName";
  }
}
```

## Implementation Rules

1. **UI Package**

   - Always use `package:vnl_common_ui/vnl_ui.dart` instead of material.dart

2. **MVVM Architecture**

   - Follow MVVM pattern strictly
   - Views handle UI only
   - ViewModels handle business logic
   - Pages connect Views and ViewModels

3. **View Implementation**

   - Extend `BaseView<T>` where T is the corresponding ViewModel
   - Implement `buildWidget()` method for UI

4. **ViewController Implementation**

   - Extend `PageViewController<T>` where T is the corresponding PageViewModel
   - Implement `createState()` method
   - The state class extends `PageViewControllerState<T>`
   - Implement `buildBody()` in the state class

5. **ViewModel Implementation**

   - ViewModels extend `BaseViewModel`
   - PageViewModels extend `PageViewModel`
   - PageViewModel contains an instance of the corresponding ViewModel

6. **Connection Pattern**

   - PageViewControllerState connects the View to the ViewModel
   - Access the ViewModel through `widget.viewModel.featureNameViewModel`

7. **Creating New Pages**
   - Create all four folders (model, view, view_controller, view_model)
   - Create files with exact naming pattern, changing only the feature name
   - Follow the implementation details as shown in templates
