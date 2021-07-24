import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Likeprovider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future? getlike(
      {required String postemail,
      required String postid,
      required String accountuseremail}) async {
    await db
        .collection("users")
        .doc(postemail)
        .collection("post")
        .doc(postid)
        .update({
      "likeuser": FieldValue.arrayUnion([accountuseremail]),
    });
  }

  Future? removelike(
      {required String postemail, required String postid, required String accountuseremail}) async {
    await db
        .collection("users")
        .doc(postemail)
        .collection("post")
        .doc(postid)
        .update({
      "likeuser": FieldValue.arrayRemove([accountuseremail]),
    });
  }
}
