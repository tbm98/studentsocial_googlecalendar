import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'log.dart';
import '../objs/login_result.dart';

class GoogleSignInHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [CalendarApi.CalendarEventsScope, CalendarApi.CalendarScope]);

  Future<LoginResult> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null, 'email must not be null');
    assert(user.displayName != null, 'displayName must not be null');
    assert(user.photoUrl != null, 'photoUrl must not be null');

    assert(!user.isAnonymous, 'user must not be anonymous');
    assert(await user.getIdToken() != null, 'token must not be null');

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid, 'uid must be match');

    final headers = await googleSignInAccount.authHeaders;
    return LoginResult(user, headers);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    logs('User Sign Out');
  }
}
