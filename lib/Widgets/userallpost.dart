import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/likefunction.dart';
import 'package:flutter_social_media/Provider/userprofile.dart';
import 'package:flutter_social_media/Widgets/commentbuttomsheet.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class UserAllPost extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const UserAllPost({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _UserAllPostState createState() => _UserAllPostState();
}

class _UserAllPostState extends State<UserAllPost> {
  @override
  Widget build(BuildContext context) {
    final userallpost = Provider.of<Userprofileprovider>(context);
    final likefunction = Provider.of<Likeprovider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: userallpost.getuserallpost(widget.documentSnapshot['email']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              data['profilepic'] == null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/profilepic.jpg'),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data['profilepic']),
                                    ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${data['fastname']} ${data['lastname']}"),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "@${data['username']}",
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.more_vert))
                            ],
                          ),
                          Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data['post'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding:
                                        EdgeInsets.only(top: 10.0, right: 10.0),
                                    child: Text(data['post'][index]),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              data['imageuploadbool']
                                  ? Container(
                                      height: 150.0,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data['image'].length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            height: 150.0,
                                            width: 150.0,
                                            child: Container(
                                              child: ClipRRect(
                                                child: Image.network(
                                                  data['image'][index],
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              height: 150.0,
                                              width: 150.0,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: data['likeuser'].length < 1
                                    ? Container()
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text("${data['likeuser'].length}"),
                                        ],
                                      ),
                              ),
                              Spacer(),
                              data['comments'] == false
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Row(
                                        children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: data.reference
                                                .collection('comments')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List commentdatalist = snapshot
                                                    .data!.docs
                                                    .map((e) => e.id)
                                                    .toList();
                                                return Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          "${commentdatalist.length}"),
                                                      SizedBox(
                                                        width: 3.0,
                                                      ),
                                                      Text("comments")
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (data['likeuser']
                                      .contains(Useremail.useremailget)) {
                                    likefunction.removelike(
                                        postemail: data['email'],
                                        postid: data.id,
                                        accountuseremail:
                                            Useremail.useremailget);
                                  } else {
                                    likefunction.getlike(
                                        postemail: data['email'],
                                        postid: data.id,
                                        accountuseremail:
                                            Useremail.useremailget);
                                  }
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(data['likeuser']
                                              .contains(Useremail.useremailget)
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      Text("Like"),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => CommentButtomSheet(
                                            documentSnapshot: data,
                                          ),
                                      isScrollControlled: true);
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.comment),
                                      Text("comment"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.share),
                                    Text("share"),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
          },
        ),
      ),
    );
  }
}
