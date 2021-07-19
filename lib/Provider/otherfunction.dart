import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OthderFunctionprovider extends ChangeNotifier {
  String? text;

  settext(String _text) {
    text = _text;
    notifyListeners();
  }





}
