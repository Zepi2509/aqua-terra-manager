import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/views/home_view.dart';
import 'package:aqua_terra_manager/widgets/profile_settings_dialog.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () => Navigator.pushNamed(context, '/scanner'),
        ),
        title: const Text(
          'Aqua-Terra Manager',
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(SizeConstants.s300),
            child: GestureDetector(
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (context) => ProfileSettingsDialog(),
                )
              },
              child: const CircleAvatar(
                foregroundImage: AssetImage(
                    'assets/images/gecko.jpg'), // example profile picture
              ),
            ),
          ),
        ],
      ),
      body: HomeView(),
    );
  }
}
