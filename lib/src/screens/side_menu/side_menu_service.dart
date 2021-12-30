import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/side_menu.model.dart';

import 'side_menu_service.service.dart';
import 'side_menu_state.dart';

@ScreenService(screenState: $SideMenuState) 
class SideMenuService {
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
    SideMenu sideMenu = WrenchStore.get<SideMenu>() ?? SideMenu();
    sideMenu = sideMenu.rebuild((b) => b..activeIndex = index);
    updateState1(sideMenu);
  }

  void clearConnectScreen() {
    updateState1(Connect(), reload: false);
  }
}
    