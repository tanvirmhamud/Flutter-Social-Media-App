import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Userchatpageprovider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;


  



  Future? chatroomcreated(String accountuseremail, String chatuseremail) async {
    await db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .set({
      // ignore: unnecessary_brace_in_string_interps
      "chatroom_id": "${accountuseremail}_${chatuseremail}",
      // ignore: unnecessary_brace_in_string_interps
      "users":
          FieldValue.arrayUnion(["${accountuseremail}", "${chatuseremail}"])
    });
    await db
        .collection("users")
        .doc(chatuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${chatuseremail}_${accountuseremail}")
        .set({
      // ignore: unnecessary_brace_in_string_interps
      "chatroom_id": "${chatuseremail}_${accountuseremail}",
      // ignore: unnecessary_brace_in_string_interps
      "users":
          FieldValue.arrayUnion(["${accountuseremail}", "${chatuseremail}"])
    });

    // await db
    //     .collection("users")
    //     .doc(accountuseremail)
    //     .collection('message')
    //     // ignore: unnecessary_brace_in_string_interps
    //     .doc("${accountuseremail}_${chatuseremail}")
    //     .collection('chats')
    //     .add({"message": messagetext, "message_by": accountuseremail});

    //  await db
    //     .collection("users")
    //     .doc(chatuseremail)
    //     .collection('message')
    //     // ignore: unnecessary_brace_in_string_interps
    //     .doc("${chatuseremail}_${accountuseremail}")
    //     .collection('chats')
    //     .add({"message": messagetext, "message_by": accountuseremail});
  }



  Future? sendmessage(String accountuseremail, String chatuseremail, String messagetext) async {
    await db
        .collection("users")
        .doc(accountuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${accountuseremail}_${chatuseremail}")
        .collection('chats')
        .add({"message": messagetext, "message_by": accountuseremail});

     await db
        .collection("users")
        .doc(chatuseremail)
        .collection('message')
        // ignore: unnecessary_brace_in_string_interps
        .doc("${chatuseremail}_${accountuseremail}")
        .collection('chats')
        .add({"message": messagetext, "message_by": accountuseremail});
  }
}
