import 'package:aqua_terra_manager/views/animal_edit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import '../models/animal.dart';
import '../services/database/animal_service.dart';

//-----------------------
// List with all animals
//-----------------------
class AnimalListView extends StatelessWidget {
  AnimalListView({super.key});

  final _prefs = locator<SharedPreferences>();
  final _animalService = locator<AnimalService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream:
              _animalService.animalsRef.orderBy('speciesTrivial').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Animal> animals = snapshot.data!.docs
                .map((doc) => Animal.fromJson(
                    (doc.data() as Map<String, dynamic>)..['id'] = doc.id))
                .toList();
            return ListView(children: _listTiles(context, animals));
          }),
      // Button to add a new animal
      floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            _prefs.setString('animalToEdit', '');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnimalEditView(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded)),
    );
  }

  _listTiles(BuildContext context, List<Animal> animals) {
    return animals
        .map(
          (a) => ListTile(
              title: Text(
                a.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              subtitle: Wrap(
                children: [
                  Text(
                    '${a.speciesTrivial} - ',
                  ),
                  Text(
                    a.speciesScientific,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              leading: const Icon(Icons.pets_rounded),
              onTap: () {
                _prefs.setString('animalId', a.name);
                Navigator.pushNamed(context, '/details');
              }),
        )
        .toList();
  }
}
