import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/services/authentication_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

///
/// Handles Firebase dynamic links for authentication.
///
class DynamicLinksService {
  final _dynamicLinks = FirebaseDynamicLinks.instance;
  final _auth = locator<AuthenticationService>();

  get onLink => _dynamicLinks.onLink.map((event) => event.link);

  void initDynamicLinks() {
    _dynamicLinks.getInitialLink().then((dynamicLink) {
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        handleDeepLink(deepLink);
      }
    });
  }

  void handleDeepLink(Uri deepLink) {
    var emailLink = deepLink.toString();
    _auth.signInWithEmailLink(emailLink: emailLink);
  }
}
