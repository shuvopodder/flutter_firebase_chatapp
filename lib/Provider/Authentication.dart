import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/Firestore.dart';
import '../Model/UserChat.dart';

class Authentication extends ChangeNotifier {
  late final GoogleSignIn googleSignIn;
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  Authentication( {
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });


  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstant.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(FirestoreConstant.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }


  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstant.pathUserCollection)
            .where(FirestoreConstant.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstant.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstant.nickname: firebaseUser.displayName,
            FirestoreConstant.photoUrl: firebaseUser.photoURL,
            FirestoreConstant.id: firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstant.chattingWith: null
          });

          // Write data to local storage
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstant.id, currentUser.uid);
          await prefs.setString(FirestoreConstant.nickname, currentUser.displayName ?? "");
          await prefs.setString(FirestoreConstant.photoUrl, currentUser.photoURL ?? "");
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];



          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstant.id, userChat.id);
          await prefs.setString(FirestoreConstant.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstant.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstant.aboutMe, userChat.aboutMe);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
  handleSignUp(String text1, String text2, String text3) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: text2,
          password: text3
      );
      if(userCredential.user!=null){
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstant.pathUserCollection)
            .where(FirestoreConstant.id, isEqualTo: userCredential.user!.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstant.pathUserCollection).doc(userCredential.user!.uid).set({
            FirestoreConstant.nickname: text1,
            FirestoreConstant.photoUrl: userCredential.user!.photoURL,
            FirestoreConstant.id: userCredential.user!.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstant.chattingWith: null
          });}
        print("User Create");
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  handleSignIn(String text1, String text2) async {
    _status = Status.authenticating;
    notifyListeners();

    try{
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: text1,
              password: text2);

      if(userCredential.user!=null){
        _status = Status.authenticated;
        notifyListeners();
        return true;
      }else{
        _status = Status.authenticateCanceled;
        notifyListeners();
        return false;
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');

      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;

    } catch(e){}
  }
}
enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}