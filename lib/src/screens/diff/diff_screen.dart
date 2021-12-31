import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/screens/app_menu/app_menu_screen.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';

import 'diff_state.state.dart';
import 'diff_service.dart';

class DiffScreen extends StatelessWidget {
  const DiffScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateProvider<DiffState>(
      state: DiffState(),
      child: Builder(
        builder: (BuildContext context) {
          DiffState? state = StateConsumer<DiffState>().of(context);
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => DifferenceService().memoizedGetData(),
          );

          if (state?.difference.busy ?? false) {
            return const AppProgressIndicator();
          }

          if (state?.difference.errorMsg.isNotEmpty ?? false) {
            Text(state?.difference.errorMsg ?? 'Unknown error');
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(DiffState? state, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const AppMenuScreen(),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Container(), // TODO: Add support to compare
              ),
            ),
          ],
        ),
      ),
    );
  }
}
