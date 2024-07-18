import 'package:aqua_terra_manager/views/student_edit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import '../../models/student.dart';
import '../../services/database/student_service.dart';

//----------------------
// List of all students
//----------------------
class StudentListView extends StatelessWidget {
  StudentListView({super.key});

  final _prefs = locator<SharedPreferences>();
  final _studentService = locator<StudentService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _studentService.studentsRef.orderBy('firstname').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Student> students = snapshot.data!.docs
                .map((doc) => Student.fromJson(
                    (doc.data() as Map<String, dynamic>)..['id'] = doc.id))
                .toList();
            return ListView(children: _listTiles(context, students));
          }),
      floatingActionButton: FloatingActionButton.large(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                _prefs.setString('studentToEdit', '');
                return const StudentEditView();
              },
            ));
          },
          child: const Icon(Icons.add_rounded)),
    );
  }

  _listTiles(BuildContext context, List<Student> students) {
    return students
        .map((s) => ListTile(
              title: Text(
                "${s.firstname} ${s.lastname}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(s.email),
              trailing: Text(s.schoolClass.label),
              leading: Icon(s.role == StudentRole.pfleger
                  ? Icons.person
                  : Icons.person_outline),
              onTap: () {
                _prefs.setString('studentId', s.email);
                Navigator.pushNamed(context, '/details');
              },
            ))
        .toList();
  }
}
