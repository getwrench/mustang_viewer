import 'package:mustang_core/mustang_core.dart';

@appModel
class $CacheStore {
  @InitField(false)
  @SerializeField(false)
  late bool busy;

  @InitField('')
  @SerializeField(false)
  late String errorMsg;

  @InitField(false)
  late bool clearScreenCache;

  @InitField('')
  late String hiveBoxName;

  @InitField('{}')
  late String cacheModelData;

  @InitField('')
  late String applicationPkgName;
}
