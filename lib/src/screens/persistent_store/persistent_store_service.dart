import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/persistent_store.model.dart';
import 'package:mustang_viewer/src/screens/persistent_store/persistent_store_service.service.dart';
import 'package:pretty_json/pretty_json.dart';

import 'persistent_store_state.dart';

@ScreenService(screenState: $PersistentStoreState)
class PersistentStoreService {
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
    PersistentStore persistentStore =
        WrenchStore.get<PersistentStore>() ?? PersistentStore();
    try {
      ProcessResult processResult = await Process.run('sh',
          ['lib/scripts/ios_sh.sh', ('${persistentStore.hiveBoxName}.hive')]);
      print('output:${processResult.stdout}');
      if (processResult.stdout != "Invalid BoxName") {
        print('iff');
        Hive.init('lib/scripts/');
        Box box = await Hive.openBox(persistentStore.hiveBoxName);
        Map<String, String> storeData = {};
        for (String element in box.keys) {
          storeData[element] = box.get(element);
        }
        storeData = storeData.map((key, value) => MapEntry('"$key"', value));
        persistentStore = persistentStore.rebuild((b) => b
          ..persistentModelData = prettyJson(jsonDecode(storeData.toString())));
        updateState1(persistentStore);
      }
    } catch (e) {
      print('exception:$e');
    }
  }
}
