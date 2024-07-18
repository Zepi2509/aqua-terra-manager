import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/services/database/animal_service.dart';
import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/animal.dart';

//----------------------------------------------------
// Edit data of a single animal
// (or a single animal group in case of Guppys etc.)
//-----------------------------------------------------
class AnimalEditView extends StatefulWidget {
  const AnimalEditView({super.key});

  @override
  State<AnimalEditView> createState() => _AnimalEditViewState();
}

class _AnimalEditViewState extends State<AnimalEditView> {
  final _prefs = locator<SharedPreferences>();

  final _animalService = locator<AnimalService>();

  final _vivariumService = locator<VivariumService>();

  final _formKey = GlobalKey<FormState>();

  String? _sexError;

  @override
  Widget build(BuildContext context) {
    String animalId = _prefs.getString('animalToEdit') ?? '';

    return FutureBuilder(
      future: _vivariumService.getVivariaIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        var vivariaIds = snapshot.data ?? List.empty();

        return FutureBuilder(
          future: _animalService.getAnimalDetails(animalId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final Animal? animal = snapshot.data?['animal'];
            final String vivariumId = snapshot.data?['vivariumId'] ?? '';

            final nameController = animal == null
                ? TextEditingController()
                : TextEditingController(text: animal.name);
            final speciesTrivialController = animal == null
                ? TextEditingController()
                : TextEditingController(text: animal.speciesTrivial);
            final speciesScientificController = animal == null
                ? TextEditingController()
                : TextEditingController(text: animal.speciesScientific);
            final sexController = TextEditingController();
            final weightController = animal == null
                ? TextEditingController()
                : TextEditingController(
                    text:
                        animal.weight == null ? '' : animal.weight.toString());
            final countController = animal == null
                ? TextEditingController()
                : TextEditingController(
                    text: animal.count == null ? '' : animal.count.toString());
            final imageController = animal == null
                ? TextEditingController()
                : TextEditingController(text: animal.image);
            final vivariumController = TextEditingController();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.s500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Dieses Feld darf nicht leer sein';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Name'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: speciesTrivialController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Dieses Feld darf nicht leer sein';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Art (trivial)'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: speciesScientificController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Dieses Feld darf nicht leer sein';
                            }
                            return null;
                          },
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Art (wissenschaftlich)'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: DropdownMenu(
                          controller: sexController,
                          label: const Text('Geschlecht'),
                          width: MediaQuery.of(context).size.width -
                              SizeConstants.s500 * 2,
                          inputDecorationTheme:
                              const InputDecorationTheme(filled: true),
                          enableSearch: false,
                          initialSelection: animal?.sex,
                          dropdownMenuEntries: _buildSexEntries(),
                          errorText: _sexError,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: weightController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp("[.0-9]")))
                          ],
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Gewicht'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: countController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp("[.0-9]")))
                          ],
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Anzahl'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Foto (URL)'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: DropdownMenu(
                          controller: vivariumController,
                          label: const Text('Vivarium'),
                          width: MediaQuery.of(context).size.width -
                              SizeConstants.s500 * 2,
                          inputDecorationTheme:
                              const InputDecorationTheme(filled: true),
                          enableSearch: false,
                          initialSelection: vivariumId,
                          dropdownMenuEntries:
                              _buildVivariumEntries(vivariaIds),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Abbrechen'),
                          ),
                          SizedBox(width: SizeConstants.s300),
                          FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (sexController.text.isEmpty) {
                                  setState(() {
                                    _sexError =
                                        'Dieses Feld darf nicht leer sein';
                                  });
                                } else {
                                  setState(() {
                                    _sexError = null;
                                  });
                                }

                                _animalService.deleteAnimal(animalId);

                                _animalService.addAnimal(
                                  Animal(
                                      nameController.text,
                                      speciesTrivialController.text,
                                      speciesScientificController.text,
                                      Sex.values.byName(
                                          sexController.text.toLowerCase()),
                                      weightController.text == ''
                                          ? null
                                          : num.parse(weightController.text),
                                      countController.text == ''
                                          ? null
                                          : int.parse(countController.text),
                                      imageController.text),
                                );

                                var navigator = Navigator.of(context);

                                if (vivariumController.text != '') {
                                  _vivariumService.removeInhabitant(
                                      vivariumId, nameController.text);
                                  _vivariumService.addInhabitant(
                                      vivariumController.text,
                                      nameController.text);
                                }

                                _prefs.setString(
                                    'animalId', nameController.text);

                                if (animalId.isNotEmpty) {
                                  navigator.pop();
                                }
                                navigator.popAndPushNamed('/details');
                              }
                            },
                            child: const Text('Speichern'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildSexEntries() {
    return Sex.values
        .map((sex) => DropdownMenuEntry(value: sex, label: sex.label))
        .toList();
  }

  _buildVivariumEntries(List<String> vivariaIds) {
    return vivariaIds
        .map((id) => DropdownMenuEntry(value: id, label: id))
        .toList();
  }
}
