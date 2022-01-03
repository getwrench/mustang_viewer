import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/app_menu.model.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/persistent_store.model.dart';

import 'app_menu_service.service.dart';
import 'app_menu_state.dart';

@ScreenService(screenState: $AppMenuState)
class AppMenuService {
  Future<void> disconnect() async {
    Connect connect = WrenchStore.get<Connect>() ?? Connect();
    try {
      await connect.vmService!.dispose();
      await connect.vmService!.onDone;
      connect = connect.rebuild(
        (b) => b
          ..vmService = null
          ..connected = false,
      );
    } catch (e) {
      connect = connect.rebuild(
        (b) => b..errorOnEvent = '$e',
      );
    } finally {
      updateState1(connect, reload: false);
    }
  }

  void updateIndex(int index) {
    AppMenu appMenu = WrenchStore.get<AppMenu>() ?? AppMenu();
    appMenu = appMenu.rebuild((b) => b..activeIndex = index);
    updateState1(appMenu);
  }

  void clearConnectScreen() {
    updateState1(Connect(), reload: false);
  }

  void clearPersistentStoreData() {
    PersistentStore persistentStore =
        WrenchStore.get<PersistentStore>() ?? PersistentStore();
    persistentStore =
        persistentStore.rebuild((b) => b..persistentModelData = '{}');
    updateState1(persistentStore);
  }
}
