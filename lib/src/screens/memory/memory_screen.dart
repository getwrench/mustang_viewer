import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
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

          if (state?.memory.busy ?? false) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state?.memory.errorMsg.isNotEmpty ?? false) {
            Text(state?.memory.errorMsg ?? AppConstants.unknownError);
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
      body: const Text('asd'),
    );
  }
}
