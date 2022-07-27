import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:rtc_app/models/serializers.dart';

import 'message.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  AppState._();
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AppState.serializer, this)
        as Map<String, dynamic>;
  }

  static AppState fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AppState.serializer, json)!;
  }

  static void _initializeBuilder(AppStateBuilder b) {
    b.messages = ListBuilder<Message>();
    b.isLoading = false;
    b.isInitializing = false;
    b.appUserId = 'userId';
  }

  static Serializer<AppState> get serializer => _$appStateSerializer;

  bool get isInitializing;
  bool get isLoading;
  BuiltList<Message> get messages;
  String get appUserId;
}
