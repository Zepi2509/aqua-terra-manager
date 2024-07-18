import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/services/authentication_service.dart';
import 'package:aqua_terra_manager/services/dynamic_link_service.dart';
import 'package:flutter/material.dart';

class SignInAuthView extends StatefulWidget {
  const SignInAuthView({super.key});

  @override
  State<SignInAuthView> createState() => _State();
}

class _State extends State<SignInAuthView> {
  final _dynamicLinksService = locator<DynamicLinksService>();
  final _authenticationService = locator<AuthenticationService>();

  String? _resendEmailErrorMessage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dynamicLinksService.onLink,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(SizeConstants.s500),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Column(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.only(top: SizeConstants.s500),
                        child: Text(
                          'Bitte bestätige deine Anmeldung über den E-Mail-Link, welchen wir dir zugesendet haben.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                _resendEmailErrorMessage == null
                    ? Container()
                    : Text(
                        _resendEmailErrorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConstants.s700),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await _authenticationService.resendSignInLink();
                      } catch (e) {
                        _resendEmailErrorMessage = '$e';
                      }
                    },
                    child: const Text('E-Mail erneut senden'),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        var deepLink = snapshot.data as Uri;
        _dynamicLinksService.handleDeepLink(deepLink);
        return Container();
      },
    );
  }
}
