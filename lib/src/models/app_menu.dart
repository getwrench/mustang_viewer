import 'package:mustang_core/mustang_core.dart';

@appModel 
class $AppMenu {
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

  @InitField(0)
  late int activeIndex;
}
    