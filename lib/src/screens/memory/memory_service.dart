import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.service.dart';
import 'package:mustang_viewer/src/screens/memory/memory_state.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:vm_service/vm_service.dart';

@ScreenService(screenState: $MemoryState)
class MemoryService {
  Future<void> memoizedSubscribe() {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      memory = memory.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1(memory, reload: false);
    }
    return memoizeScreen(subscribe);
  }

  Future<void> subscribe({
    bool showBusy = true,
  }) async {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    Connect connect = WrenchStore.get<Connect>() ?? Connect();
    if (showBusy) {
      memory = memory.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
    }
    updateState1(memory);

    try {
      Stream<Event> eventStream =
          connect.vmService!.onEvent(EventKind.kExtension);
      await connect.vmService!.streamListen(EventKind.kExtension);
      await for (Event event in eventStream) {
        if (event.extensionKind == AppConstants.eventExtension) {
          print(event.extensionData);
        }
      }
    } catch (e) {
      memory = memory.rebuild((b) => b..errorMsg = '$e');
      updateState1(memory);
    }
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }
}
