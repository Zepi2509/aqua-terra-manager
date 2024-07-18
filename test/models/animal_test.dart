import 'package:aqua_terra_manager/models/animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Animal', () {
    test(
        'Animal constructor should create an Animal object with correct properties',
        () {
      Animal animal = Animal('Timmy', 'Gewöhnliches Chamäleon',
          'Chamaeleo chamaeleon', Sex.male, 200, 1, 'https://chameleon.jpg');
      expect(animal.name, 'Timmy');
      expect(animal.speciesTrivial, 'Gewöhnliches Chamäleon');
      expect(animal.speciesScientific, 'Chamaeleo chamaeleon');
      expect(animal.sex, Sex.male);
      expect(animal.weight, 200);
      expect(animal.count, 1);
      expect(animal.image, 'https://chameleon.jpg');
      expect(animal.name, 'Timmy');
    });

    test('Animal.fromJson should create an Animal object from a JSON', () {
      Map<String, dynamic> json = {
        'name': 'Timmy',
        'speciesTrivial': 'Gewöhnliches Chamäleon',
        'speciesScientific': 'Chamaeleo chamaeleon',
        'sex': 'male',
        'weight': 200,
        'count': 1,
        'created': Timestamp(1702821106, 0),
        'image': 'https://chameleon.jpg',
      };
      Animal animal = Animal.fromJson(json);
      expect(animal.name, 'Timmy');
      expect(animal.speciesTrivial, 'Gewöhnliches Chamäleon');
      expect(animal.speciesScientific, 'Chamaeleo chamaeleon');
      expect(animal.sex, Sex.male);
      expect(animal.weight, 200);
      expect(animal.count, 1);
      expect(animal.created, DateTime(2023, 12, 17, 14, 51, 46));
      expect(animal.image, 'https://chameleon.jpg');
    }, skip: false);
  });

  test('Animal.toJson should convert an Animal object to a JSON', () {
    Animal animal = Animal('Timmy', 'Gewöhnliches Chamäleon',
        'Chamaeleo chamaeleon', Sex.male, 200, 1, 'https://chameleon.jpg');
    ;
    Map<String, dynamic> json = animal.toJson();
    expect(json['name'], 'Timmy');
    expect(json['speciesTrivial'], 'Gewöhnliches Chamäleon');
    expect(json['speciesScientific'], 'Chamaeleo chamaeleon');
    expect(json['sex'], 'male');
    expect(json['weight'], 200);
    expect(json['count'], 1);
    expect(json['image'], 'https://chameleon.jpg');
    expect(json['created'], animal.created);
  });

  test(
      'Sex.fromLabel should return the correct Sex enum value based on the label',
      () {
    Sex sex = Sex.fromLabel('männlich');
    expect(sex, Sex.male);

    sex = Sex.fromLabel('weiblich');
    expect(sex, Sex.female);

    sex = Sex.fromLabel('unbekannt');
    expect(sex, Sex.unknown);
  });
}
