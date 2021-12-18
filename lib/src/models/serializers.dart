// GENERATED CODE - DO NOT MODIFY BY HAND 

// **************************************************************************
// AppSerializerBuilder
// **************************************************************************
   
import 'dart:convert';    
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:mustang_viewer/src/models/connect.model.dart';
import 'package:mustang_viewer/src/models/memory.model.dart';

part 'serializers.g.dart';

@SerializersFor([
  Connect,
  Memory
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(
        StandardJsonPlugin(),
      ))
    .build();

final List<String> serializerNames = [
  '$Connect',
  '$Memory'
];
    
void json2Type(void Function<T>(T t) update, String modelName, String jsonStr) {
      if(modelName == '$Connect') {
      var model = serializers.deserializeWith(
        Connect.serializer,
        json.decode(jsonStr),
      );
      if (model != null) {
        update(model);
      }
      return;
    }
    if(modelName == '$Memory') {
      var model = serializers.deserializeWith(
        Memory.serializer,
        json.decode(jsonStr),
      );
      if (model != null) {
        update(model);
      }
      return;
    }

}