import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Pages/userprofile.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/likefunction.dart';
import 'package:flutter_social_media/Widgets/appbar.dart';
import 'package:flutter_social_media/Widgets/commentbuttomsheet.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class PostPages extends StatefulWidget {
  const PostPages({Key? key}) : super(key: key);

  @override
  _PostPagesState createState() => _PostPagesState();
}

class _PostPagesState extends State<PostPages> {
  @override
  Widget build(BuildContext context) {
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    final likefunction = Provider.of<Likeprovider>(context);
    return SingleChildScrollView(
      child: Container(
          child: Column(
        children: [
          AppbarPage(
            appbarname: "Social App",
          ),
          Container(
            height: 70.0,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: index == 0 ? Border.all() : null),
                  child: Column(
                    children: [
                      index == 0
                          ? IconButton(onPressed: () {}, icon: Icon(Icons.add))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                child: Image.network(
                                  "https://st.depositphotos.com/1428083/2946/i/600/depositphotos_29460297-stock-photo-bird-cage.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height - 158,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                  stream: firebasedata.getuserpostfirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var postdocumets = snapshot.data!.docs[index];
                            return Card(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data!.docs[index]['profilepic']),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfile(
                                                    documentSnapshot:
                                                        postdocumets,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${postdocumets['fastname']} ${postdocumets['lastname']}"),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "@${postdocumets['username']}",
                                                  style: TextStyle(
                                                      color: Colors.grey[400]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.more_vert))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              postdocumets['post'].length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.only(
                                                  top: 10.0, right: 10.0),
                                              child: Text(
                                                  postdocumets['post'][index]),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        postdocumets['imageuploadbool']
                                            ? Container(
                                                height: 150.0,
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      postdocumets['image']
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                      height: 150.0,
                                                      width: 150.0,
                                                      child: Container(
                                                        child: ClipRRect(
                                                          child: Image.network(
                                                            postdocumets[
                                                                'image'][index],
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
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
                                          child:
                                              postdocumets['likeuser'].length <
                                                      1
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
                                                        Text(
                                                            "${postdocumets['likeuser'].length}"),
                                                      ],
                                                    ),
                                        ),
                                        Spacer(),
                                        postdocumets['comments'] == false
                                            ? Container()
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    right: 10.0),
                                                child: Row(
                                                  children: [
                                                    StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: postdocumets
                                                          .reference
                                                          .collection(
                                                              'comments')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          List commentdatalist =
                                                              snapshot
                                                                  .data!.docs
                                                                  .map((e) =>
                                                                      e.id)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (postdocumets['likeuser']
                                                .contains(
                                                    Useremail.useremailget)) {
                                              likefunction.removelike(
                                                  postemail:
                                                      postdocumets['email'],
                                                  postid: postdocumets.id,
                                                  accountuseremail:
                                                      Useremail.useremailget);
                                            } else {
                                              likefunction.getlike(
                                                  postemail:
                                                      postdocumets['email'],
                                                  postid: postdocumets.id,
                                                  accountuseremail:
                                                      Useremail.useremailget);
                                            }
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(postdocumets['likeuser']
                                                        .contains(Useremail
                                                            .useremailget)
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
                                                builder: (context) =>
                                                    CommentButtomSheet(
                                                      documentSnapshot:
                                                          postdocumets,
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
                          });
                    } else {
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    }
                  })),
        ],
      )),
    );
  }
}
