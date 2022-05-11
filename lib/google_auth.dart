import 'package:buzzit/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

void signInWithGoogle(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await auth.signInWithCredential(credential);

      final User? user = authResult.user;

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoUrl': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email,
      };

      users.doc(user!.uid).get().then((doc) async {
        prefs.setString('name', userData['name']!);
        if (doc.exists) {
          doc.reference.update(userData);
        } else {
          users.doc(user.uid).set(userData);
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      });
    }
  } catch (p) {
    print(p);
    print("Sign in not successful !");
  }
}
