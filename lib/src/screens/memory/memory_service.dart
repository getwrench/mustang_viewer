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
  static const String _appEventModelNameKey = 'modelName';
  static const String _appEventModelDataKey = 'modelStr';

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
          String modelName = eventData[_appEventModelNameKey] ?? 'N/A';
          String modelData = eventData[_appEventModelDataKey] ?? '{}';
          String encodedEventData = jsonEncode(EventView(
            timestamp: event.timestamp!,
            modelName: modelName,
            modelData: modelData,
          ).toJson());
          memory = WrenchStore.get<Memory>() ?? Memory();
          memory = memory.rebuild(
            (b) => b
              ..appEvents = memory.appEvents
                  .rebuild((b) => b.add(encodedEventData))
                  .toBuilder()
              ..appState = memory.appState
                  .rebuild((b) => b.updateValue(
                      modelName, (_) => encodedEventData,
                      ifAbsent: () => encodedEventData))
                  .toBuilder()
              ..scroll = true,
          );

          List<String> targetEvents = memory.appEvents.toList();
          List<String> searchedTargetEvent = [];
          for (String event in targetEvents) {
            EventView eventView = EventView.fromJson(jsonDecode(event));
            if (eventView.modelName
                .toLowerCase()
                .contains(memory.modelDataSearchText.toLowerCase())) {
              searchedTargetEvent.add(event);
            }
          }
          String eventDataString =
              EventView.fromJson(jsonDecode(searchedTargetEvent.last))
                  .modelData;
          int indexOfLastEvent = (searchedTargetEvent.length - 1);
          memory = memory.rebuild(
            (b) => b
              ..modelData = eventDataString
              ..filteredAppEvents = ListBuilder<String>(searchedTargetEvent)
              ..selectedAppEventIndex = indexOfLastEvent,
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
    List<String> targetEvents = memory.appEvents.toList();
    List<String> searchedTargetEvent = [];
    for (String event in targetEvents) {
      EventView eventView = EventView.fromJson(jsonDecode(event));
      if (eventView.modelName.toLowerCase().contains(modelName?.toLowerCase() ?? '')) {
        searchedTargetEvent.add(event);
      }
    }
    String eventDataString = '{}';
    int indexOfLastEvent = -1;
    if (searchedTargetEvent.isNotEmpty) {
      eventDataString =
          EventView.fromJson(jsonDecode(searchedTargetEvent.last)).modelData;
      indexOfLastEvent = (searchedTargetEvent.length - 1);
    }

    memory = memory.rebuild(
      (b) => b
        ..selectedAppEventName = modelName
        ..filteredAppEvents = ListBuilder<String>(searchedTargetEvent)
        ..modelData = eventDataString
        ..selectedAppEventIndex = indexOfLastEvent,
    );
    updateState1(memory);
  }

  void setSearchTerm(String term) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    String prettyEventData = prettyJson(jsonDecode(memory.modelData));
    List<int> highlightIndices = AppTextHighlighter.findHighlights(
      prettyEventData.toLowerCase(),
      term.toLowerCase(),
    );
    memory = memory.rebuild(
      (b) => b
        ..modelDataSearchText = term
        ..selectedModelDataSearchTextIndex = 0
        ..modelDataSearchTextIndices = ListBuilder<int>(highlightIndices),
    );
    updateState1(memory);
  }

  void showEventDataByModelName(String modelName) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.appState.toMap().containsKey(modelName)) {
      EventView eventView =
          EventView.fromJson(jsonDecode(memory.appState[modelName]!));
      memory = memory.rebuild(
        (b) => b
          ..modelData = eventView.modelData
          ..selectedAppStateModel = modelName
          ..selectedAppEventIndex = -1
          ..modelDataSearchTextIndices = ListBuilder([])
          ..modelDataSearchText = ''
          ..scroll = false,
      );
      updateState1(memory);
    }
  }

  void updateSelectedHighlight(int index) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.modelDataSearchTextIndices.isNotEmpty) {
      if ((memory.modelDataSearchTextIndices.length > index) && (index) >= 0) {
        memory = memory.rebuild(
          (b) => b..selectedModelDataSearchTextIndex = index,
        );
        updateState1(memory);
      }
    }
  }

  void showEventDataByEventIndex(int eventIndex) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    String eventData = memory.filteredAppEvents.toList().elementAt(eventIndex);
    EventView eventView = EventView.fromJson(jsonDecode(eventData));
    memory = memory.rebuild(
      (b) => b
        ..modelData = eventView.modelData
        ..selectedAppStateModel = ''
        ..selectedAppEventIndex = eventIndex
        ..modelDataSearchTextIndices = ListBuilder([])
        ..modelDataSearchText = ''
        ..scroll = false,
    );
    updateState1(memory);
  }
}
