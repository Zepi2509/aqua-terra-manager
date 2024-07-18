import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/models/student.dart';
import 'package:aqua_terra_manager/models/vivarium.dart';
import 'package:aqua_terra_manager/services/lists_navigator_service.dart';
import 'package:aqua_terra_manager/views/vivarium_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import '../services/database/student_service.dart';
import '../services/database/vivarium_service.dart';

//-----------------------------------------------
// Detailed information about a single vivarium
//-----------------------------------------------
class VivariumDetailView extends StatelessWidget {
  VivariumDetailView({super.key});

  final _prefs = locator<SharedPreferences>();
  final _listsNavigatorService = locator<ListsNavigatorService>();

  final _vivariumService = locator<VivariumService>();
  final _studentService = locator<StudentService>();

  @override
  Widget build(BuildContext context) {
    String vivariumId = _prefs.getString('vivariumId') ?? "";

    return FutureBuilder(
      future: _vivariumService.getVivariumDetails(vivariumId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final vivarium = snapshot.data!;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildVivariumCard(context, vivarium),
                _buildAnimalCard(context, vivarium),
                _buildStudentCard(context, vivarium),
              ],
            ),
          ),
          bottomNavigationBar:
              _buildBottomAppBar(context, vivarium, vivariumId),
        );
      },
    );
  }

  _buildVivariumCard(BuildContext context, Vivarium vivarium) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(SizeConstants.s300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: FontConstants.s300),
            child: Column(
              children: [
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  title: Text(vivarium.name),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConstants.s300),
                    child: Row(children: [
                      Chip(
                        avatar: const Icon(Icons.straighten_rounded),
                        label: Text(
                            '${vivarium.height}x${vivarium.width}x${vivarium.depth}'),
                      ),
                      SizedBox(width: SizeConstants.s300),
                      Chip(
                        avatar: const Icon(Icons.thermostat_rounded),
                        label:
                            Text('${vivarium.tempMin}-${vivarium.tempMax}°C'),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildAnimalCard(BuildContext context, Vivarium vivarium) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(SizeConstants.s300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: SizeConstants.s300),
            child: Column(
              children: [
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  title: const Text('Bewohner'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConstants.s300),
                  child: Wrap(
                    spacing: SizeConstants.s300,
                    alignment: WrapAlignment.center,
                    children: vivarium.inhabitants.map((inhabitant) {
                      return GestureDetector(
                        child: Chip(
                          label: Text(inhabitant),
                          // Add icon for the species of the inhabitant
                          avatar: const Icon(Icons.pets),
                        ),
                        onTap: () {
                          _prefs.setString('animalId', inhabitant);
                          _listsNavigatorService.navigateToAnimalDetails();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStudentCard(BuildContext context, Vivarium vivarium) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(SizeConstants.s300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: SizeConstants.s300),
            child: Column(
              children: [
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  title: const Text('Pfleger'),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConstants.s300),
                  child: Wrap(
                    spacing: SizeConstants.s300,
                    alignment: WrapAlignment.center,
                    children: vivarium.responsible.map((studentId) {
                      return FutureBuilder(
                        future: _studentService.getStudentDetails(studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                                  ConnectionState.done ||
                              snapshot.data == null) {
                            return Container();
                          }

                          Student student = snapshot.data?['student'];

                          return GestureDetector(
                            child: Chip(
                              label: Text(
                                  '${student.firstname} ${student.lastname}'),
                              // Add icon for the species of the inhabitant
                              avatar: const Icon(Icons.pets),
                            ),
                            onTap: () {
                              _prefs.setString('studentId', studentId);
                              _listsNavigatorService.navigateToStudentDetails();
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomAppBar(
      BuildContext context, Vivarium vivarium, String vivariumId) {
    return BottomAppBar(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () => _displayDeleteForm(context, vivarium),
          ),
          SizedBox(width: SizeConstants.s300),
          FloatingActionButton(
            child: const Icon(Icons.edit_rounded),
            onPressed: () {
              _prefs.setString('vivariumToEdit', vivariumId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VivariumEditView(),
                  ));
            },
          )
        ],
      ),
    );
  }

  _displayDeleteForm(BuildContext context, Vivarium vivarium) {
    return showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text('${vivarium.name} unwiderruflich löschen?'),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () {
                  _vivariumService.deleteVivarium(vivarium.name);
                  Navigator.pop(context); // close alert dialog
                  Navigator.pop(context); // close deleted detail view
                },
                child: const Text('Löschen'),
              ),
            ],
          );
        });
  }
}
