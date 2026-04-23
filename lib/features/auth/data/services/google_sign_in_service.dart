import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  static Future<String?> signIn() async {
    try {
      await _initialize();

      final googleUser = await _googleSignIn.authenticate();

      final String? googleIdToken = googleUser.authentication.idToken;
      print('googleIdToken QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ: $googleIdToken');
      

      final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
      print('credential QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ: $credential');

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      print('userCredential QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ: $userCredential');

      final User? user = userCredential.user;
      if (user == null) return null;

      final firebaseIdToken = await user.getIdToken();
     
      return firebaseIdToken;
    } on GoogleSignInException catch (e) {

      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('e.code QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ: $e.code');
        return null;
      }
      rethrow;
    } catch (e) {
      print('e QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
