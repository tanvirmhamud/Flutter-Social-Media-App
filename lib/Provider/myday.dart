import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MydayProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _firebasestorage = FirebaseStorage.instance;
  List<XFile>? postaddimageFileList;
  List<String> imageurl = [];

  final picker = ImagePicker();

  Future mydayimageupload(String accountemail, String accountuserprofilepic,
      String fastname, lastname, username, email) async {
    final pickedFileList = await picker.pickMultiImage(imageQuality: 50);
    postaddimageFileList = pickedFileList;
    notifyListeners();

    if (postaddimageFileList != null) {
      for (int i = 0; i < postaddimageFileList!.length; i++) {
        var file = File(postaddimageFileList![i].path);
        var snapshot = await _firebasestorage
            .ref()
            // ignore: unnecessary_brace_in_string_interps
            .child('postimage/${accountemail}/postimage$i')
            .putFile(file);

        imageurl.add(await snapshot.ref.getDownloadURL());
      }
      await db
          .collection('users')
          .doc(accountemail)
          .collection('myday')
          .doc(accountemail)
          .set({
        "myday": imageurl,
        "profilepic": accountuserprofilepic,
        "fastname": fastname,
        "lastname": lastname,
        "username": username,
        "email": email
      }).then((value) {
        print("Myday upload sucessfull");
      });
      notifyListeners();
      imageurl.clear();
      postaddimageFileList!.clear();
    }
  }

  Stream<QuerySnapshot>? mydayview() {
    return db.collectionGroup('myday').snapshots();
  }
}
