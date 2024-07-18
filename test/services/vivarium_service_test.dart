import 'package:aqua_terra_manager/models/vivarium.dart';
import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // needed to load csv
  group('VivariumService', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final Vivarium expectedVivarium = Vivarium(
        "Aquarium 7",
        VivariumType.aquarium,
        40,
        50,
        40,
        null,
        null,
        ["Jumi", "Koko", "Fischbert"],
        ["anna.kehler@mps-ki.de", "maya.saleh@mps-ki.de"]);

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Add vivaria', () {
      test(
          'addVivarium should add data from a vivarium object to vivaria collection',
          () async {
        final VivariumService vivariumService =
            VivariumService(firestore: fakeFirebaseFirestore!);
        await vivariumService.addVivarium(expectedVivarium);
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await fakeFirebaseFirestore!
                .collection("vivaria")
                .doc(expectedVivarium.name)
                .get();
        final Map<String, dynamic> actualData = documentSnapshot.data()!;
        Vivarium actualVivarium = Vivarium.fromJson(actualData);
        expect(actualVivarium.toJson(), expectedVivarium.toJson());
      });
    });
    group('Import vivaria from csv', () {
      test(
          'importVivariaFromCsv should add data from a csv to vivaria collection',
          () async {
        final VivariumService vivariumService =
            VivariumService(firestore: fakeFirebaseFirestore!);

        await vivariumService
            .importVivariaFromCsv("test/assets/test_vivarium_list.csv");

        final List<Map<String, dynamic>> actualDataList =
            (await fakeFirebaseFirestore!.collection('vivaria').get())
                .docs
                .map((e) => e.data())
                .toList();
        List<Vivarium> vivaria =
            actualDataList.map((e) => Vivarium.fromJson(e)).toList();
        expect(vivaria[0].type, VivariumType.aquarium);
        expect(vivaria[0].inhabitants, ["Axel", "Lotti", "Quetzalcoatl"]);
        expect(vivaria[1].width, 60);
        expect(vivaria[1].responsible, [
          "annika.boettner@mps-ki.de",
          "arya.fakhoury@mps-ki.de",
          "levin.lienau@mps-ki.de",
          "miran.nemeth@mps-ki.de"
        ]);
      });
    }, skip: true);
    group('Get document fields', () {
      test('getVivariaIds should return ids of all vivaria documents',
          () async {
        final VivariumService vivariumService =
            VivariumService(firestore: fakeFirebaseFirestore!);
        await vivariumService
            .importVivariaFromCsv("test/assets/test_vivarium_list.csv");
        final actualIds = await vivariumService.getVivariaIds();
        expect(actualIds, ["Aquarium 1", "Aquarium 2"]);
      }, skip: true);

      test('getResponsible should return responsible of a vivarium document',
          () async {
        final VivariumService vivariumService =
            VivariumService(firestore: fakeFirebaseFirestore!);
        await vivariumService.addVivarium(expectedVivarium);
        final actualResponsible =
            await vivariumService.getResponsible(expectedVivarium.name);
        expect(actualResponsible, expectedVivarium.responsible);
      });
      test('getInhabitants should return inhabitants of a vivarium document',
          () async {
        final VivariumService vivariumService =
            VivariumService(firestore: fakeFirebaseFirestore!);
        await vivariumService.addVivarium(expectedVivarium);
        final actualInhabitants =
            await vivariumService.getInhabitants(expectedVivarium.name);
        expect(actualInhabitants, expectedVivarium.inhabitants);
      });
    });
  }, skip: false);
}
