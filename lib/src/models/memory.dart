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

  @InitField('')
  @SerializeField(false)
  late String errorOnEvent;

  @InitField(false)
  late bool clearScreenCache;

  @InitField({})
  late BuiltMap<String, String> appState;

  @InitField([])
  late BuiltList<String> appEvents;

  @InitField([])
  late BuiltList<String> filteredAppEvents;

  @InitField('{}')
  late String modelData;

  @InitField('')
  late String selectedAppStateModel;

  @InitField(-1)
  late int selectedAppEventIndex;

  @InitField(true)
  late bool scroll;

  @InitField('')
  late String modelDataSearchText;

  @InitField([])
  late BuiltList<int> modelDataSearchTextIndices;

  @InitField(0)
  late int selectedModelDataSearchTextIndex;

  @InitField('')
  late String selectedAppEventName;

  @InitField('')
  late String hiveBoxName;
}
