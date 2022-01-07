import 'package:built_collection/built_collection.dart';
import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/app_event.model.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.service.dart';
import 'package:mustang_viewer/src/screens/memory/memory_state.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
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
    Memory memory = WrenchStore.get<Memory>()!;
    Connect connect = WrenchStore.get<Connect>()!;
    try {
      Stream<Event> events = connect.vmService!.onExtensionEvent;
      await connect.vmService!.streamListen(EventKind.kExtension);
      await for (Event event in events) {
        memory = WrenchStore.get<Memory>()!;
        if (event.extensionKind == AppConstants.mustangAppEvent) {
          Map<String, dynamic> eventData = event.extensionData?.data ?? {};

          if (eventData.isNotEmpty &&
              !eventData.containsKey(_appEventModelNameKey) &&
              !eventData.containsKey(_appEventModelDataKey)) {
            continue;
          }

          String modelName = eventData[_appEventModelNameKey];
          String modelData = eventData[_appEventModelDataKey];

          AppEvent appEvent = AppEvent().rebuild(
            (b) => b
              ..timestamp = event.timestamp ?? 0
              ..modelName = modelName
              ..modelData = modelData,
          );

          memory = memory.rebuild(
            (b) => b
              ..appTimelineEvents = memory.appTimelineEvents
                  .rebuild((b) => b.add(appEvent))
                  .toBuilder()
              ..appState = memory.appState
                  .rebuild((b) => b.updateValue(modelName, (_) => appEvent,
                      ifAbsent: () => appEvent))
                  .toBuilder()
              ..modelViewEvent = appEvent.toBuilder()
              ..scroll = true,
          );

          List<AppEvent> filteredTimelineEvents = memory.appTimelineEvents
              .where((e) => e.modelName
                  .toLowerCase()
                  .contains(memory.timelineModelSearchText.toLowerCase()))
              .toList();

          memory = memory.rebuild(
            (b) => b
              ..filteredAppTimelineEvents = filteredTimelineEvents.isNotEmpty
                  ? ListBuilder<AppEvent>(filteredTimelineEvents)
                  : ListBuilder<AppEvent>(memory.appTimelineEvents)
              ..selectedTimelineModelIndex = filteredTimelineEvents.length - 1,
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

  void filterAppTimelineEvents(String modelSearchText) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    List<AppEvent> filteredTimelineEvents = memory.appTimelineEvents
        .where((e) =>
            e.modelName.toLowerCase().contains(modelSearchText.toLowerCase()))
        .toList();

    memory = memory.rebuild(
      (b) => b
        ..timelineModelSearchText = modelSearchText
        ..filteredAppTimelineEvents = filteredTimelineEvents.isNotEmpty
            ? ListBuilder<AppEvent>(filteredTimelineEvents)
            : ListBuilder<AppEvent>(memory.appTimelineEvents)
        ..modelViewEvent = filteredTimelineEvents.isNotEmpty
            ? filteredTimelineEvents.last.toBuilder()
            : AppEvent().toBuilder()
        ..selectedTimelineModelIndex = filteredTimelineEvents.length - 1,
    );

    updateState1(memory);
  }

  void onChangeModelViewSearch(String searchText) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    AppEvent selectedModel = memory.modelViewEvent ?? AppEvent();
    List<int> highlightIndices = AppTextHighlighter.findHighlights(
      selectedModel.modelData.toLowerCase(),
      searchText.toLowerCase(),
    );
    memory = memory.rebuild(
      (b) => b
        ..modelDataSearchText = searchText
        ..selectedModelDataSearchTextIndex = 0
        ..modelDataSearchTextIndices = ListBuilder<int>(highlightIndices),
    );
    updateState1(memory);
  }

  void onClickOfAppStateModel(String modelName) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    if (memory.appState.toMap().containsKey(modelName)) {
      AppEvent appEvent = memory.appState[modelName]!;
      memory = memory.rebuild(
        (b) => b
          ..modelViewEvent = appEvent.toBuilder()
          ..selectedAppStateModel = modelName
          ..selectedTimelineModelIndex = -1
          ..modelDataSearchTextIndices = ListBuilder([])
          ..modelDataSearchText = ''
          ..scroll = false,
      );
      updateState1(memory);
    }
  }

  void onNavigateModelViewSearchMatches(int index) {
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

  void onClickTimelineEvent(int eventIndex) {
    Memory memory = WrenchStore.get<Memory>() ?? Memory();
    AppEvent appEvent =
        memory.filteredAppTimelineEvents.toList().elementAt(eventIndex);
    memory = memory.rebuild(
      (b) => b
        ..modelViewEvent = appEvent.toBuilder()
        ..selectedAppStateModel = ''
        ..selectedTimelineModelIndex = eventIndex
        ..modelDataSearchTextIndices = ListBuilder([])
        ..modelDataSearchText = ''
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
