// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Message> _$messageSerializer = new _$MessageSerializer();

class _$MessageSerializer implements StructuredSerializer<Message> {
  @override
  final Iterable<Type> types = const [Message, _$Message];
  @override
  final String wireName = 'Message';

  @override
  Iterable<Object?> serialize(Serializers serializers, Message object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'sender',
      serializers.serialize(object.sender,
          specifiedType: const FullType(String)),
      'isSystemMessage',
      serializers.serialize(object.isSystemMessage,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Message deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sender':
          result.sender = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isSystemMessage':
          result.isSystemMessage = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Message extends Message {
  @override
  final String message;
  @override
  final String sender;
  @override
  final bool isSystemMessage;

  factory _$Message([void Function(MessageBuilder)? updates]) =>
      (new MessageBuilder()..update(updates))._build();

  _$Message._(
      {required this.message,
      required this.sender,
      required this.isSystemMessage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(message, r'Message', 'message');
    BuiltValueNullFieldError.checkNotNull(sender, r'Message', 'sender');
    BuiltValueNullFieldError.checkNotNull(
        isSystemMessage, r'Message', 'isSystemMessage');
  }

  @override
  Message rebuild(void Function(MessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageBuilder toBuilder() => new MessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
        message == other.message &&
        sender == other.sender &&
        isSystemMessage == other.isSystemMessage;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, message.hashCode), sender.hashCode),
        isSystemMessage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Message')
          ..add('message', message)
          ..add('sender', sender)
          ..add('isSystemMessage', isSystemMessage))
        .toString();
  }
}

class MessageBuilder implements Builder<Message, MessageBuilder> {
  _$Message? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _sender;
  String? get sender => _$this._sender;
  set sender(String? sender) => _$this._sender = sender;

  bool? _isSystemMessage;
  bool? get isSystemMessage => _$this._isSystemMessage;
  set isSystemMessage(bool? isSystemMessage) =>
      _$this._isSystemMessage = isSystemMessage;

  MessageBuilder();

  MessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _sender = $v.sender;
      _isSystemMessage = $v.isSystemMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Message other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Message;
  }

  @override
  void update(void Function(MessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Message build() => _build();

  _$Message _build() {
    final _$result = _$v ??
        new _$Message._(
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'Message', 'message'),
            sender: BuiltValueNullFieldError.checkNotNull(
                sender, r'Message', 'sender'),
            isSystemMessage: BuiltValueNullFieldError.checkNotNull(
                isSystemMessage, r'Message', 'isSystemMessage'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
