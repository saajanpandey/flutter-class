import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {
  Future<bool> signUp(email, password, phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(email, password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('counter');
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  update() {
    User? user = FirebaseAuth.instance.currentUser;
    // user?.updateDisplayName("Sanjay");

    // user?.sendEmailVerification();
    // print("verified${user?.emailVerified}");
  }

  final firestoreInstance = FirebaseFirestore.instance;

  // Future<bool> storeformFirebase(name, phone, email, password) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   try {
  //     // await firestoreInstance
  //     //     .collection("users")
  //     //     .add({"name": name, "phone": phone, "email": email});
  //     await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> profile(name, phone, dateOfBirth) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      firestoreInstance.collection("users").doc(firebaseUser?.uid).set(
          {"name": name, "phoneNumber": phone, "dateOfBirth": dateOfBirth});
      return true;
    } catch (e) {
      return false;
    }
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> imageUpload(image) async {
    if (image == null) return false;
    final fileName = basename(image!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          FirebaseStorage.instance.ref(destination).child('profilepictures/');
      await ref.putFile(image!);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future otp() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   print(user);
  //   final firestoreInstance = FirebaseFirestore.instance;
  //   User? data = firestoreInstance.collection('users').doc(user?.uid).get();
  // }

  Future<bool> signInwithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<void> signOutFromGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
