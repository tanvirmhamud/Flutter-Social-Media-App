import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/homepage.dart';
import 'package:image_picker/image_picker.dart';

class FirebasedataProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _firebasestorage = FirebaseStorage.instance;

  List<XFile>? postaddimageFileList;
  List<String> imageurl = [];

  final picker = ImagePicker();

  Stream<QuerySnapshot> streamDataCollection(
      String useremail, String collectionname) {
    return db
        .collection('users')
        .doc(useremail)
        .collection(collectionname)
        .snapshots();
  }

  Stream<DocumentSnapshot>? postaddpagefirebase(String useremail) {
    return db.collection('users').doc(useremail).snapshots();
  }

  Stream<QuerySnapshot> avaterpostaddpagefirebase(String useremail) {
    return db
        .collection('users')
        .doc(useremail)
        .collection("profilepic")
        .snapshots();
  }

  Stream<QuerySnapshot>? allusersdatafirebase() {
    return db.collection('users').snapshots();
  }

  Stream<QuerySnapshot>? getuserpostfirebase() {
    return db.collectionGroup('post').where('post').snapshots();
  }

  Future? updatedata(String fastname, lastname, username, email, countryname,
      phone, address, BuildContext context) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      "fastname": fastname,
      "lastname": lastname,
      "username": username,
      "email": email,
      "country": countryname,
      "phone": phone,
      "address": address
    }).then((value) {
      print("Information Update");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Information Update")));

      notifyListeners();
    });
    var collection = db.collection('users').doc(email).collection('post');
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        "fastname": fastname,
        "lastname": lastname,
        "username": username,
      });
    }
  }

  Future postimageupload() async {
    final pickedFileList = await picker.pickMultiImage();
    postaddimageFileList = pickedFileList;
    notifyListeners();
  }

  Future firebasecreatedpostandimage(
      String useremail,
      List<String> _post,
      BuildContext context,
      String _fastname,
      _lastname,
      _username,
      _profilepic,
      bool _imageuploadbool) async {
    if (postaddimageFileList != null) {
      for (int i = 0; i < postaddimageFileList!.length; i++) {
        var file = File(postaddimageFileList![i].path);
        var snapshot = await _firebasestorage
            .ref()
            .child('postimage/${useremail}/postimage$i')
            .putFile(file);

        imageurl.add(await snapshot.ref.getDownloadURL());
        notifyListeners();
      }
    }

    await db.collection('users').doc(useremail).collection('post').add({
      "post": FieldValue.arrayUnion(_post),
      "image": imageurl,
      "email": useremail,
      "fastname": _fastname,
      "lastname": _lastname,
      "username": _username,
      "profilepic": _profilepic,
      "imageuploadbool": _imageuploadbool,
      "comments": false,
      "likeuser": FieldValue.arrayUnion([])
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Create Post Successfull")));
      print("created post successfull");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ));
      postaddimageFileList!.clear();
      imageurl.clear();
      notifyListeners();
    });
    notifyListeners();
  }
}
