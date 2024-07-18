import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/models/animal.dart';
import 'package:aqua_terra_manager/services/database/animal_service.dart';
import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:aqua_terra_manager/services/lists_navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/vivarium.dart';

class VivariumCard extends StatelessWidget {
  final _prefs = locator<SharedPreferences>();
  final _vivariumService = locator<VivariumService>();
  final _animalService = locator<AnimalService>();
  final _listsNavigatorService = locator<ListsNavigatorService>();

  late final String vivariumId;

  VivariumCard(this.vivariumId, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _vivariumService.getVivariumDetails(vivariumId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          return Container();
        }

        Vivarium vivarium = snapshot.data!;

        return GestureDetector(
          onTap: () {
            _prefs.setString('vivariumId', vivariumId);
            _listsNavigatorService.navigateToVivariumDetails();
          },
          child: Card(
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
                        title: Text(vivariumId),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConstants.s300),
                        child: Wrap(
                          spacing: SizeConstants.s300,
                          alignment: WrapAlignment.center,
                          children: vivarium.inhabitants.map((animalId) {
                            return FutureBuilder(
                              future: _animalService.getAnimalDetails(animalId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                        ConnectionState.done ||
                                    snapshot.data == null) {
                                  return Container();
                                }

                                Animal animal = snapshot.data!['animal'];

                                return GestureDetector(
                                  child: Chip(
                                    label: Text(animal.name),
                                    // Add icon for the species of the inhabitant
                                    avatar: (animal.count ?? 0) > 1
                                        ? Text(
                                            '${animal.count}',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          )
                                        : const Icon(Icons.pets),
                                  ),
                                  onTap: () {
                                    _prefs.setString('animalId', animalId);
                                    _listsNavigatorService
                                        .navigateToAnimalDetails();
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
          ),
        );
      },
    );
  }
}
