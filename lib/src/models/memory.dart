import 'package:built_collection/built_collection.dart';
import 'package:mustang_core/mustang_core.dart';

import 'app_event.dart';

@appModel
abstract class $Memory {
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
  late BuiltMap<String, $AppEvent> appState;

  @InitField([])
  late BuiltList<$AppEvent> appTimelineEvents;

  @InitField([])
  late BuiltList<$AppEvent> filteredAppTimelineEvents;

  late $AppEvent modelViewEvent;

  @InitField('')
  late String selectedAppStateModel;

  @InitField(-1)
  late int selectedTimelineModelIndex;

  @InitField(true)
  late bool scroll;

  @InitField('')
  late String modelDataSearchText;

  @InitField([])
  late BuiltList<int> modelDataSearchTextIndices;

  @InitField(0)
  late int selectedModelDataSearchTextIndex;

  @InitField('')
  late String timelineModelSearchText;
}
