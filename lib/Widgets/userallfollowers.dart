import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/userprofile.dart';
import 'package:provider/provider.dart';

class Userallfollowers extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const Userallfollowers({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _UserallfollowersState createState() => _UserallfollowersState();
}

class _UserallfollowersState extends State<Userallfollowers> {
  @override
  Widget build(BuildContext context) {
    final userallfollowers = Provider.of<Userprofileprovider>(context);
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
          stream: userallfollowers.db
              .collection('users')
              .doc(widget.documentSnapshot['email'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userdata = snapshot.data;
              return Container(
                child: userdata!['follower'].length == 0
                    ? Container(
                        child: Center(
                          child: Text("No follower"),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "${userdata['follower'].length} Follower",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: userallfollowers.getuserallfollowers(
                                      widget.documentSnapshot['email']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var data = snapshot.data!.docs[index];
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data['profilepic']),
                                                    maxRadius: 40,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: Text(
                                                    "${data['fastname']} ${data['lastname']}",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                Spacer(),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.more_vert))
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
