import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../../locator.dart';
import '../../models/student.dart';

//--------------------------------------------------
// interaction with firestore collection 'students'
//--------------------------------------------------
class StudentService {
  StudentService({required this.firestore});

  final FirebaseFirestore firestore;
  final vivariumService = locator<VivariumService>();
  late CollectionReference studentsRef = firestore.collection('students');

  addAttendance(id) async {
    DateTime now = DateTime.now();
    studentsRef.doc(id).update({
      'attendance': FieldValue.arrayUnion(
          // don't use seconds
          // (otherwise two scans that are just a second apart from another will cause two database entries)
          [DateTime(now.year, now.month, now.day, now.hour, now.minute)])
    });
  }

  addStudent(Student student) {
    studentsRef.doc(student.email).set(student.toJson());
  }

  deleteStudent(studentId) async {
    // delete this student from student collection
    studentsRef.doc(studentId).delete();
    // update also vivaria collection:
    final vivariumId = await getVivariumIdForStudent(studentId);
    final responsible = await vivariumService.getResponsible(vivariumId);
    responsible.remove(studentId);
    await vivariumService.vivariaRef
        .doc(vivariumId)
        .update({'responsible': responsible});
  }

  Future<List<String>> getStudentIds() async {
    // get IDs (=email) of all students in collection
    QuerySnapshot snapshot = await studentsRef.orderBy('firstname').get();
    List<String> studentIds = [];
    for (var student in snapshot.docs) {
      studentIds.add(student.id);
    }
    return studentIds;
  }

  importStudentsFromCsv(filePath) async {
    // import csv
    final fileContents = await rootBundle.loadString(filePath);
    final data = const CsvToListConverter().convert(
      fileContents,
      eol: "\n",
    );
    // create student objects
    var map = data.skip(1).map((i) {
      List<DateTime> dates = [];
      if (i[5] != "") {
        dates =
            List<DateTime>.from(i[5].split(",").map((d) => DateTime.parse(d)));
      }
      return Student(i[0], i[1], SchoolClass.fromLabel(i[2]), i[3],
          StudentRole.fromLabel(i[4]), dates);
    }).toList();
    // add students to firestore database
    for (var student in map) {
      addStudent(student);
    }
  }

  Future<dynamic> getVivariumIdForStudent(studentId) async {
    // get ID (= name) from the vivarium for which this student is responsible
    QuerySnapshot vivarium = await vivariumService.vivariaRef
        .where('responsible', arrayContains: studentId)
        .limit(1)
        .get();
    if (vivarium.docs.isEmpty) return "";
    return vivarium.docs[0].id;
  }

  Future<Map<String, dynamic>> getStudentDetails(studentId) async {
    // get all data from respective student document
    DocumentSnapshot studentSnapshot = await studentsRef.doc(studentId).get();
    Student student =
        Student.fromJson(studentSnapshot.data() as Map<String, dynamic>);
    // get vivarium for which this student is responsible
    String vivariumId = await getVivariumIdForStudent(studentId);
    return {'student': student, 'vivariumId': vivariumId};
  }

  deleteAllStudents() {
    // delete entire student collection
    studentsRef.get().then((snapshot) {
      for (DocumentSnapshot student in snapshot.docs) {
        student.reference.delete();
      }
    });
  }
}
