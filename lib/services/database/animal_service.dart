import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../../locator.dart';
import '../../models/animal.dart';

//--------------------------------------------------
// interaction with firestore collection 'animals'
//--------------------------------------------------
class AnimalService {
  AnimalService({required this.firestore});

  final FirebaseFirestore firestore;
  final _vivariumService = locator<VivariumService>();
  late CollectionReference animalsRef =
      FirebaseFirestore.instance.collection('animals');

  addAnimal(animal) {
    // add animal to firestore database
    animalsRef.doc(animal.name).set(animal.toJson());
  }

  deleteAnimal(animalId) async {
    // remove this animal from animal collection
    animalsRef.doc(animalId).delete();
    // update also vivaria collection:
    final vivariumId = await getVivariumIdForAnimal(animalId);
    final inhabitants = await _vivariumService.getInhabitants(vivariumId);
    inhabitants.remove(animalId);
    await _vivariumService.vivariaRef
        .doc(vivariumId)
        .update({'inhabitants': inhabitants});
  }

  Future<List<String>> getAnimalIds() async {
    // get IDs (= names) of all animals in collection
    QuerySnapshot snapshot = await animalsRef.orderBy('name').get();
    List<String> animalIds = [];
    for (var animal in snapshot.docs) {
      animalIds.add(animal.id);
    }
    return animalIds;
  }

  importAnimalsFromCsv(filePath) async {
    // import csv
    final fileContents = await rootBundle.loadString(filePath);
    final data = const CsvToListConverter().convert(
      fileContents,
      eol: "\n",
    );
    // create animal objects
    var map = data.skip(1).map((i) {
      return Animal(i[0], i[1], i[2], Sex.values.byName(i[3]),
          i[4] == "" ? null : i[4], i[5] == "" ? null : i[5], i[6]);
    }).toList();
    // add animals to firestore database
    for (var animal in map) {
      addAnimal(animal);
    }
  }

  Future<dynamic> getVivariumIdForAnimal(animalId) async {
    // get ID (= name) from the vivarium where this animal lives
    QuerySnapshot vivarium = await _vivariumService.vivariaRef
        .where('inhabitants', arrayContains: animalId)
        .limit(1)
        .get();
    if (vivarium.docs.isEmpty) return '';
    return vivarium.docs[0].id;
  }

  Future<Map<String, dynamic>> getAnimalDetails(animalId) async {
    // get all data from respective animal document
    DocumentSnapshot animalSnapshot = await animalsRef.doc(animalId).get();
    Animal animal =
        Animal.fromJson(animalSnapshot.data() as Map<String, dynamic>);
    // get vivarium where this animal lives
    String vivariumId = await getVivariumIdForAnimal(animalId);
    return {'animal': animal, 'vivariumId': vivariumId};
  }

  deleteAllAnimals() {
    // delete entire animal collection from firestore database
    animalsRef.get().then((snapshot) {
      for (DocumentSnapshot animal in snapshot.docs) {
        animal.reference.delete();
      }
    });
  }
}
