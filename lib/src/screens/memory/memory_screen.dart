import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/app_menu/app_menu_screen.dart';
import 'package:mustang_viewer/src/screens/memory/next_search_index_action.dart';
import 'package:mustang_viewer/src/screens/memory/previous_search_index_action.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/app_state.dart';
import 'package:mustang_viewer/src/shared_widgets/app_state_timeline.dart';
import 'package:mustang_viewer/src/shared_widgets/model_view.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

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
      body: Center(
        child: Row(
          children: [
            const AppMenuScreen(),
            Expanded(
              flex: AppStyles.flex4,
              child: Column(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      child: AppState(
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
                      child: AppStateTimeline(
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
                child: ModelView(
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
}
