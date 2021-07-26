import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accountprovider extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool isloading = false;
  bool loginbuttonshow = false;

  Future accountcreated(BuildContext context, String _fastname, _lastname,
      _username, _email, _password) async {
    try {
      isloading = true;

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      notifyListeners();
      if (userCredential.additionalUserInfo != null) {
        firebase_userdata_add(_username, _fastname, _lastname, _email);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account Successfully Created")));

        isloading = false;

        loginbuttonshow = true;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The password provided is too weak")));

        isloading = false;

        loginbuttonshow = false;
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("The account already exists for that email")));

        isloading = false;
        loginbuttonshow = false;
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Future<DocumentReference>? firebase_userdata_add(
      String username, fastname, lastname, email) {
    users.doc(email).set({
      "fastname": fastname,
      "lastname": lastname,
      "username": username,
      "email": email,
      "country": "",
      "phone": "",
      "address": "",
      "profilepic": false,
      "friendrequest": FieldValue.arrayUnion([]),
      "sendfriendrequest": FieldValue.arrayUnion([]),
      "friends": FieldValue.arrayUnion([]),
      "follower": FieldValue.arrayUnion([]),
      "following": FieldValue.arrayUnion([])
    }).then((value) {
      print("Added Successfull");
    });

    notifyListeners();
  }

  Future? accountsignin(String email, password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.additionalUserInfo != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Successfull")));
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email")));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password provided for that user.")));
        print('Wrong password provided for that user.');
      }
    }
  }
}
