library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'app_state.dart';
import 'message.dart';

part 'serializers.g.dart';

@SerializersFor([
  AppState,
  Message,
])
final Serializers serializers = 
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();