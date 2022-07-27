import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rtc_app/view_models/app_view_model.dart';
import 'package:rtc_app/views/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AppProvider(child: MyApp())
  );
}




