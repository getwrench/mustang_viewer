import 'dart:convert';

import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.service.dart';
import 'package:mustang_viewer/src/screens/memory/memory_state.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';
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
      Stream<Event> eventStream = connect.vmService!.onExtensionEvent;
      await connect.vmService!.streamListen(EventKind.kExtension);
      await for (Event event in eventStream) {
        if (event.extensionKind == AppConstants.eventExtension) {
          Map<String, dynamic> eventData = event.extensionData?.data ?? {};
          String eventKey = eventData['modelName'] ?? 'N/A';
          String eventVal = eventData['modelStr'] ?? '{}';
          String encodedEventData = jsonEncode(
              EventView(event.timestamp!, eventVal, eventKey).toJson());
          memory = memory.rebuild(
            (b) => b
              ..targetAppEvents = memory.targetAppEvents
                  .rebuild((b) => b.add(encodedEventData))
                  .toBuilder()
              ..targetAppState = memory.targetAppState
                  .rebuild((b) => b.updateValue(
                      eventKey, (_) => encodedEventData,
                      ifAbsent: () => encodedEventData))
                  .toBuilder()
              ..scroll = true,
          );
          memory = memory.rebuild((b) => b.eventData =
              EventView.fromJson(jsonDecode(memory.targetAppEvents.last)).data);
          updateState1(memory);
        }
      }
    } catch (e) {
      memory = memory.rebuild(
        (b) => b..errorMsg = '$e',
      );
      updateState1(memory);
    }
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }

  void showEventDataByModelName(String modelName) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.targetAppState.toMap().containsKey(modelName)) {
      EventView eventView =
          EventView.fromJson(jsonDecode(memory.targetAppState[modelName]!));
      memory = memory.rebuild(
        (b) => b
          ..eventData = eventView.data
          ..selectedAppStateModel = modelName
          ..selectedTimelineModel = -1
          ..scroll = false,
      );
      updateState1(memory);
    }
  }

  void showEventDataByEventIndex(int eventIndex) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    String eventData = memory.targetAppEvents.toList().elementAt(eventIndex);
    EventView eventView = EventView.fromJson(jsonDecode(eventData));
    memory = memory.rebuild(
      (b) => b
        ..eventData = eventView.data
        ..selectedAppStateModel = ''
        ..selectedTimelineModel = eventIndex
        ..scroll = false,
    );
    updateState1(memory);
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

  void clearConnectScreen() {
    updateState1(Connect(), reload: false);
  }
}
