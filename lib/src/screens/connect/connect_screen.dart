import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'connect_service.service.dart';
import 'connect_state.state.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return StateProvider<ConnectState>(
      state: ConnectState(),
      child: Builder(
        builder: (BuildContext context) {
          ConnectState? state = StateConsumer<ConnectState>().of(context);

          if (state!.connect.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.connect.errorMsg.isNotEmpty) {
            Text(state.connect.errorMsg);
          }

          return _body(state, context, controller);
        },
      ),
    );
  }

  Widget _body(
    ConnectState state,
    BuildContext context,
    TextEditingController controller,
  ) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: AppStyles.width400,
          height: AppStyles.height250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppStyles.padding8),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppConstants.hintServiceUrl,
                  ),
                  maxLines: 1,
                  onChanged: (_) =>
                      ConnectService().validateUri(controller.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppStyles.padding8),
                child: ElevatedButton(
                  onPressed: state.connect.readToSubmit
                      ? () => _connectToApp(
                            context,
                            state,
                            controller,
                          )
                      : null,
                  child: const Text(AppConstants.connect),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectToApp(
    BuildContext context,
    ConnectState state,
    TextEditingController controller,
  ) async {
    DialogUtil.show(context);
    await ConnectService().connect(controller.text);
    Navigator.pop(context);
    if (state.connect.errorOnEvent.isNotEmpty) {
      DialogUtil.showMessage(context, state.connect.errorOnEvent);
      return;
    }
    ConnectService().clearMemoryScreen();
    Navigator.pushReplacementNamed(context, AppRoutes.memory);
  }
}
