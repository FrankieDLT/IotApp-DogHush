//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userArr = [];

  Future<List> getUserInfo() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    
    userArr.add(googleUser.displayName);
    userArr.add(googleUser.email);
    userArr.add(googleAuth.accessToken);


    return userArr;
  }

  bool isAlreadyLogged() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  void signOutGoogle() async {
    userArr.clear();
    await _googleSignIn.signOut();
  }

  void signOutFirebase() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithGoogle() async {
    // Google sign in
    
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    print("googleAuth $googleAuth");
    print("googleUser ${googleUser.displayName}");
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Firebase authentication
    final authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    final String firebaseAuthToken = await user.getIdToken();
    assert(!user.isAnonymous);
    assert(firebaseAuthToken != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print("Google auth token: ${googleAuth.accessToken}");
    print("Firebase auth token: $firebaseAuthToken");

  }
}
