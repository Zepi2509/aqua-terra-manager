import 'package:aqua_terra_manager/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Student', () {
    test(
        'Student constructor should create a Student object with correct properties',
        () {
      Student student = Student('Jona', 'Lending', SchoolClass.klasse5b,
          'jona.lending@mps-ki.de', StudentRole.pfleger, null);
      expect(student.firstname, equals('Jona'));
      expect(student.lastname, equals('Lending'));
      expect(student.schoolClass, equals(SchoolClass.klasse5b));
      expect(student.email, equals('jona.lending@mps-ki.de'));
      expect(student.role, equals(StudentRole.pfleger));
      expect(student.attendance, isNull);
    });

    test('Student.fromJson should create a Student object from a JSON', () {
      Map<String, dynamic> json = {
        'firstname': 'Jona',
        'lastname': 'Lending',
        'schoolClass': '5b',
        'email': 'jona.lending@mps-ki.de',
        'role': 'Pfleger',
        'created': Timestamp(1701000000, 0),
        'attendance': [
          Timestamp(1702821106, 0),
          Timestamp(1702000000, 0),
        ]
      };

      Student student = Student.fromJson(json);
      expect(student.firstname, equals('Jona'));
      expect(student.lastname, equals('Lending'));
      expect(student.schoolClass, equals(SchoolClass.klasse5b));
      expect(student.email, equals('jona.lending@mps-ki.de'));
      expect(student.role, equals(StudentRole.pfleger));
      expect(student.created, DateTime(2023, 11, 26, 13));
      expect(student.attendance, [
        DateTime(2023, 12, 17, 14, 51, 46),
        DateTime(2023, 12, 8, 2, 46, 40)
      ]);
    }, skip: false);
  });

  test('Student.toJson should convert a Student object to a JSON', () {
    Student student = Student(
        'Jona',
        'Lending',
        SchoolClass.klasse5b,
        'jona.lending@mps-ki.de',
        StudentRole.pfleger,
        [DateTime(2023, 12, 17, 14, 51, 46), DateTime(2023, 12, 8, 2, 46, 40)]);
    Map<String, dynamic> json = student.toJson();
    expect(json['firstname'], equals('Jona'));
    expect(json['lastname'], equals('Lending'));
    expect(json['schoolClass'], equals('5b'));
    expect(json['email'], equals('jona.lending@mps-ki.de'));
    expect(json['role'], equals('Pfleger'));
    expect(json['created'], student.created);
    expect(json['attendance'], isA<List>());
    expect(json['attendance'].length, equals(2));
  });

  test(
      'StudentRole.fromLabel should return the correct StudentRole enum value based on the label',
      () {
    StudentRole role = StudentRole.fromLabel('Leiter');
    expect(role, equals(StudentRole.leiter));
    role = StudentRole.fromLabel('Pfleger');
    expect(role, equals(StudentRole.pfleger));
  });

  test(
      'SchoolClass.fromLabel should return the correct SchoolClass enum value based on the label',
      () {
    SchoolClass schoolClass = SchoolClass.fromLabel('5a');
    expect(schoolClass, equals(SchoolClass.klasse5a));
    schoolClass = SchoolClass.fromLabel('Jg. 12');
    expect(schoolClass, equals(SchoolClass.jahrgang12));
  });
}
