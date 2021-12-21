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
  late BuiltMap<String, String> targetAppState;

  @InitField([])
  late BuiltList<String> targetAppEvents;

  @InitField('{}')
  late String eventData;

  @InitField('')
  late String selectedAppStateModel;

  @InitField(-1)
  late int selectedTimelineModel;

  @InitField(true)
  late bool scroll;

  @InitField('')
  late String searchTerm;

  @InitField(0)
  late int selectedHighlight;
}
