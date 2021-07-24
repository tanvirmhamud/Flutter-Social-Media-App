import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Userprofileprovider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? getuserallpost(String postuseremail) {
    return db
        .collection("users")
        .doc(postuseremail)
        .collection("post")
        .snapshots();
  }

  Future? sendfriendreq(
      String postuseremail,
      String accountuseremail,
      String accountuserfastname,
      String accountuserlastname,
      String accountuserprofilepic) async {
    await db
        .collection('users')
        .doc(postuseremail)
        .collection("friendrequest")
        .doc(accountuseremail)
        .set({
      "fastname": accountuserfastname,
      "lastname": accountuserlastname,
      "profilepic": accountuserprofilepic
    });

    await db.collection("users").doc(postuseremail).update({
      "friendrequest": FieldValue.arrayUnion([accountuseremail])
    });

    await db.collection("users").doc(accountuseremail).update({
      "sendfriendrequest": FieldValue.arrayUnion([postuseremail])
    });
    notifyListeners();
  }

  Future? sendrequestdelect(
      String postuseremail,
      String accountuseremail,
      String accountuserfastname,
      String accountuserlastname,
      String accountuserprofilepic) async {
    await db
        .collection('users')
        .doc(postuseremail)
        .collection("friendrequest")
        .doc(accountuseremail)
        .delete();

    await db.collection("users").doc(postuseremail).update({
      "friendrequest": FieldValue.arrayRemove([accountuseremail])
    });

    await db.collection("users").doc(accountuseremail).update({
      "sendfriendrequest": FieldValue.arrayRemove([postuseremail])
    });
    notifyListeners();
  }

  Future? getfollow(
      String postuseremail,
      String accountuseremail,
      String accountuserfastname,
      String accountuserlastname,
      String accountuserprofilepic) async {
    await db
        .collection('users')
        .doc(postuseremail)
        .collection("follower")
        .doc(accountuseremail)
        .set({
      "fastname": accountuserfastname,
      "lastname": accountuserlastname,
      "profilepic": accountuserprofilepic
    });
    await db.collection("users").doc(postuseremail).update({
      "follower": FieldValue.arrayUnion([accountuseremail])
    });

    await db.collection("users").doc(accountuseremail).update({
      "following": FieldValue.arrayUnion([postuseremail])
    });
  }

  Future? followremove(
      String postuseremail,
      String accountuseremail,
      String accountuserfastname,
      String accountuserlastname,
      String accountuserprofilepic) async {
    await db
        .collection('users')
        .doc(postuseremail)
        .collection("follower")
        .doc(accountuseremail)
        .delete();

    await db.collection("users").doc(postuseremail).update({
      "follower": FieldValue.arrayRemove([accountuseremail])
    });

    await db.collection("users").doc(accountuseremail).update({
      "following": FieldValue.arrayRemove([postuseremail])
    });
    notifyListeners();
  }
}
