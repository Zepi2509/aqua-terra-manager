import 'package:aqua_terra_manager/notifier/theme_change_notifier.dart';
import 'package:aqua_terra_manager/services/database/animal_service.dart';
import 'package:aqua_terra_manager/services/database/student_service.dart';
import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:aqua_terra_manager/services/dynamic_link_service.dart';
import 'package:aqua_terra_manager/services/lists_navigator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/authentication_service.dart';

var locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerSingleton<ThemeChangeNotifier>(ThemeChangeNotifier());

  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(
      () => StudentService(firestore: FirebaseFirestore.instance));
  locator.registerLazySingleton(
      () => AnimalService(firestore: FirebaseFirestore.instance));
  locator.registerLazySingleton(
      () => VivariumService(firestore: FirebaseFirestore.instance));
  locator.registerLazySingleton(() => DynamicLinksService());
  locator.registerLazySingleton(() => ListsNavigatorService());
}
