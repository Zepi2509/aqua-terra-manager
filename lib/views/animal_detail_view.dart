import 'package:aqua_terra_manager/views/animal_edit_view.dart';
import 'package:aqua_terra_manager/widgets/vivarium_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../locator.dart';
import '../models/animal.dart';
import '../services/database/animal_service.dart';

//------------------------------------------------
// Detailed information about a single animal
// (or a single animal group in case of Guppys etc.)
//-------------------------------------------------
class AnimalDetailView extends StatelessWidget {
  AnimalDetailView({super.key});

  final _prefs = locator<SharedPreferences>();

  final _animalService = locator<AnimalService>();

  @override
  Widget build(BuildContext context) {
    String animalId = _prefs.getString('animalId') ?? "";

    return FutureBuilder(
      future: _animalService.getAnimalDetails(animalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        Animal animal = snapshot.data?["animal"];
        String vivariumId = snapshot.data!["vivariumId"];

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 1,
                  margin: EdgeInsets.all(SizeConstants.s300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: double.infinity,
                    height: SizeConstants.s900 * 1.618,
                    child: animal.image != ''
                        ? Image.network(
                            animal.image,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                ),
                _buildAnimalCard(context, animal),
                VivariumCard(vivariumId),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomAppBar(context, animal, vivariumId),
        );
      },
    );
  }

  _buildAnimalCard(BuildContext context, Animal animal) {
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
                  title: Text(animal.name),
                  subtitle: Wrap(
                    children: [
                      Text('${animal.speciesTrivial} - '),
                      Text(
                        animal.speciesScientific,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      animal.sex != Sex.unknown
                          ? Chip(
                              avatar: const Icon(Icons.male_rounded),
                              label: Text(animal.sex.label),
                            )
                          : Container(),
                      SizedBox(width: SizeConstants.s300),
                      animal.weight != null
                          ? Chip(
                              avatar: const Icon(Icons.class_rounded),
                              label: Text('${animal.weight}g'),
                            )
                          : Container(),
                      SizedBox(width: SizeConstants.s300),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBottomAppBar(BuildContext context, Animal animal, String vivariumId) {
    return BottomAppBar(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () => _displayDeleteForm(context, animal),
          ),
          SizedBox(width: SizeConstants.s300),
          FloatingActionButton(
            child: const Icon(Icons.edit_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  _prefs.setString('animalToEdit', animal.name);
                  return const AnimalEditView();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _displayDeleteForm(BuildContext context, Animal animal) {
    return showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text('${animal.name} unwiderruflich löschen?'),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () {
                  _animalService.deleteAnimal(animal.name);
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
