import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/friendreq.dart';
import 'package:flutter_social_media/Provider/userchatpage.dart';
import 'package:flutter_social_media/Provider/userprofile.dart';
import 'package:flutter_social_media/Widgets/userallfollowers.dart';
import 'package:flutter_social_media/Widgets/userallfriends.dart';
import 'package:flutter_social_media/Widgets/userallpost.dart';
import 'package:flutter_social_media/Widgets/userchatpage.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

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
    final userallpost = Provider.of<Userprofileprovider>(context);
    final friendfunction = Provider.of<FriendreqProvider>(context);
    final chatfunction = Provider.of<Userchatpageprovider>(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: userallpost.db
                .collection("users")
                .doc(Useremail.useremailget)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var useraccountdata = snapshot.data;
                return Container(
                    child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: widget.documentSnapshot['profilepic'] == null
                            ? CircleAvatar(
                                maxRadius: 70.0,
                                backgroundImage:
                                    AssetImage('images/profilepic.jpg'),
                              )
                            : CircleAvatar(
                                maxRadius: 70.0,
                                backgroundImage: NetworkImage(
                                    widget.documentSnapshot['profilepic']),
                              ),
                      ),
                    ),
                    Text(
                      "${widget.documentSnapshot['fastname']} ${widget.documentSnapshot['lastname']}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Useremail.useremailget ==
                                widget.documentSnapshot['email']
                            ? Container(
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
                                      child: Text("Edit Profile"),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      chatfunction.chatroomcreated(
                                          Useremail.useremailget,
                                          widget.documentSnapshot['email']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Userchatpage(
                                                documentSnapshot:
                                                    widget.documentSnapshot),
                                          ));
                                    },
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
                        Useremail.useremailget ==
                                widget.documentSnapshot['email']
                            ? Container()
                            : useraccountdata!['friends']
                                    .contains(widget.documentSnapshot['email'])
                                ? Container(
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  750,
                                              width: 100.0,
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        friendfunction.deletefriend(
                                                            useraccountdata[
                                                                'email'],
                                                            widget.documentSnapshot[
                                                                'email']);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                            "Unfriend ${widget.documentSnapshot['fastname']} ${widget.documentSnapshot['lastname']}"),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        focusColor: Colors.indigo,
                                        highlightColor: Colors.indigo,
                                        splashColor: Colors.indigo,
                                        child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              "Friend",
                                              style: TextStyle(
                                                  color: Colors.indigoAccent),
                                            )),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          if (useraccountdata[
                                                  'sendfriendrequest']
                                              .contains(widget
                                                  .documentSnapshot['email'])) {
                                            userallpost.sendrequestdelect(
                                                widget
                                                    .documentSnapshot['email'],
                                                useraccountdata['email'],
                                                useraccountdata['fastname'],
                                                useraccountdata['lastname'],
                                                useraccountdata[
                                                    'profilepicurl']);
                                          } else {
                                            userallpost.sendfriendreq(
                                                widget
                                                    .documentSnapshot['email'],
                                                useraccountdata['email'],
                                                useraccountdata['fastname'],
                                                useraccountdata['lastname'],
                                                useraccountdata[
                                                    'profilepicurl']);
                                          }
                                        },
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        focusColor: Colors.indigo,
                                        highlightColor: Colors.indigo,
                                        splashColor: Colors.indigo,
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: useraccountdata[
                                                      'sendfriendrequest']
                                                  .contains(
                                                      widget.documentSnapshot[
                                                          'email'])
                                              ? Text("request",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.indigoAccent))
                                              : Text(
                                                  "Add friends",
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                        Useremail.useremailget ==
                                widget.documentSnapshot['email']
                            ? Container()
                            : Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (useraccountdata!['following']
                                          .contains(widget
                                              .documentSnapshot['email'])) {
                                        userallpost.followremove(
                                            widget.documentSnapshot['email'],
                                            useraccountdata['email'],
                                            useraccountdata['fastname'],
                                            useraccountdata['lastname'],
                                            useraccountdata['profilepicurl']);
                                      } else {
                                        userallpost.getfollow(
                                            widget.documentSnapshot['email'],
                                            useraccountdata['email'],
                                            useraccountdata['fastname'],
                                            useraccountdata['lastname'],
                                            useraccountdata['profilepicurl']);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(5.0),
                                    focusColor: Colors.indigo,
                                    highlightColor: Colors.indigo,
                                    splashColor: Colors.indigo,
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: useraccountdata!['following']
                                              .contains(widget
                                                  .documentSnapshot['email'])
                                          ? Text(
                                              "Following",
                                              style: TextStyle(
                                                  color: Colors.indigoAccent),
                                            )
                                          : Text("Follow"),
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
                                    StreamBuilder<QuerySnapshot>(
                                        stream: userallpost.getuserallpost(
                                            widget.documentSnapshot['email']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List postlist = snapshot.data!.docs
                                                .map((e) => e.id)
                                                .toList();
                                            return Text(
                                              "${postlist.length}",
                                              style: TextStyle(fontSize: 18.0),
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        }),
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
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: userallpost.db
                                            .collection('users')
                                            .doc(widget
                                                .documentSnapshot['email'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var friends = snapshot.data;
                                            return Text(
                                              "${friends!['friends'].length}",
                                              style: TextStyle(fontSize: 18.0),
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        }),
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
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: userallpost.db
                                            .collection('users')
                                            .doc(widget
                                                .documentSnapshot['email'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var follower = snapshot.data;
                                            return Text(
                                              "${follower!['follower'].length}",
                                              style: TextStyle(fontSize: 18.0),
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        }),
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
                            UserAllfriends(
                              documentSnapshot: widget.documentSnapshot,
                            ),
                            Userallfollowers(
                              documentSnapshot: widget.documentSnapshot,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ));
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
}
