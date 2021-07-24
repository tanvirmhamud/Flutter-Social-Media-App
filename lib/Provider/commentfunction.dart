import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommentFunction extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _firebasestorage = FirebaseStorage.instance;
  final picker = ImagePicker();
  XFile? _imageFile;
  var file;
  var downloadurl;
  String? commenttext;

  Future? sendcomment(
      String postemail,
      String postid,
      String usercommenttext,
      String useremail,
      String fastname,
      String lastname,
      String profilepic) async {
    if (file != null) {
      var snapshot = await _firebasestorage
          .ref()
          .child('commentimage/${useremail}/${_imageFile!.name}')
          .putFile(file);
      downloadurl = await snapshot.ref.getDownloadURL();
    }

    await db
        .collection('users')
        .doc(postemail)
        .collection('post')
        .doc(postid)
        .collection("comments")
        .add({
      "comentimage": downloadurl,
      "commentstext": usercommenttext,
      "email": useremail,
      "fastname": fastname,
      "lastname": lastname,
      "profilepic": profilepic,
    });
    await db
        .collection('users')
        .doc(postemail)
        .collection('post')
        .doc(postid)
        .update({"comments": true});
    commenttext = null;
    if (file != null) imageremove();
    notifyListeners();
  }

  Future? commentimage() async {
    var imagefile = await picker.pickImage(source: ImageSource.gallery);
    _imageFile = imagefile;
    file = File(imagefile!.path);
    notifyListeners();
  }

  Future? imageremove() async {
    file = null;
    downloadurl = null;
    notifyListeners();
  }

  Future? commentetxt(String text) {
    commenttext = text;
    notifyListeners();
  }
}
