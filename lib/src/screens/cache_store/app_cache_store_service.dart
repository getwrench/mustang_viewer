import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/app_cache_store.model.dart';
import 'package:mustang_viewer/src/screens/cache_store/app_cache_store_service.service.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
import 'package:pretty_json/pretty_json.dart';

import 'app_cache_store_state.dart';

@ScreenService(screenState: $AppCacheStoreState)
class AppCacheStoreService {
  void clearMemoryScreen() {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    appCacheStore = appCacheStore.rebuild(
      (b) => b..clearScreenCache = true,
    );
    updateState1(appCacheStore, reload: false);
  }

  void updateStoreName(String boxName) {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    appCacheStore = appCacheStore.rebuild((b) => b..appPkgName = boxName);
    updateState1(appCacheStore, reload: false);
  }

  void updateAppPkgName(String appPkgName) {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    appCacheStore = appCacheStore.rebuild((b) => b..appPkgName = appPkgName);
    updateState1(appCacheStore, reload: false);
  }

  Future<void> fetchCacheData() async {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    try {
      ProcessResult processResult = await Process.run('sh', [
        appCacheStore.osType == AppConstants.osTypes.first
            ? 'tool/android_sh.sh'
            : 'tool/ios_sh.sh',
        ('${appCacheStore.storeName}.hive'),
        (appCacheStore.appPkgName)
      ]);
      if (processResult.exitCode == 0) {
        Hive.init('${Directory.systemTemp}');
        LazyBox lazyBox = await Hive.openLazyBox(appCacheStore.storeName);
        Map<String, Map<String, String>> storeData = {};
        for (String key in lazyBox.keys) {
          storeData[key] = (await lazyBox.get(key))?.cast<String, String>();
        }
        storeData = storeData.map(
          (key, value) => MapEntry(
            '"$key"',
            value.map(
              (key, value) => MapEntry('"$key"', value),
            ),
          ),
        );
        appCacheStore = appCacheStore.rebuild(
            (b) => b..data = prettyJson(jsonDecode(storeData.toString())));
        updateState1(appCacheStore);
      }
    } catch (e) {
      appCacheStore = appCacheStore.rebuild((b) => b..errorMsg = e.toString());
      updateState1(appCacheStore);
    }
  }

  void onChangeModelViewSearch(String searchText) {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    List<int> highlightIndices = AppTextHighlighter.findHighlights(
      appCacheStore.data.toLowerCase(),
      searchText.toLowerCase(),
    );
    appCacheStore = appCacheStore.rebuild(
      (b) => b
        ..modelDataSearchText = searchText
        ..selectedModelDataSearchTextIndex = 0
        ..modelDataSearchTextIndices = ListBuilder<int>(highlightIndices),
    );
    updateState1(AppCacheStore);
  }

  void onNavigateModelViewSearchMatches(int index) {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    if (appCacheStore.modelDataSearchTextIndices.isNotEmpty) {
      if ((appCacheStore.modelDataSearchTextIndices.length > index) &&
          (index) >= 0) {
        appCacheStore = appCacheStore.rebuild(
          (b) => b..selectedModelDataSearchTextIndex = index,
        );
        updateState1(AppCacheStore);
      }
    }
  }

  void updateOSType(String osType) {
    AppCacheStore appCacheStore =
        WrenchStore.get<AppCacheStore>() ?? AppCacheStore();
    appCacheStore = appCacheStore.rebuild((b) => b..osType = osType);
    updateState1(appCacheStore);
  }
}
