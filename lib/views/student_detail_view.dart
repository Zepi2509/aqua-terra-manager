import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/views/student_edit_view.dart';
import 'package:aqua_terra_manager/widgets/vivarium_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../locator.dart';
import '../../models/student.dart';
import '../../services/database/student_service.dart';

//---------------------------------------------
// Detailed information about a single student
//---------------------------------------------
class StudentDetailView extends StatefulWidget {
  const StudentDetailView({super.key});

  @override
  State<StudentDetailView> createState() => _StudentDetailViewState();
}

class _StudentDetailViewState extends State<StudentDetailView>
    with SingleTickerProviderStateMixin {
  final _prefs = locator<SharedPreferences>();
  final _studentService = locator<StudentService>();

  final _dateFormatter = DateFormat('dd.MM.yyyy');
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    String studentId = _prefs.getString('studentId') ?? "";

    return FutureBuilder(
      future: _studentService.getStudentDetails(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Student student = snapshot.data?["student"];
        String vivariumId = snapshot.data!["vivariumId"];

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildStudentCard(context, student),
                VivariumCard(vivariumId),
                _buildCalendarCard(context, student),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomAppBar(context, student, vivariumId),
        );
      },
    );
  }

  _buildStudentCard(BuildContext context, Student student) {
    return Card(
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
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_rounded),
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  title: Text(
                    '${student.firstname} ${student.lastname}',
                  ),
                  subtitle: Text(student.email),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.manage_accounts_rounded),
                        label: Text(student.role.label),
                      ),
                      SizedBox(width: SizeConstants.s300),
                      Chip(
                        avatar: const Icon(Icons.class_rounded),
                        label: Text(student.schoolClass.label),
                      ),
                      SizedBox(width: SizeConstants.s300),
                      Chip(
                        avatar: const Icon(Icons.today_rounded),
                        label: Text(
                          _dateFormatter.format(student.created),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildCalendarCard(BuildContext context, Student student) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(SizeConstants.s300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            title: const Text('Anwesenheit'),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConstants.s300),
            child: TableCalendar(
              locale: "de_DE",
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              daysOfWeekVisible: false,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              headerStyle: const HeaderStyle(titleCentered: true),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.all(Radius.circular(SizeConstants.s900))),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  for (DateTime d in student.attendance!) {
                    if (day.day == d.day &&
                        day.month == d.month &&
                        day.year == d.year) {
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeConstants.s300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomAppBar(BuildContext context, Student student, String vivariumId) {
    return BottomAppBar(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            onPressed: () => _buildShowModalBottomSheet(context, student),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded),
                onPressed: () => _displayDeleteForm(context, student),
              ),
              SizedBox(width: SizeConstants.s300),
              FloatingActionButton(
                child: const Icon(Icons.edit_rounded),
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    _prefs.setString('studentToEdit', student.email);
                    return const StudentEditView();
                  },
                )),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildShowModalBottomSheet(BuildContext context, Student student) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          animationController: _animationController,
          showDragHandle: true,
          enableDrag: true,
          onClosing: () => Navigator.pop(context),
          builder: (context) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConstants.s100,
                  horizontal: SizeConstants.s700,
                ),
                child: QrImageView(
                  data: student.email,
                  version: QrVersions.auto,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _displayDeleteForm(BuildContext context, Student student) {
    return showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
                '${student.firstname} ${student.lastname} unwiderruflich löschen?'),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () {
                  _studentService.deleteStudent(student.email);
                  Navigator.pop(context); // close alert dialog
                  Navigator.pop(context); // close deleted detail view
                },
                child: const Text('Löschen'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
