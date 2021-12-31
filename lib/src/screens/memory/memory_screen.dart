import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/memory/next_search_index_action.dart';
import 'package:mustang_viewer/src/screens/memory/previous_search_index_action.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/current_state.dart';
import 'package:mustang_viewer/src/shared_widgets/data_view.dart';
import 'package:mustang_viewer/src/shared_widgets/timeline.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'memory_service.dart';
import 'memory_state.state.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController currentStateScrollController = ScrollController();
    final ScrollController timelineScrollController = ScrollController();
    final ScrollController dataViewScrollController = ScrollController();

    return StateProvider<MemoryState>(
      state: MemoryState(),
      child: Builder(
        builder: (BuildContext context) {
          MemoryState? state = StateConsumer<MemoryState>().of(context);
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => MemoryService().memoizedSubscribe(),
          );

          if (state!.memory.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.memory.errorMsg.isNotEmpty) {
            Text(state.memory.errorMsg);
          }

          return _body(
            state,
            context,
            currentStateScrollController,
            timelineScrollController,
            dataViewScrollController,
          );
        },
      ),
    );
  }

  Widget _body(
    MemoryState? state,
    BuildContext context,
    ScrollController currentStateScrollController,
    ScrollController timelineScrollController,
    ScrollController dataViewScrollController,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.memory),
        actions: [
          MaterialButton(
            onPressed: () => _disconnect(context, state!),
            child: const Text(AppConstants.disconnect),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
          MaterialButton(
            onPressed: () => showInputDialog(context, state!),
            child: const Text(AppConstants.fetchStoreData),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
          // MaterialButton(
          //   onPressed: () => _fetchCacheData(context, state!),
          //   child: const Text(AppConstants.fetchCacheData),
          //   hoverColor: Theme.of(context).colorScheme.primary,
          // ),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: AppStyles.flex4,
              child: Column(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: CurrentState(
                        state!.memory.appState.toMap(),
                        (modelName) =>
                            MemoryService().showEventDataByModelName(modelName),
                        currentStateScrollController,
                        state.memory.selectedAppStateModel,
                        state.memory.scroll,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Timeline(
                        state.memory.filteredAppEvents.toList(),
                        (eventIndex) => MemoryService()
                            .showEventDataByEventIndex(eventIndex),
                        timelineScrollController,
                        state.memory.selectedAppEventIndex,
                        state.memory.scroll,
                        MemoryService().updatedSelectedModel,
                        state.memory.selectedAppEventName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: AppStyles.flex7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: DataView(
                  state.memory.modelData,
                  state.memory.modelDataSearchText,
                  MemoryService().setSearchTerm,
                  dataViewScrollController,
                  state.memory.modelDataSearchTextIndices.toList(),
                  state.memory.selectedModelDataSearchTextIndex,
                  MemoryService().updateSelectedHighlight,
                  NextSearchIndexAction(),
                  PreviousSearchIndexAction(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _disconnect(BuildContext context, MemoryState state) async {
    DialogUtil.show(context);
    await MemoryService().disconnect();
    Navigator.pop(context);
    if (state.memory.errorOnEvent.isNotEmpty) {
      DialogUtil.showMessage(context, state.memory.errorOnEvent);
    }
    MemoryService().clearConnectScreen();
    Navigator.pushReplacementNamed(context, AppRoutes.connect);
  }

  Future<void> _fetchStoreData(BuildContext context, MemoryState state) async {
    try {
      print('----${state.memory.hiveBoxName}');
      await Process.run(
          'sh', ['lib/scripts/ios_sh.sh', (state.memory.hiveBoxName)]);
      Hive.init('lib/scripts/');
      Box box = await Hive.openBox(state.memory.hiveBoxName);
      Map storeData = {};
      for (var element in box.keys) {
        storeData[element] = box.get(element);
      }
      print('Store Data:$storeData');
    } catch (e) {
      print('exception:$e');
    }
  }

  // Future<void> _fetchCacheData(BuildContext context, MemoryState state) async {
  //   await Process.run(
  //       'sh', ['lib/scripts/ios_sh.sh', (state.memory.hiveBoxName)]);
  //   Hive.init('lib/scripts/');
  //   LazyBox lazyBox = Hive.lazyBox(state.memory.hiveBoxName);
  //   Map cacheData = {};
  //   for (var element in lazyBox.keys) {
  //     cacheData[element] = lazyBox.get(element);
  //   }
  //   print('Cache Data:$cacheData');
  // }

  Future<void> showInputDialog(BuildContext context, MemoryState state) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: TextFormField(
            onChanged: (String hiveBoxName) {
              MemoryService().updateHiveBoxName(hiveBoxName);
            },
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
              hoverColor: Theme.of(context).colorScheme.primary,
            ),
            MaterialButton(
              onPressed: () {
                _fetchStoreData(context, state);
                Navigator.pop(context);
              },
              child: const Text('Fetch'),
              hoverColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
