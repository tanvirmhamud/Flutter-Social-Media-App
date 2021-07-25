import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendreqProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? getallfriendreq(String accountuseremail) {
    return db
        .collection('users')
        .doc(accountuseremail)
        .collection("friendrequest")
        .snapshots();
  }

  Future? frienreqdelete(String accountuseremail, String friendreqid) async {
    await db
        .collection('users')
        .doc(accountuseremail)
        .collection('friendrequest')
        .doc(friendreqid)
        .delete();

    await db.collection('users').doc(accountuseremail).update({
      "friendrequest": FieldValue.arrayRemove([friendreqid])
    });
    await db.collection('users').doc(friendreqid).update({
      "sendfriendrequest": FieldValue.arrayRemove([accountuseremail])
    });
  }

  Future? acceptedfriend(
      String accountuseremail,
      String friendreqid,
      String friendidfastname,
      lastname,
      username,
      profilepic,
      String accountuserfastname,
      accountlastname,
      accountusername,
      accountprofilepic) async {
    await db
        .collection('users')
        .doc(accountuseremail)
        .collection("friendrequest")
        .doc(friendreqid)
        .update({"acceptedfriendreq": true});
    await db
        .collection('users')
        .doc(accountuseremail)
        .collection('friends')
        .doc(friendreqid)
        .set({
      "fastname": friendidfastname,
      "lastname": lastname,
      "username": username,
      "profilepic": profilepic
    });
    await db
        .collection('users')
        .doc(friendreqid)
        .collection('friends')
        .doc(accountuseremail)
        .set({
      "fastname": accountuserfastname,
      "lastname": accountlastname,
      "username": accountuseremail,
      "profilepic": accountprofilepic
    });

    await db.collection('users').doc(accountuseremail).update({
      "friends": FieldValue.arrayUnion([friendreqid])
    });
    await db.collection('users').doc(friendreqid).update({
      "friends": FieldValue.arrayUnion([accountuseremail])
    });
  }

  Future? deletefriend(
    String accountuseremail,
    String friendreqid,
  ) async {
    await db
        .collection('users')
        .doc(accountuseremail)
        .collection('friends')
        .doc(friendreqid)
        .delete();
    await db
        .collection('users')
        .doc(friendreqid)
        .collection('friends')
        .doc(accountuseremail)
        .delete();

    await db.collection('users').doc(accountuseremail).update({
      "friends": FieldValue.arrayRemove([friendreqid])
    });
    await db.collection('users').doc(friendreqid).update({
      "friends": FieldValue.arrayRemove([accountuseremail])
    });
  }
}
