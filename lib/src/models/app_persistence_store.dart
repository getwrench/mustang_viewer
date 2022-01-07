import 'package:built_collection/built_collection.dart';
import 'package:mustang_core/mustang_core.dart';

@appModel
class $AppPersistenceStore {
  @InitField(false)
  @SerializeField(false)
  late bool busy;

  @InitField('')
  @SerializeField(false)
  late String errorMsg;

  @InitField(false)
  late bool clearScreenCache;

  @InitField('')
  late String storeName;

  @InitField('{}')
  late String data;

  @InitField('')
  late String appPkgName;

  @InitField('')
  late String modelDataSearchText;

  @InitField([])
  late BuiltList<int> modelDataSearchTextIndices;

  @InitField(0)
  late int selectedModelDataSearchTextIndex;

  @InitField('Android')
  late String osType;
}
