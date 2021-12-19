import 'dart:convert';

import 'package:built_collection/built_collection.dart';
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
      Stream<Event> eventStream =
          connect.vmService!.onEvent(EventKind.kExtension);
      await connect.vmService!.streamListen(EventKind.kExtension);
      await for (Event event in eventStream) {
        if (event.extensionKind == AppConstants.eventExtension) {
          Map<String, dynamic> eventData = event.toJson();
          String eventKey = eventData['extensionData']['modelName'];
          int eventTs = eventData['timestamp'];
          String eventVal = eventData['extensionData']['modelStr'];
          if (eventKey.isNotEmpty && eventVal.isNotEmpty) {
            Map<String, String> eventToPost = {
              eventKey: jsonEncode(EventView(eventTs, eventVal).toJson()),
            };
            memory = memory.rebuild(
              (b) => b
                ..targetAppEvents = memory.targetAppEvents
                    .rebuild((b) =>
                        b.add(MapBuilder<String, String>(eventToPost).build()))
                    .toBuilder()
                ..targetAppState = memory.targetAppState
                    .rebuild((b) => b.updateValue(
                        eventKey, (_) => eventToPost[eventKey]!,
                        ifAbsent: () => eventToPost[eventKey]!))
                    .toBuilder(),
            );
            updateState1(memory);
          }
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

  void showEventDataByModelName(String modelName) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.targetAppState.toMap().containsKey(modelName)) {
      EventView eventView =
          EventView.fromJson(jsonDecode(memory.targetAppState[modelName]!));
      memory = memory.rebuild((b) => b..eventData = eventView.data);
      updateState1(memory);
    }
  }

  void showEventDataByEventIndex(int eventIndex) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    BuiltMap<String, String> event =
        memory.targetAppEvents.toList().elementAt(eventIndex);
    EventView eventView = EventView.fromJson(jsonDecode(event.values.first));
    memory = memory.rebuild(
      (b) => b..eventData = eventView.data,
    );
    updateState1(memory);
  }
}
