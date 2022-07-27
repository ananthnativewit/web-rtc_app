// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable<Object?> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'isInitializing',
      serializers.serialize(object.isInitializing,
          specifiedType: const FullType(bool)),
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
      'messages',
      serializers.serialize(object.messages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Message)])),
      'appUserId',
      serializers.serialize(object.appUserId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'isInitializing':
          result.isInitializing = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'messages':
          result.messages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Message)]))!
              as BuiltList<Object?>);
          break;
        case 'appUserId':
          result.appUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final bool isInitializing;
  @override
  final bool isLoading;
  @override
  final BuiltList<Message> messages;
  @override
  final String appUserId;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (new AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {required this.isInitializing,
      required this.isLoading,
      required this.messages,
      required this.appUserId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isInitializing, r'AppState', 'isInitializing');
    BuiltValueNullFieldError.checkNotNull(isLoading, r'AppState', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(messages, r'AppState', 'messages');
    BuiltValueNullFieldError.checkNotNull(appUserId, r'AppState', 'appUserId');
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        isInitializing == other.isInitializing &&
        isLoading == other.isLoading &&
        messages == other.messages &&
        appUserId == other.appUserId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, isInitializing.hashCode), isLoading.hashCode),
            messages.hashCode),
        appUserId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppState')
          ..add('isInitializing', isInitializing)
          ..add('isLoading', isLoading)
          ..add('messages', messages)
          ..add('appUserId', appUserId))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  bool? _isInitializing;
  bool? get isInitializing => _$this._isInitializing;
  set isInitializing(bool? isInitializing) =>
      _$this._isInitializing = isInitializing;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  ListBuilder<Message>? _messages;
  ListBuilder<Message> get messages =>
      _$this._messages ??= new ListBuilder<Message>();
  set messages(ListBuilder<Message>? messages) => _$this._messages = messages;

  String? _appUserId;
  String? get appUserId => _$this._appUserId;
  set appUserId(String? appUserId) => _$this._appUserId = appUserId;

  AppStateBuilder() {
    AppState._initializeBuilder(this);
  }

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isInitializing = $v.isInitializing;
      _isLoading = $v.isLoading;
      _messages = $v.messages.toBuilder();
      _appUserId = $v.appUserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              isInitializing: BuiltValueNullFieldError.checkNotNull(
                  isInitializing, r'AppState', 'isInitializing'),
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, r'AppState', 'isLoading'),
              messages: messages.build(),
              appUserId: BuiltValueNullFieldError.checkNotNull(
                  appUserId, r'AppState', 'appUserId'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        messages.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
