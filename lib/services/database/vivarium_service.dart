import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../../models/vivarium.dart';

//--------------------------------------------------
// interaction with firestore collection 'vivaria'
//--------------------------------------------------
class VivariumService {
  VivariumService({required this.firestore});

  final FirebaseFirestore firestore;
  late CollectionReference vivariaRef = firestore.collection('vivaria');
  late Query vivariaQuery = vivariaRef.orderBy('name');

  addVivarium(vivarium) {
    // add vivarium to firestore database
    vivariaRef.doc(vivarium.name).set(vivarium.toJson());
  }

  deleteVivarium(String vivariumId) {
    // remove vivarium from vivaria collection
    if (vivariumId.isEmpty) {
      throw ArgumentError('The document path is empty!', vivariumId);
    }
    vivariaRef.doc(vivariumId).delete();
  }

  importVivariaFromCsv(filePath) async {
    // import csv
    final fileContents = await rootBundle.loadString(filePath);
    final data = const CsvToListConverter().convert(
      fileContents,
      eol: "\n",
    );
    // create vivarium objects
    var map = data.skip(1).map((i) {
      return Vivarium(i[0], VivariumType.fromLabel(i[1]), i[2], i[3], i[4],
          i[5], i[6], i[11].toString().split(","), i[12].toString().split(","));
    }).toList();
    // add vivaria to firestore database
    for (var vivarium in map) {
      addVivarium(vivarium);
    }
  }

  addInhabitant(String vivariumId, String animalId) async {
    // add animal(s) that live in this vivarium
    await vivariaRef.doc(vivariumId).update({
      'inhabitants': FieldValue.arrayUnion([animalId]),
    });
  }

  removeInhabitant(String vivariumId, String animalId) async {
    await vivariaRef.doc(vivariumId).update({
      'inhabitants': FieldValue.arrayRemove([animalId]),
    });
  }

  addResponsible(String vivariumId, String studentId) async {
    // add students that take care of this vivarium
    await vivariaRef.doc(vivariumId).update({
      'responsible': FieldValue.arrayUnion([studentId]),
    });
  }

  removeResponsible(String vivariumId, String studentId) async {
    await vivariaRef.doc(vivariumId).update({
      'responsible': FieldValue.arrayRemove([studentId]),
    });
  }

  deleteAllVivaria() {
    // delete entire vivaria collection
    vivariaRef.get().then((snapshot) {
      for (DocumentSnapshot vivarium in snapshot.docs) {
        vivarium.reference.delete();
      }
    });
  }

  Future<List<String>> getVivariaIds() async {
    // get IDs (=name) of all vivaria
    QuerySnapshot snapshot = await vivariaRef.orderBy('name').get();
    List<String> vivariaIds = [];
    for (var vivarium in snapshot.docs) {
      vivariaIds.add(vivarium.id);
    }
    return vivariaIds;
  }

  Future<List<dynamic>> getResponsible(vivariumId) async {
    // get students that take care of this vivarium
    DocumentSnapshot snapshot = await vivariaRef.doc(vivariumId).get();
    return snapshot.get('responsible');
  }

  Future<List<dynamic>> getInhabitants(vivariumId) async {
    // get animals that live in this vivarium
    DocumentSnapshot snapshot = await vivariaRef.doc(vivariumId).get();
    return snapshot.get('inhabitants');
  }

  Future<Vivarium> getVivariumDetails(vivariumId) async {
    // get all data from respective vivarium document
    DocumentSnapshot vivariumSnapshot = await vivariaRef.doc(vivariumId).get();
    Vivarium vivarium =
        Vivarium.fromJson(vivariumSnapshot.data() as Map<String, dynamic>);
    return vivarium;
  }
}
