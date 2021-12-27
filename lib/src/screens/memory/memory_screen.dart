import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_core/mustang_widgets.dart';
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
                        state!.memory.targetAppState.toMap(),
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
                        state.memory.targetAppEvents.toList(),
                        (eventIndex) => MemoryService()
                            .showEventDataByEventIndex(eventIndex),
                        timelineScrollController,
                        state.memory.selectedTimelineModel,
                        state.memory.scroll,
                        MemoryService().updatedSelectedModel,
                        state.memory.selectedModelName,
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
                  state.memory.eventData,
                  state.memory.searchTerm,
                  MemoryService().setSearchTerm,
                  dataViewScrollController,
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
}
