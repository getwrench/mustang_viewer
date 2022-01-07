import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/app_persistence_store.model.dart';
import 'package:mustang_viewer/src/screens/persistence_store/app_persistence_store_service.service.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
import 'package:pretty_json/pretty_json.dart';

import 'app_persistence_store_state.dart';

@ScreenService(screenState: $AppPersistenceStoreState)
class AppPersistenceStoreService {
  void clearMemoryScreen() {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    appPersistenceStore = appPersistenceStore.rebuild(
      (b) => b..clearScreenCache = true,
    );
    updateState1(appPersistenceStore, reload: false);
  }

  void updateStoreName(String boxName) {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    appPersistenceStore =
        appPersistenceStore.rebuild((b) => b..storeName = boxName);
    updateState1(appPersistenceStore, reload: false);
  }

  void updateAppPkgName(String appPkgName) {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    appPersistenceStore =
        appPersistenceStore.rebuild((b) => b..appPkgName = appPkgName);
    updateState1(appPersistenceStore, reload: false);
  }

  Future<void> fetchStoreData() async {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    try {
      ProcessResult processResult = await Process.run('sh', [
        appPersistenceStore.osType == AppConstants.osTypes.first
            ? 'tool/android_sh.sh'
            : 'tool/ios_sh.sh',
        ('${appPersistenceStore.storeName}.hive'),
        (appPersistenceStore.appPkgName)
      ]);
      print('exitcode:${processResult.exitCode}---${processResult.stdout}');
      if (processResult.exitCode == 0) {
        Hive.init('${Directory.systemTemp}');
        Box box = await Hive.openBox(appPersistenceStore.storeName);
        Map<String, String> storeData = {};
        for (String key in box.keys) {
          storeData[key] = box.get(key);
        }
        storeData = storeData.map((key, value) => MapEntry('"$key"', value));
        print('storeData:${storeData}');
        appPersistenceStore = appPersistenceStore.rebuild(
            (b) => b..data = prettyJson(jsonDecode(storeData.toString())));
        updateState1(appPersistenceStore);
      } else {
        print('Exception condition');
        throw Exception('Something went wrong');
      }
    } catch (e) {
      appPersistenceStore =
          appPersistenceStore.rebuild((b) => b..errorMsg = e.toString());
      updateState1(appPersistenceStore);
    }
  }

  void onChangeModelViewSearch(String searchText) {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    List<int> highlightIndices = AppTextHighlighter.findHighlights(
      appPersistenceStore.data.toLowerCase(),
      searchText.toLowerCase(),
    );
    appPersistenceStore = appPersistenceStore.rebuild(
      (b) => b
        ..modelDataSearchText = searchText
        ..selectedModelDataSearchTextIndex = 0
        ..modelDataSearchTextIndices = ListBuilder<int>(highlightIndices),
    );
    updateState1(appPersistenceStore);
  }

  void onNavigateModelViewSearchMatches(int index) {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    if (appPersistenceStore.modelDataSearchTextIndices.isNotEmpty) {
      if ((appPersistenceStore.modelDataSearchTextIndices.length > index) &&
          (index) >= 0) {
        appPersistenceStore = appPersistenceStore.rebuild(
          (b) => b..selectedModelDataSearchTextIndex = index,
        );
        updateState1(appPersistenceStore);
      }
    }
  }

  void updateOSType(String osType) {
    AppPersistenceStore appPersistenceStore =
        WrenchStore.get<AppPersistenceStore>() ?? AppPersistenceStore();
    appPersistenceStore =
        appPersistenceStore.rebuild((b) => b..osType = osType);
    updateState1(appPersistenceStore);
  }
}
