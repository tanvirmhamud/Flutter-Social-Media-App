import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Widgets/userallpost.dart';

class UserProfile extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const UserProfile({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: widget.documentSnapshot['profilepic'] == null
                    ? CircleAvatar(
                        maxRadius: 70.0,
                        backgroundImage: AssetImage('images/profilepic.jpg'),
                      )
                    : CircleAvatar(
                        maxRadius: 70.0,
                        backgroundImage:
                            NetworkImage(widget.documentSnapshot['profilepic']),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      focusColor: Colors.indigo,
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Message"),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      focusColor: Colors.indigo,
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Add Friend"),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      focusColor: Colors.indigo,
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Follow"),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              "Post",
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              "Friends",
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.indigo,
                      splashColor: Colors.indigo,
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              "Follower",
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Flexible(
              child: Container(
                child: PageView(
                  children: [
                    UserAllPost(
                      documentSnapshot: widget.documentSnapshot,
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
