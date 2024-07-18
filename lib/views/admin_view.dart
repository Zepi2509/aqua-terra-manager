import 'package:flutter/material.dart';

import '../locator.dart';
import '../services/database/animal_service.dart';
import '../services/database/student_service.dart';
import '../services/database/vivarium_service.dart';

//---------------------------------------------------
// Make changes to entire firestore collections
// (not available for regular app users, too dangerous)
//---------------------------------------------------
class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _studentService = locator<StudentService>();
  final _animalService = locator<AnimalService>();
  final _vivariumService = locator<VivariumService>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Mitgliedsliste aus csv importieren"),
          onTap: () =>
              _studentService.importStudentsFromCsv('assets/student_list.csv'),
        ),
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Mitgliedsliste aus firestore Datenbank löschen"),
          onTap: () => _studentService.deleteAllStudents(),
        ),
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Tierliste aus csv importieren"),
          onTap: () =>
              _animalService.importAnimalsFromCsv('assets/animal_list.csv'),
        ),
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Tierliste aus firestore Datenbank löschen"),
          onTap: () => _animalService.deleteAllAnimals(),
        ),
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Vivarienliste aus csv importieren"),
          onTap: () =>
              _vivariumService.importVivariaFromCsv('assets/vivarium_list.csv'),
        ),
        ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text("Vivarienliste aus firestore Datenbank löschen"),
          onTap: () => _vivariumService.deleteAllVivaria(),
        ),
      ],
    );
  }
}
