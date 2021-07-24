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
}
