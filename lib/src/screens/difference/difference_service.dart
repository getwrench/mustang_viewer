import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/difference.model.dart';
import 'package:mustang_viewer/src/models/menu.model.dart';

import 'difference_service.service.dart';
import 'difference_state.dart';

@ScreenService(screenState: $DifferenceState) 
class DifferenceService {
  Future<void> memoizedGetData() {
    Difference difference = WrenchStore.get<Difference>() ?? Difference();
    if (difference.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      difference = difference.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1(difference, reload: false);
    }
    return memoizeScreen(getData);
  }
  
  Future<void> getData({
    bool showBusy = true,
  }) async {
    Difference difference = WrenchStore.get<Difference>() ?? Difference();
    if (showBusy) {
      difference = difference.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
      updateState1(difference);
    }
    // Add API calls here, if any
    difference = difference.rebuild((b) => b..busy = false);
    updateState1(difference);
  }

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

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }

  void updateIndex(int index) {
    Menu menu = WrenchStore.get<Menu>() ?? Menu();
    menu = menu.rebuild((b) => b..activeIndex = index);
    updateState1(menu);
  }

  void clearConnectScreen() {
    updateState1(Connect(), reload: false);
  }
}
    