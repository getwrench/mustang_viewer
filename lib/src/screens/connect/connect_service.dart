import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/screens/connect/connect_service.service.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'connect_state.dart';

@ScreenService(screenState: $ConnectState)
class ConnectService {
  Future<void> connect(String wsUri) async {
    if (wsUri.isEmpty) return;

    Connect connect = WrenchStore.get<Connect>() ?? Connect();
    try {
      VmService vmService = await vmServiceConnectUri(wsUri);
      connect = connect.rebuild(
        (b) => b
          ..vmService = vmService
          ..connected = true,
      );
    } catch (e) {
      connect = connect.rebuild(
        (b) => b
          ..vmService = null
          ..connected = false
          ..errorOnEvent = '$e',
      );
    } finally {
      updateState1(connect, reload: false);
    }
  }

  void updateWsUri(String wsUri) {
    Connect connect = WrenchStore.get<Connect>() ?? Connect();

    if (wsUri.isEmpty) {
      connect = connect.rebuild(
        (b) => b
          ..wsUri = wsUri
          ..readToSubmit = false,
      );
    } else {
      connect = connect.rebuild(
        (b) => b
          ..wsUri = wsUri
          ..readToSubmit = true,
      );
    }
    updateState1(connect);
  }
}
