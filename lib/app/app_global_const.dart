import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_helper/gtd_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yaml/yaml.dart';

const kEnablePersistentPath = false;
Map<String, Object?>? _docs;
String? _packageLatestVersion;
String? get packageLatestVersion => _packageLatestVersion;

const double breakpointWidth = 768;
const double breakpointWidth2 = 1024;

// App Flavor
String get flavor {
  String? flavor = _docs?['flavor'] as String?;
  assert(flavor != null, 'Flavor not found in docs.json');
  return flavor!;
}

// App Tag Name
String getReleaseTagName() {
  var latestVersion = packageLatestVersion;
  return latestVersion == null ? 'Release' : 'Release ($latestVersion)';
}

Future<void> loadAppConfig() async {
  _docs = jsonDecode(await rootBundle.loadString('docs.json'));
  String pubspecYml = await rootBundle.loadString('pubspec.lock');
  var dep = loadYaml(pubspecYml)['packages']['vnl_common_ui']['version'];
  if (dep is String) {
    _packageLatestVersion = dep;
  }

  print('Running app with flavor: $flavor');
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await CacheHelper.shared.initCachedMemory();
}

void openInNewTab(String url) {
  launchUrlString(url);
}
