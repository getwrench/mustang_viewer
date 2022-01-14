import 'package:mustang_core/mustang_core.dart';
import 'package:vm_service/vm_service.dart';

@appModel
abstract class $Connect {
  @InitField(false)
  @SerializeField(false)
  late bool busy;

  @InitField('')
  @SerializeField(false)
  late String errorMsg;

  @InitField('')
  @SerializeField(false)
  late String errorOnEvent;

  @InitField(false)
  late bool clearScreenCache;

  @SerializeField(false)
  @InitField(false)
  late bool connected;

  @SerializeField(false)
  late VmService vmService;

  @SerializeField(false)
  @InitField(false)
  late bool readToSubmit;
}
