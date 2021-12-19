import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/connect/connect_service.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'connect_state.state.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(ConnectState? state, BuildContext context) {
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
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: AppConstants.hintServiceUrl,
                    labelText: AppConstants.debugServiceUrl,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 1,
                  onChanged: (text) => ConnectService().updateWsUri(text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppStyles.padding8),
                child: ElevatedButton(
                  onPressed: state!.connect.readToSubmit
                      ? () => _connectToApp(context, state)
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

  Future<void> _connectToApp(BuildContext context, ConnectState? state) async {
    DialogUtil.show(context);
    await ConnectService().connect(state?.connect.wsUri ?? '');
    Navigator.pop(context);
    if (state?.connect.errorOnEvent.isNotEmpty ?? false) {
      DialogUtil.showMessage(context, state!.connect.errorOnEvent);
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.memory);
  }
}
