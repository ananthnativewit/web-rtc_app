import 'package:state_notifier/state_notifier.dart';

abstract class AppStateNotifier<T> extends StateNotifier<T> {
  AppStateNotifier(T state) : super(state);

  T getState() => state;

  @override
  bool updateShouldNotify(T old, T current) {
    return true;
  }
}
