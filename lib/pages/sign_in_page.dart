import 'package:flutter/material.dart';

import '../views/sign_in_auth_view.dart';
import '../views/sign_in_view.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _State();
}

class _State extends State<SignInPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Navigator(
          key: _navigatorKey,
          initialRoute: 'sign-in/',
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case 'sign-in/':
        builder = (_) => const SignInView();
        break;
      case 'sign-in/auth':
        builder = (_) => const SignInAuthView();
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));

        var beginForOldPage = Offset.zero;
        var endForOldPage = const Offset(0.0, -1.0);
        var tweenOldPage = Tween(begin: beginForOldPage, end: endForOldPage)
            .chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(tweenOldPage),
            child: builder(context),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
