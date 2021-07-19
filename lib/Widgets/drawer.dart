import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Account/login.dart';
import 'package:flutter_social_media/Pages/Profilepage.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    return Container(
      width: 250.0,
      child: Drawer(
        child: StreamBuilder(
            stream: firebasedata.db
                .collection('users')
                .doc(Useremail.useremailget)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                var documents = snapshot.data;
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: documents!['profilepic'] == true
                                  ? StreamBuilder<QuerySnapshot>(
                                      stream: firebasedata.streamDataCollection(
                                          Useremail.useremailget, 'profilepic'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String profileimage = snapshot
                                              .data!.docs
                                              .map((e) => e['profile-imageurl'])
                                              .first;
                                          return CircleAvatar(
                                            minRadius: 60.0,
                                            backgroundImage:
                                                NetworkImage(profileimage),
                                          );
                                        } else {
                                          return Container(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      })
                                  : CircleAvatar(
                                      minRadius: 60.0,
                                      backgroundImage:
                                          AssetImage("images/profilepic.jpg"),
                                    ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Text(
                                "${documents['fastname']} ${documents['lastname']}",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: Divider(
                          height: 5.0,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePage(),
                                      ));
                                },
                                child: Text("Profile Setting")),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.remove('email');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ));
                              },
                              child: Text("Logout"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
