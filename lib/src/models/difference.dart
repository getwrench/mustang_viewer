import 'package:mustang_core/mustang_core.dart';

@appModel 
class $Difference {
  @InitField(false)
  @SerializeField(false)
  late bool busy;

  @InitField('')
  @SerializeField(false)
  late String errorMsg;

  @InitField('')
  @SerializeField(false)
  late String errorMsgOnEvent;
  
  @InitField(false)
  late bool clearScreenCache;
}
    