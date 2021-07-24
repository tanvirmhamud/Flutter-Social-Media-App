import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Account/login.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/account.dart';
import 'package:flutter_social_media/Provider/otherfunction.dart';
import 'package:flutter_social_media/Provider/userprofilefunction.dart';
import 'package:flutter_social_media/homepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/commentfunction.dart';
import 'Provider/imageupload.dart';
import 'Provider/likefunction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var finalemail = sharedPreferences.getString('email');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => CommentFunction()),
        ChangeNotifierProvider(create: (context) => Likeprovider()),
        ChangeNotifierProvider(create: (context) => OthderFunctionprovider()),
        ChangeNotifierProvider(create: (context) => FirebasedataProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (context) => Accountprovider())
      ],
      child: (MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: finalemail == null ? LoginPage() : Homepage(),
      ))));
}
