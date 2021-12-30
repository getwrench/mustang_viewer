import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.service.dart';
import 'package:mustang_viewer/src/screens/memory/memory_state.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';
import 'package:pretty_json/pretty_json.dart';
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
          memory = WrenchStore.get<Memory>() ?? Memory();
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

          EventView eventView =
              EventView.fromJson(jsonDecode(encodedEventData));
          String eventDataString = eventView.data;
          int indexOfLastEvent = (memory.targetAppEvents.length - 1);
          if (eventView.label.toLowerCase().contains(memory.searchTerm)) {
            eventDataString = eventView.data;
            List<String> targetAppEvents = memory.targetAppEvents.toList();
            indexOfLastEvent = targetAppEvents.lastIndexWhere((element) {
              eventView = EventView.fromJson(jsonDecode(element));
              return eventView.label.toLowerCase().contains(memory.searchTerm);
            });
          }

          List<String> targetEvents = memory.targetAppEvents.toList();
          List<String> searchedTargetEvent = [];
          for (String event in targetEvents) {
            EventView eventView = EventView.fromJson(jsonDecode(event));
            if (eventView.label.toLowerCase().contains(memory.searchTerm)) {
              searchedTargetEvent.add(event);
            }
          }

          memory = memory.rebuild(
            (b) => b
              ..eventData = eventDataString
              ..searchTargetAppEvents = ListBuilder<String>(searchedTargetEvent)
              ..selectedTimelineModel = indexOfLastEvent,
          );
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

  void updatedSelectedModel(String? modelName) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    List<String> targetEvents = memory.targetAppEvents.toList();
    List<String> searchedTargetEvent = [];
    for (String event in targetEvents) {
      EventView eventView = EventView.fromJson(jsonDecode(event));
      if (eventView.label.toLowerCase().contains(modelName ?? '')) {
        searchedTargetEvent.add(event);
      }
    }
    String eventDataString =
        EventView.fromJson(jsonDecode(searchedTargetEvent.last)).data;
    int indexOfLastEvent = (searchedTargetEvent.length - 1);
    memory = memory.rebuild(
      (b) => b
        ..selectedModelName = modelName
        ..searchTargetAppEvents = ListBuilder<String>(searchedTargetEvent)
        ..eventData = eventDataString
        ..selectedTimelineModel = indexOfLastEvent,
    );
    updateState1(memory);
  }

  void setSearchTerm(String term) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    String prettyEventData = prettyJson(jsonDecode(memory.eventData));
    List<int> highlightIndices = AppTextHighlighter.findHighlights(
      prettyEventData.toLowerCase(),
      term.toLowerCase(),
    );
    memory = memory.rebuild(
      (b) => b
        ..searchTerm = term
        ..indexOfSelectedHighlight = 0
        ..highlightIndices = ListBuilder<int>(highlightIndices),
    );
    updateState1(memory);
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
          ..highlightIndices = ListBuilder([])
          ..searchTerm = ''
          ..scroll = false,
      );
      updateState1(memory);
    }
  }

  void updateSelectedHighlight(int index) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.highlightIndices.isNotEmpty) {
      if ((memory.highlightIndices.length > index) && (index) >= 0) {
        memory = memory.rebuild(
          (b) => b..indexOfSelectedHighlight = index,
        );
        updateState1(memory);
      }
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
        ..highlightIndices = ListBuilder([])
        ..searchTerm = ''
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
