import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/app_menu/app_menu_screen.dart';
import 'package:mustang_viewer/src/screens/shared_services/next_search_index_action.dart';
import 'package:mustang_viewer/src/screens/shared_services/previous_search_index_action.dart';
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
    final TextEditingController dataViewSearchTextController =
        TextEditingController();

    return StateProvider<MemoryState>(
      state: MemoryState(),
      child: Builder(
        builder: (BuildContext context) {
          MemoryState state = StateConsumer<MemoryState>().of(context)!;

          dataViewSearchTextController.value = TextEditingValue(
            text: state.memory.modelDataSearchText,
            selection: TextSelection.collapsed(
                offset: state.memory.modelDataSearchText.length),
          );

          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => MemoryService().memoizedSubscribe(),
          );

          if (state.memory.busy) {
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
            dataViewSearchTextController,
          );
        },
      ),
    );
  }

  Widget _body(
    MemoryState? state,
    BuildContext context,
    ScrollController appStateScrollController,
    ScrollController appStateTimelineScrollController,
    ScrollController modelViewScrollController,
    TextEditingController dataViewSearchTextController,
  ) {
    print('---${state?.memory.modelViewEvent?.modelData}');
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
                            MemoryService().onClickOfAppStateModel(modelName),
                        appStateScrollController,
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
                        state.memory.filteredAppTimelineEvents.toList(),
                        (eventIndex) =>
                            MemoryService().onClickTimelineEvent(eventIndex),
                        appStateTimelineScrollController,
                        state.memory.selectedTimelineModelIndex,
                        state.memory.scroll,
                        MemoryService().filterAppTimelineEvents,
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
                  state.memory.modelViewEvent?.modelData ?? '{}',
                  state.memory.modelDataSearchText,
                  MemoryService().onChangeModelViewSearch,
                  modelViewScrollController,
                  state.memory.modelDataSearchTextIndices.toList(),
                  state.memory.selectedModelDataSearchTextIndex,
                  MemoryService().onNavigateModelViewSearchMatches,
                  NextSearchIndexAction(
                      MemoryService().onNavigateModelViewSearchMatches),
                  PreviousSearchIndexAction(
                      MemoryService().onNavigateModelViewSearchMatches),
                  dataViewSearchTextController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
