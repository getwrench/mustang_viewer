import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/shared_widgets/app_menu.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'difference_state.state.dart';
import 'difference_service.dart';

class DifferenceScreen extends StatelessWidget {
  const DifferenceScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateProvider<DifferenceState>(
      state: DifferenceState(),
      child: Builder(
        builder: (BuildContext context) {
          DifferenceState? state = StateConsumer<DifferenceState>().of(context);
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => DifferenceService().memoizedGetData(),
          );

          if (state?.difference.busy ?? false) {
            return const CircularProgressIndicator();
          }

          if (state?.difference.errorMsg.isNotEmpty ?? false) {
            Text(state?.difference.errorMsg ?? 'Unknown error');
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(DifferenceState? state, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            AppMenu(
              disconnect: () => _disconnect(context, state!),
              selectedIndex: state!.menu.activeIndex,
              updateIndex: DifferenceService().updateIndex,
            ),
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

  Future<void> _disconnect(
    BuildContext context,
    DifferenceState state,
  ) async {
    DialogUtil.show(context);
    await DifferenceService().disconnect();
    Navigator.pop(context);
    if (state.difference.errorMsgOnEvent.isNotEmpty) {
      DialogUtil.showMessage(context, state.difference.errorMsgOnEvent);
    }
    DifferenceService().clearConnectScreen();
    Navigator.pushReplacementNamed(context, AppRoutes.connect);
  }
}
