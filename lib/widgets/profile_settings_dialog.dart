import 'dart:io';

import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/services/authentication_service.dart';
import 'package:flutter/material.dart';

class ProfileSettingsDialog extends StatelessWidget {
  ProfileSettingsDialog({super.key});

  final _authenticationService = locator<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: SizeConstants.s600),
      child: Dialog(
        insetPadding: const EdgeInsets.all(SizeConstants.s500),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Card(
              elevation: 0,
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
                            foregroundImage:
                                AssetImage('assets/images/gecko.jpg'),
                          ),
                          titleTextStyle:
                              Theme.of(context).textTheme.titleLarge,
                          title: const Text('Max Mustermann'),
                          subtitle: const Text('max.mustermann@test.de'),
                        ),
                        OutlinedButton(
                          child: const Text('Profil anzeigen'),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/profile'),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceTint
                        .withOpacity(0.1),
                    thickness: SizeConstants.s100,
                    height: SizeConstants.s100,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Ausloggen'),
                    onTap: () {
                      _authenticationService.signOut();
                      exit(0);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
                contentPadding: const EdgeInsets.only(left: SizeConstants.s500),
                leading: const Icon(Icons.settings),
                title: const Text('Einstellungen'),
                onTap: () => Navigator.of(context).pushNamed('/settings')),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('Datenschutzerklärung'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/privacy-policy'),
                ),
                TextButton(
                  child: const Text('Nutzungsbedingungen'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/terms-of-use'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
