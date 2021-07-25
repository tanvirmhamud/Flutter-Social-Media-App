import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider extends ChangeNotifier {
  List<XFile>? imageFileList;
  List<XFile>? postaddimageFileList;
  String? profilepicname;

  final picker = ImagePicker();
  final _firebasestorage = FirebaseStorage.instance;

  void set imageFile(XFile? value) {
    imageFileList = value == null ? null : [value];
  }

  Future uploadimagefirebase(String useremail) async {
    final XFile? _imagefile =
        await picker.pickImage(source: ImageSource.gallery);
    imageFile = _imagefile;
    var file = File(_imagefile!.path);

    if (imageFileList != null) {
      var snapshot = await _firebasestorage
          .ref()
          .child('profileimages/${useremail}/profileimage')
          .putFile(file);
      var downloadurl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(useremail)
          .collection('profilepic')
          .doc(useremail)
          .set({"profile-imageurl": downloadurl}).then((value) {
        print("Image Upload successfull");
        notifyListeners();
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(useremail)
          .update({"profilepicurl": downloadurl}).then((value) {
        print("Image Upload successfull");
        notifyListeners();
      });

      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(useremail)
          .collection('post');
      QuerySnapshot documents = await collection.get();
      for (var doc in documents.docs) {
        doc.reference.update({"profilepic": downloadurl});
      }

      print("Post Profile Pic update success");
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(useremail)
          .update({"profilepic": true}).then((value) {
        print("Profile Pic Is true");
        notifyListeners();
      });
    } else {
      print("image upload unsuccessfull");
      notifyListeners();
    }

    notifyListeners();
  }

  Future postaddimage() async {
    final pickedFileList = await picker.pickMultiImage();

    postaddimageFileList = pickedFileList;
    notifyListeners();
  }
}
