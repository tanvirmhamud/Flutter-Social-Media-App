import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Userchatpageprovider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot>? getchatuser(String chatuseremail) {
    return db.collection("users").doc(chatuseremail).snapshots();
  }

  Stream<QuerySnapshot>? allchatuser(String accountuseremail) {
    return db
        .collection('users')
        .doc(accountuseremail)
        .collection('message')
        .snapshots();
  }

  Stream<DocumentSnapshot>? getchatroom(
      String accountuseremail, String chatuseremail) {
    return db
        .collection('users')
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .snapshots();
  }

  Stream<QuerySnapshot>? getmessage(
      String accountuseremail, String chatuseremail) {
    return db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future? chatroomcreated(
      String accountuseremail,
      String chatuseremail,
      String chatuserfastname,
      chatuserlastname,
      chatuserprofilepic,
      String accountfastname,
      accountlastname,
      accountprofilepic) async {
    await db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .set({
      "fastname": chatuserfastname,
      "lastname": chatuserlastname,
      "profilepic": chatuserprofilepic,
      "email": chatuseremail,
      // ignore: unnecessary_brace_in_string_interps
      "chatroom_id": "${accountuseremail}_${chatuseremail}",
      "sendmessage": false,
      // ignore: unnecessary_brace_in_string_interps
      "users":
          // ignore: unnecessary_brace_in_string_interps
          FieldValue.arrayUnion(["${accountuseremail}", "${chatuseremail}"])
    });
    await db
        .collection("users")
        .doc(chatuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${chatuseremail}_${accountuseremail}")
        .set({
      "fastname": accountfastname,
      "lastname": accountlastname,
      "profilepic": accountprofilepic,
      "email": accountuseremail,
      // ignore: unnecessary_brace_in_string_interps
      "chatroom_id": "${chatuseremail}_${accountuseremail}",
      "sendmessage": false,
      // ignore: unnecessary_brace_in_string_interps
      "users":
          // ignore: unnecessary_brace_in_string_interps
          FieldValue.arrayUnion(["${accountuseremail}", "${chatuseremail}"])
    });
  }

  Future? sendmessage(
      String accountuseremail, String chatuseremail, String messagetext) async {
    await db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .collection('chats')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "message": messagetext,
      "messagefrom": accountuseremail,
      "messageto": chatuseremail,
      "time": DateTime.now().millisecondsSinceEpoch
    });
    await db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .update({
      "sendmessage": true,
    });

    await db
        .collection("users")
        .doc(chatuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${chatuseremail}_${accountuseremail}")
        .collection('chats')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "message": messagetext,
      "messagefrom": accountuseremail,
      "messageto": chatuseremail,
      "time": DateTime.now().millisecondsSinceEpoch
    });

    await db
        .collection("users")
        .doc(chatuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${chatuseremail}_${accountuseremail}")
        .update({
      "sendmessage": true,
    });
  }
}
