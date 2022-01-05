import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/cache_store.model.dart';
import 'package:mustang_viewer/src/models/persistent_store.model.dart';
import 'package:mustang_viewer/src/screens/cache_store/cache_store_service.service.dart';
import 'package:pretty_json/pretty_json.dart';

import 'cache_store_state.dart';

@ScreenService(screenState: $CacheStoreState)
class CacheStoreService {
  void clearMemoryScreen() {
    PersistentStore persistentStore =
        WrenchStore.get<PersistentStore>() ?? PersistentStore();
    persistentStore = persistentStore.rebuild(
      (b) => b..clearScreenCache = true,
    );
    updateState1(persistentStore, reload: false);
  }

  void updateHiveBoxName(String boxName) {
    PersistentStore persistentStore =
        WrenchStore.get<PersistentStore>() ?? PersistentStore();
    persistentStore = persistentStore.rebuild((b) => b..hiveBoxName = boxName);
    updateState1(persistentStore, reload: false);
  }

  Future<void> fetchStoreData() async {
    CacheStore cacheStore = WrenchStore.get<CacheStore>() ?? CacheStore();
    try {
      ProcessResult processResult = await Process.run('sh',
          ['lib/scripts/ios_sh.sh', ('${cacheStore.hiveBoxName}.hive.cache')]);
      print('output:${processResult.stdout}');
      if (processResult.stdout != "Invalid BoxName") {
        print('iff');
        Hive.init('lib/scripts/');
        Box box = await Hive.openBox(cacheStore.hiveBoxName);
        Map<String, String> storeData = {};
        for (String element in box.keys) {
          storeData[element] = box.get(element);
        }
        storeData = storeData.map((key, value) => MapEntry('"$key"', value));
        cacheStore = cacheStore.rebuild((b) =>
            b..cacheModelData = prettyJson(jsonDecode(storeData.toString())));
        updateState1(cacheStore);
      }
    } catch (e) {
      print('exception:$e');
    }
  }
}
