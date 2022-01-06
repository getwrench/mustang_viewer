import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/cache_store.model.dart';
import 'package:mustang_viewer/src/screens/cache_store/cache_store_service.service.dart';
import 'package:pretty_json/pretty_json.dart';

import 'cache_store_state.dart';

@ScreenService(screenState: $CacheStoreState)
class CacheStoreService {
  void clearMemoryScreen() {
    CacheStore cacheStore = WrenchStore.get<CacheStore>() ?? CacheStore();
    cacheStore = cacheStore.rebuild(
      (b) => b..clearScreenCache = true,
    );
    updateState1(CacheStore, reload: false);
  }

  void updateHiveBoxName(String boxName) {
    CacheStore cacheStore = WrenchStore.get<CacheStore>() ?? CacheStore();
    cacheStore = cacheStore.rebuild((b) => b..hiveBoxName = boxName);
    updateState1(cacheStore, reload: false);
  }

  void updateAppPkgName(String appPkgName) {
    CacheStore cacheStore = WrenchStore.get<CacheStore>() ?? CacheStore();
    cacheStore = cacheStore.rebuild((b) => b..applicationPkgName = appPkgName);
    updateState1(cacheStore, reload: false);
  }

  Future<void> fetchStoreData() async {
    CacheStore cacheStore = WrenchStore.get<CacheStore>() ?? CacheStore();
    try {
      ProcessResult processResult = await Process.run('sh', [
        Platform.isIOS ? 'lib/scripts/ios_sh.sh' : 'lib/scripts/android_sh.sh',
        ('${cacheStore.hiveBoxName}.hive'),
        (cacheStore.applicationPkgName)
      ]);
      if (!([6, 5].contains(processResult.exitCode))) {
        Hive.init('lib/scripts/');
        LazyBox lazyBox = await Hive.openLazyBox(cacheStore.hiveBoxName);
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
        cacheStore = cacheStore.rebuild((b) =>
            b..cacheModelData = prettyJson(jsonDecode(storeData.toString())));
        updateState1(cacheStore);
      }
    } catch (e) {
      cacheStore = cacheStore.rebuild((b) => b..errorMsg = e.toString());
      updateState1(cacheStore);
    }
  }
}
