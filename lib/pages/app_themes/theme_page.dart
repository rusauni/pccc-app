import 'package:base_app/app/main_app.dart';
import 'package:base_app/pages/app_panel/on_this_page.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

final Map<String, VNLColorScheme> colorSchemes = {
  'lightBlue': ColorSchemes.lightBlue(),
  'darkBlue': ColorSchemes.darkBlue(),
  'lightGray': ColorSchemes.lightGray(),
  'darkGray': ColorSchemes.darkGray(),
  'lightGreen': ColorSchemes.lightGreen(),
  'darkGreen': ColorSchemes.darkGreen(),
  'lightNeutral': ColorSchemes.lightNeutral(),
  'darkNeutral': ColorSchemes.darkNeutral(),
  'lightOrange': ColorSchemes.lightOrange(),
  'darkOrange': ColorSchemes.darkOrange(),
  'lightRed': ColorSchemes.lightRed(),
  'darkRed': ColorSchemes.darkRed(),
  'lightRose': ColorSchemes.lightRose(),
  'darkRose': ColorSchemes.darkRose(),
  'lightSlate': ColorSchemes.lightSlate(),
  'darkSlate': ColorSchemes.darkSlate(),
  'lightStone': ColorSchemes.lightStone(),
  'darkStone': ColorSchemes.darkStone(),
  'lightViolet': ColorSchemes.lightViolet(),
  'darkViolet': ColorSchemes.darkViolet(),
  'lightYellow': ColorSchemes.lightYellow(),
  'darkYellow': ColorSchemes.darkYellow(),
  'lightZinc': ColorSchemes.lightZinc(),
  'darkZinc': ColorSchemes.darkZinc(),
};

String? nameFromColorScheme(VNLColorScheme scheme) {
  return colorSchemes.keys.where((key) => colorSchemes[key] == scheme).firstOrNull;
}

class _ThemePageState extends State<ThemePage> {
  late Map<String, Color> colors;
  late double radius;
  late double scaling;
  late double surfaceOpacity;
  late double surfaceBlur;
  late VNLColorScheme colorScheme;
  bool customColorScheme = false;
  bool applyDirectly = true;

  final OnThisPage customColorSchemeKey = OnThisPage();
  final OnThisPage premadeColorSchemeKey = OnThisPage();
  final OnThisPage radiusKey = OnThisPage();
  final OnThisPage scalingKey = OnThisPage();
  final OnThisPage surfaceOpacityKey = OnThisPage();
  final OnThisPage surfaceBlurKey = OnThisPage();
  final OnThisPage codeKey = OnThisPage();

  @override
  void initState() {
    super.initState();
    colors = ColorSchemes.lightBlue().toColorMap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VNLMainAppState state = Data.of(context);
    colorScheme = state.colorScheme;
    colors = colorScheme.toColorMap();
    radius = state.radius;
    customColorScheme = nameFromColorScheme(colorScheme) == null;
    scaling = state.scaling;
    surfaceOpacity = state.surfaceOpacity;
    surfaceBlur = state.surfaceBlur;
  }

  @override
  Widget build(BuildContext context) {
    VNLMainAppState state = Data.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Theme').h1(),
          const Text('Customize the look and feel of your app.').lead(),
          const Text('Custom color scheme').h2().anchored(customColorSchemeKey),
          // Text('You can also use premade color schemes.').p(),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text('You can also use premade color schemes to customize the look and feel of your app.')),
            ],
          ).p(),
          Wrap(runSpacing: 8, spacing: 8, children: colorSchemes.keys.map(buildPremadeColorSchemeButton).toList()).p(),
        ],
      ),
    );
  }

  Widget buildPremadeColorSchemeButton(String name) {
    var scheme = colorSchemes[name]!;
    return !customColorScheme && scheme == colorScheme
        ? VNLPrimaryButton(
            onPressed: () {
              setState(() {
                colorScheme = scheme;
                colors = colorScheme.toColorMap();
                customColorScheme = false;
                if (applyDirectly) {
                  VNLMainAppState state = Data.of(context);
                  state.changeColorScheme(colorScheme);
                }
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primaryForeground,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                const Gap(8),
                Text(name),
              ],
            ),
          )
        : VNLOutlineButton(
            onPressed: () {
              setState(() {
                colorScheme = scheme;
                colors = colorScheme.toColorMap();
                customColorScheme = false;
                if (applyDirectly) {
                  VNLMainAppState state = Data.of(context);
                  state.changeColorScheme(colorScheme);
                }
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primaryForeground,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                const Gap(8),
                Text(name),
              ],
            ),
          );
  }
}
