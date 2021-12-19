import 'package:built_collection/built_collection.dart';
import 'package:mustang_core/mustang_core.dart';

@appModel
class $Memory {
  @InitField(false)
  @SerializeField(false)
  late bool busy;

  @InitField('')
  @SerializeField(false)
  late String errorMsg;

  @InitField(false)
  late bool clearScreenCache;

  @InitField({})
  late BuiltMap<String, String> targetAppState;

  @InitField([])
  late BuiltList<BuiltMap<String, String>> targetAppEvents;

  @InitField('{}')
  late String eventData;
}
