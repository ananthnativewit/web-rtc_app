import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:rtc_app/models/serializers.dart';

part 'message.g.dart';

abstract class Message implements Built<Message, MessageBuilder> {
  Message._();
  factory Message([void Function(MessageBuilder) updates]) = _$Message;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Message.serializer, this)
        as Map<String, dynamic>;
  }

  static Message fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Message.serializer, json)!;
  }

  static Serializer<Message> get serializer => _$messageSerializer;

  String get message;
  String get sender;
  bool get isSystemMessage;

  static Message fromUser(sender, message) {
    return Message((MessageBuilder m) {
      m.sender = sender;
      m.message = message;
      m.isSystemMessage = false;
    });
  }

  static Message fromSystem(message) {
    return Message((MessageBuilder m) {
      m.sender = 'system';
      m.message = message;
      m.isSystemMessage = true;
    });
  }

}
