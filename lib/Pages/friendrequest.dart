import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/friendreq.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class FriendReqPage extends StatefulWidget {
  const FriendReqPage({Key? key}) : super(key: key);

  @override
  _FriendReqPageState createState() => _FriendReqPageState();
}

class _FriendReqPageState extends State<FriendReqPage> {

  @override
  Widget build(BuildContext context) {
    final friendsreq = Provider.of<FriendreqProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Friend Request",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: friendsreq.getallfriendreq(Useremail.useremailget),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return StreamBuilder<DocumentSnapshot>(
                      stream: friendsreq.db
                          .collection('users')
                          .doc(data.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var frienduserdata = snapshot.data;
                          return StreamBuilder<DocumentSnapshot>(
                              stream: friendsreq.db
                                  .collection('users')
                                  .doc(Useremail.useremailget)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var accountuserdata = snapshot.data;
                                  return Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                data['profilepic']),
                                            maxRadius: 40,
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 9.0),
                                                  child: Text(
                                                    "${data['fastname']} ${data['lastname']}",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                data['acceptedfriendreq'] == false
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                friendsreq.acceptedfriend(
                                                                    Useremail
                                                                        .useremailget,
                                                                    data.id,
                                                                    frienduserdata![
                                                                        'fastname'],
                                                                    frienduserdata[
                                                                        'lastname'],
                                                                    frienduserdata[
                                                                        'username'],
                                                                    frienduserdata[
                                                                        'profilepicurl'],
                                                                    accountuserdata![
                                                                        'fastname'],
                                                                    accountuserdata[
                                                                        'lastname'],
                                                                    accountuserdata[
                                                                        'username'],
                                                                    accountuserdata[
                                                                        'profilepicurl']);
                                                               

                                                                Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            5),
                                                                    () {
                                                                  friendsreq.frienreqdelete(
                                                                      Useremail
                                                                          .useremailget,
                                                                      data.id);
                                                                });
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 90.0,
                                                                child: Text(
                                                                    "Confirm"),
                                                              )),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                friendsreq.frienreqdelete(
                                                                    Useremail
                                                                        .useremailget,
                                                                    data.id);
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 90.0,
                                                                child: Text(
                                                                    "Delete"),
                                                              )),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                              "you are now friends",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              });
                        } else {
                          return Container();
                        }
                      });
                },
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
