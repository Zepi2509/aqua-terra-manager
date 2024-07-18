import 'package:aqua_terra_manager/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Manages Firebase authentication.
///
class AuthenticationService {
  final _auth = FirebaseAuth.instance;
  final _prefs = locator<SharedPreferences>();

  static const _keySignInEmail = 'signInEmail';
  static const _keyLastLinkTime = 'lastLinkTime';

  Future<User?> getUser() async {
    var currentUser = _auth.currentUser;
    return currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  ///
  /// Sends a sign in link to the [email] address.
  ///
  sendSignInLink() async {
    final email = _prefs.getString(_keySignInEmail);
    if (email == null || email.isEmpty) {
      throw ArgumentError('Email can not be null or empty');
    }

    var actionCodeSettings = _createActionCodeSettings();

    try {
      await _auth.sendSignInLinkToEmail(
          email: email, actionCodeSettings: actionCodeSettings);
      _prefs.setString(_keyLastLinkTime, DateTime.now().toUtc().toString());
    } catch (e) {
      throw Exception('Could not send sign-in link: $e');
    }
  }

  ///
  /// Helper method to create `ActionCodeSettings` for generating sign-in link.
  ///
  ActionCodeSettings _createActionCodeSettings() {
    return ActionCodeSettings(
      url: 'https://aquaterramanager.page.link/sign-in',
      iOSBundleId: 'com.reinekezepner.aquaTerraManager',
      androidPackageName: 'com.reinekezepner.aqua_terra_manager',
      handleCodeInApp: true,
      androidInstallApp: true,
    );
  }

  ///

  ///
  signInWithEmailLink({required String emailLink}) async {
    final email = _prefs.getString('signInEmail');
    if (email == null) throw ArgumentError('Email can not be null');

    try {
      if (!_auth.isSignInWithEmailLink(emailLink)) {
        throw Exception('Provided link is not a sign-in with email link');
      }

      await _auth.signInWithEmailLink(email: email, emailLink: emailLink);
    } catch (e) {
      throw Exception('Could not sign-in: $e');
    }
  }

  resendSignInLink() async {
    final email = _prefs.getString(_keySignInEmail);
    if (email == null || email.isEmpty) {
      throw ArgumentError('Email can not be null or empty');
    }

    final lastLinkTime = _prefs.getString(_keyLastLinkTime);

    if (lastLinkTime == null) {
      throw ArgumentError.notNull(lastLinkTime.runtimeType.toString());
    }
    if (DateTime.now()
            .toUtc()
            .difference(DateTime.parse(lastLinkTime))
            .inSeconds <
        60) {
      throw Exception(
          'The sign-in link was already sent less than a minute ago.');
    }

    await sendSignInLink();
  }

  signOut() {
    _auth.signOut();
  }

  /// Signs in the user using the emailed link [emailLink] and the user's [email].
}
