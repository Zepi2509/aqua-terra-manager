import 'package:aqua_terra_manager/app_settings.dart';
import 'package:aqua_terra_manager/notifier/theme_change_notifier.dart';
import 'package:aqua_terra_manager/pages/lists_page.dart';
import 'package:aqua_terra_manager/pages/main_page.dart';
import 'package:aqua_terra_manager/views/scanner_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'locator.dart';
import 'pages/settings_page.dart';
import 'pages/sign_in_page.dart';
import 'services/authentication_service.dart';
import 'services/dynamic_link_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _authenticationService = locator<AuthenticationService>();
  final _dynamicLinks = locator<DynamicLinksService>();
  final _themeChangeNotifier = locator<ThemeChangeNotifier>();

  @override
  void initState() {
    super.initState();
    _dynamicLinks.initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeChangeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Aqua Terra Manager',
          themeMode: themeMode,
          theme: appTheme(context),
          darkTheme: appTheme(context, true),
          debugShowCheckedModeBanner: false,
          routes: {
            '/lists': (_) => const ListsPage(),
            '/privacy-policy': (_) => ErrorWidget(UnimplementedError),
            '/profile': (_) => ErrorWidget(UnimplementedError),
            '/scanner': (_) => const ScannerView(),
            '/settings': (_) => const SettingsPage(),
            '/sign-in': (_) => const SignInPage(),
            '/terms-of-use': (_) => ErrorWidget(UnimplementedError),
          },
          home: StreamBuilder<User?>(
            stream: _authenticationService.authStateChanges(),
            builder: _streamContentBuilder,
          ),
        );
      },
    );
  }

  Widget _streamContentBuilder(context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) return ErrorWidget(snapshot.error!);

    var user = snapshot.data;
    if (user == null && AppSettings.deactivateFirebaseAuth == false) {
      return const SignInPage();
    }
    return const MainPage();
  }
}
