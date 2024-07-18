import 'package:aqua_terra_manager/services/database/animal_service.dart';
import 'package:aqua_terra_manager/services/database/student_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../locator.dart';
import '../models/vivarium.dart';
import '../services/database/vivarium_service.dart';

//----------------------------------
// edit data of a single vivarium
//----------------------------------
class VivariumEditView extends StatefulWidget {
  const VivariumEditView({super.key});

  @override
  State<VivariumEditView> createState() => _VivariumEditViewState();
}

class _VivariumEditViewState extends State<VivariumEditView> {
  final _prefs = locator<SharedPreferences>();
  final _formKey = GlobalKey<FormState>();

  final _vivariumService = locator<VivariumService>();
  final _studentService = locator<StudentService>();
  final _animalService = locator<AnimalService>();

  String? _typeError;

  @override
  Widget build(BuildContext context) {
    final vivariumId = _prefs.getString('vivariumToEdit') ?? '';

    return FutureBuilder(
      future: _studentService.getStudentIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final carerIds = snapshot.data ?? List.empty();

        return FutureBuilder(
          future: _animalService.getAnimalIds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final animalIds = snapshot.data ?? List.empty();

            return FutureBuilder(
              future: _vivariumService.getVivariumDetails(vivariumId),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                final Vivarium? vivarium = snapshot.data;

                final nameController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.name);
                final typeController = TextEditingController();
                var responsibleResult = vivarium?.responsible ?? List.empty();
                var inhabitantsResult = vivarium?.inhabitants ?? List.empty();
                final heightController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.height.toString());
                final widthController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.width.toString());
                final depthController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.depth.toString());
                final tempMinController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.tempMin.toString());
                final tempMaxController = vivarium == null
                    ? TextEditingController()
                    : TextEditingController(text: vivarium.tempMax.toString());

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeConstants.s500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
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
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
                            child: DropdownMenu(
                              controller: typeController,
                              label: const Text('Typ'),
                              width: MediaQuery.of(context).size.width -
                                  SizeConstants.s500 * 2,
                              inputDecorationTheme:
                                  const InputDecorationTheme(filled: true),
                              enableSearch: false,
                              initialSelection: vivarium?.type,
                              dropdownMenuEntries: _buildTypeEntries(),
                              errorText: _typeError,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
                            child: MultiSelectDialogField(
                              title: const Text('Pfleger'),
                              buttonText: const Text('Pfleger'),
                              listType: MultiSelectListType.CHIP,
                              selectedItemsTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              cancelText: const Text('Abbrechen'),
                              confirmText: const Text('Ok'),
                              searchable: true,
                              initialValue: responsibleResult,
                              items: _buildStudentEntries(carerIds),
                              onConfirm: (result) {
                                responsibleResult = result;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
                            child: MultiSelectDialogField(
                              title: const Text('Tiere'),
                              buttonText: const Text('Tiere'),
                              listType: MultiSelectListType.CHIP,
                              selectedItemsTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              cancelText: const Text('Abbrechen'),
                              confirmText: const Text('Ok'),
                              searchable: true,
                              initialValue: inhabitantsResult,
                              items: _buildAnimalEntries(animalIds),
                              onConfirm: (result) {
                                inhabitantsResult = result;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: SizeConstants.s300),
                                  child: TextFormField(
                                    controller: heightController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Dieses Feld darf nicht leer sein';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]")))
                                    ],
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text('Höhe [cm]'),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: SizeConstants.s300),
                                  child: TextFormField(
                                    controller: widthController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Dieses Feld darf nicht leer sein';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]")))
                                    ],
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text('Breite [cm]'),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: depthController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Dieses Feld darf nicht leer sein';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        (RegExp("[.0-9]")))
                                  ],
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text('Tiefe [cm]'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: SizeConstants.s500),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: SizeConstants.s300),
                                  child: TextFormField(
                                    controller: tempMinController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Dieses Feld darf nicht leer sein';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]")))
                                    ],
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text('Temperaturminimum [°C]'),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: tempMaxController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Dieses Feld darf nicht leer sein';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        (RegExp("[.0-9]")))
                                  ],
                                  decoration: const InputDecoration(
                                    filled: true,
                                    label: Text('Temperaturmaximum [°C]'),
                                  ),
                                ),
                              ],
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
                                    if (typeController.text.isEmpty) {
                                      setState(() {
                                        _typeError =
                                            'Dieses Feld darf nicht leer sein';
                                      });
                                    } else {
                                      setState(() {
                                        _typeError = null;
                                      });
                                    }

                                    if (vivariumId.isNotEmpty) {
                                      _vivariumService
                                          .deleteVivarium(vivariumId);
                                    }

                                    _vivariumService.addVivarium(
                                      Vivarium(
                                          nameController.text,
                                          VivariumType.fromLabel(
                                            typeController.text,
                                          ),
                                          heightController.text == ""
                                              ? null
                                              : num.parse(
                                                  heightController.text),
                                          widthController.text == ""
                                              ? null
                                              : num.parse(widthController.text),
                                          depthController.text == ""
                                              ? null
                                              : num.parse(depthController.text),
                                          tempMinController.text == ""
                                              ? null
                                              : num.parse(
                                                  tempMinController.text),
                                          tempMaxController.text == ""
                                              ? null
                                              : num.parse(
                                                  tempMaxController.text),
                                          inhabitantsResult,
                                          responsibleResult),
                                    );

                                    if (vivariumId.isNotEmpty) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.popAndPushNamed(
                                        context, '/details');
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
      },
    );
  }

  _buildTypeEntries() {
    return VivariumType.values
        .map((type) => DropdownMenuEntry(value: type, label: type.label))
        .toList();
  }

  _buildStudentEntries(List<String> carerIds) {
    return carerIds.map((id) => MultiSelectItem(id, id)).toList();
  }

  _buildAnimalEntries(List<String> animalIds) {
    return animalIds.map((id) => MultiSelectItem(id, id)).toList();
  }
}
