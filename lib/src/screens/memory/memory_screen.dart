import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/current_state.dart';
import 'package:mustang_viewer/src/shared_widgets/data_view.dart';
import 'package:mustang_viewer/src/shared_widgets/timeline.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';

import 'memory_service.dart';
import 'memory_state.state.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(MemoryState? state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.memory),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: CurrentState(
                  state!.memory.targetAppState.toMap(),
                  (modelName) =>
                      MemoryService().showEventDataByModelName(modelName),
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Timeline(
                  state.memory.targetAppEvents.toList(),
                  (eventIndex) =>
                      MemoryService().showEventDataByEventIndex(eventIndex),
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: DataView(state.memory.eventData),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
