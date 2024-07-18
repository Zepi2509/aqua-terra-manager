import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/models/student.dart';
import 'package:aqua_terra_manager/services/database/student_service.dart';
import 'package:aqua_terra_manager/services/database/vivarium_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//--------------------------------
// Edit data of a single student
//---------------------------------
class StudentEditView extends StatefulWidget {
  const StudentEditView({super.key});

  @override
  State<StudentEditView> createState() => _StudentEditViewState();
}

class _StudentEditViewState extends State<StudentEditView> {
  final _prefs = locator<SharedPreferences>();
  final _studentService = locator<StudentService>();
  final _vivariumService = locator<VivariumService>();
  final _formKey = GlobalKey<FormState>();

  String? _schoolClassError;
  String? _roleError;

  @override
  Widget build(BuildContext context) {
    String studentId = _prefs.getString('studentToEdit') ?? '';

    return FutureBuilder(
      future: _vivariumService.getVivariaIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final vivariaIds = snapshot.data ?? List.empty();

        return FutureBuilder(
          future: _studentService.getStudentDetails(studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final Student? student = snapshot.data?['student'];
            final String vivariumId = snapshot.data?['vivariumId'] ?? '';

            final firstNameController = student == null
                ? TextEditingController()
                : TextEditingController(text: student.firstname);
            final lastNameController = student == null
                ? TextEditingController()
                : TextEditingController(text: student.lastname);
            final emailController = student == null
                ? TextEditingController()
                : TextEditingController(text: student.email);
            final schoolClassController = TextEditingController();
            final roleController = TextEditingController();
            final vivariumController = TextEditingController();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.s500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: SizeConstants.s300),
                              child: TextFormField(
                                controller: firstNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Dieses Feld darf nicht leer sein';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  label: Text('Vorname'),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Dieses Feld darf nicht leer sein';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text('Nachname'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Dieses Feld darf nicht leer sein';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('E-Mail'),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: DropdownMenu(
                          controller: schoolClassController,
                          label: const Text('Klasse'),
                          width: MediaQuery.of(context).size.width -
                              SizeConstants.s500 * 2,
                          inputDecorationTheme:
                              const InputDecorationTheme(filled: true),
                          enableSearch: false,
                          initialSelection: student?.schoolClass,
                          dropdownMenuEntries: _buildSchoolClassEntries(),
                          errorText: _schoolClassError,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: DropdownMenu(
                          controller: roleController,
                          label: const Text('Rolle'),
                          width: MediaQuery.of(context).size.width -
                              SizeConstants.s500 * 2,
                          inputDecorationTheme:
                              const InputDecorationTheme(filled: true),
                          enableSearch: false,
                          initialSelection: student?.role,
                          dropdownMenuEntries: _buildRoleEntries(),
                          errorText: _roleError,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SizeConstants.s500),
                        child: DropdownMenu(
                          controller: vivariumController,
                          label: const Text('Vivarium'),
                          width: MediaQuery.of(context).size.width -
                              SizeConstants.s500 * 2,
                          inputDecorationTheme:
                              const InputDecorationTheme(filled: true),
                          enableSearch: false,
                          initialSelection: vivariumId,
                          dropdownMenuEntries:
                              _buildVivariumEntries(vivariaIds),
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
                                if (schoolClassController.text.isEmpty) {
                                  setState(() {
                                    _schoolClassError =
                                        'Dieses Feld darf nicht leer sein';
                                  });
                                } else {
                                  setState(() {
                                    _schoolClassError = null;
                                  });
                                }
                                if (roleController.text.isEmpty) {
                                  setState(() {
                                    _roleError =
                                        'Dieses Feld darf nicht leer sein';
                                  });
                                } else {
                                  setState(() {
                                    _roleError = null;
                                  });
                                }
                                _studentService.deleteStudent(studentId);
                                _studentService.addStudent(Student(
                                  firstNameController.text,
                                  lastNameController.text,
                                  SchoolClass.fromLabel(
                                      schoolClassController.text),
                                  emailController.text,
                                  StudentRole.fromLabel(roleController.text),
                                  student?.attendance ?? List.empty(),
                                ));
                                if (vivariumController.text != '') {
                                  _vivariumService.removeResponsible(
                                      vivariumId, emailController.text);
                                  _vivariumService.addResponsible(
                                      vivariumController.text,
                                      emailController.text);
                                }

                                _prefs.setString(
                                    'studentId', emailController.text);

                                if (studentId.isNotEmpty) {
                                  Navigator.pop(context);
                                }
                                Navigator.popAndPushNamed(context, '/details');
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
  }

  List<DropdownMenuEntry<SchoolClass>> _buildSchoolClassEntries() {
    return SchoolClass.values
        .map((schoolClass) => DropdownMenuEntry<SchoolClass>(
            value: schoolClass, label: schoolClass.label))
        .toList();
  }

  _buildRoleEntries() {
    return StudentRole.values
        .map((role) =>
            DropdownMenuEntry<StudentRole>(value: role, label: role.label))
        .toList();
  }

  _buildVivariumEntries(List<String> vivariaIds) {
    return vivariaIds
        .map((id) => DropdownMenuEntry(value: id, label: id))
        .toList();
  }
}
