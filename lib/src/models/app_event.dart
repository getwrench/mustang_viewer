import 'package:mustang_core/mustang_core.dart';

@appModel
abstract class $AppEvent {
  @InitField(0)
  late int timestamp;

  @InitField('')
  late String modelName;

  @InitField('{}')
  late String modelData;
}
