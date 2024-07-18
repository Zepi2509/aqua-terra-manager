import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'locator.dart';

Future<void> main() async {
  await initializeDateFormatting(
      "de_DE"); // needed to display calendar in German
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  /*
  * To use the emulator in debug mode
  * */

  // if (kDebugMode) {
  //   FirebaseAuth.instance.useAuthEmulator('149.222.135.31', 9099);
  // }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const App());
  });
}
