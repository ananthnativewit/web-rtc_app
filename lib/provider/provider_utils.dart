import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtc_app/models/app_state.dart';
import 'package:rtc_app/view_models/app_view_model.dart';

extension ProviderUtils on BuildContext {
  AppViewModel get appViewModel => read<AppViewModel>();
  AppState get appState => watch<AppState>();
}

mixin AppProviderMixin<S extends StatefulWidget> on State<S> {
  AppViewModel get appViewModel => context.appViewModel;
  AppState get appState => context.appState;
}
