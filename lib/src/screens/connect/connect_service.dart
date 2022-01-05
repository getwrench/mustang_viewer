import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';
import 'package:mustang_viewer/src/screens/connect/connect_service.service.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'connect_state.dart';

@ScreenService(screenState: $ConnectState)
class ConnectService {
  Future<void> connect(String wsUri) async {
    if (wsUri.isEmpty) return;

    Connect connect = Connect();
    try {
      VmService vmService = await vmServiceConnectUri(wsUri);
      connect = connect.rebuild(
        (b) => b
          ..vmService = vmService
          ..connected = true,
      );
    } catch (e) {
      connect = connect.rebuild(
        (b) => b..errorOnEvent = '$e',
      );
    } finally {
      updateState1(connect, reload: false);
    }
  }

  void validateUri(String wsUri) {
    Connect connect = Connect().rebuild(
      (b) => b..readToSubmit = wsUri.isNotEmpty,
    );
    updateState1(connect);
  }

  void clearMemoryScreen() {
    Memory memory = Memory().rebuild(
      (b) => b..clearScreenCache = true,
    );
    updateState1(memory, reload: false);
  }
}
