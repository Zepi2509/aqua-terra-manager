import 'package:aqua_terra_manager/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import '../models/student.dart';
import '../services/database/student_service.dart';

//---------------------------------------------------------
// Scan QR Codes from students to register their attendance
//----------------------------------------------------------
class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ScannerView> {
  final _prefs = locator<SharedPreferences>();
  final _studentService = locator<StudentService>();

  final qrKey = GlobalKey(debugLabel: "QR");
  late QRViewController _qrViewController;
  String email = '';

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }

  void onScanCreated(QRViewController controller) {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        email = scanData.code!;
        // add current data to firestore document
        _studentService.addAttendance(email);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: SizeConstants.s800),
              width:
                  MediaQuery.of(context).size.width - (SizeConstants.s500 * 2),
              height:
                  MediaQuery.of(context).size.width - (SizeConstants.s500 * 2),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConstants.s600))),
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderWidth: SizeConstants.s200,
                  borderRadius: SizeConstants.s400,
                ),
                onQRViewCreated: onScanCreated,
              ),
            ),
            FutureBuilder(
              future: _studentService.getStudentDetails(email),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                    snapshot.data == null) {
                  return const ElevatedButton(
                    onPressed: null,
                    child: Text('Warte auf Scan'),
                  );
                }

                Student student = snapshot.data!['student'];

                return FilledButton(
                    onPressed: () {
                      _prefs.setBool('scanResult', true);
                      _prefs.setString('studentId', student.email);
                      _prefs.setInt('initialListsPageIndex', 0);
                      Navigator.pushNamed(context, '/lists');
                    },
                    child: Text('${student.firstname} ${student.lastname}'));
              },
            )
          ],
        ),
      ),
    );
  }
}
