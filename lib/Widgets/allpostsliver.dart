import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Pages/userprofile.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/likefunction.dart';
import 'package:flutter_social_media/Widgets/editpost.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

import 'commentbuttomsheet.dart';

class Allpostshow extends StatefulWidget {
  const Allpostshow({
    Key? key,
    required this.postdocumets,
    required this.likefunction,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> postdocumets;
  final Likeprovider likefunction;

  @override
  _AllpostshowState createState() => _AllpostshowState();
}

class _AllpostshowState extends State<Allpostshow> {
  final GlobalKey _menuKey = new GlobalKey();
  List<PopupMenuEntry> popuplist = [
    PopupMenuItem(child: Text("Edit")),
    PopupMenuItem(child: Text("Delete")),
  ];

  @override
  Widget build(BuildContext context) {
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: EdgeInsets.only(
          left: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                widget.postdocumets['profilepic'] == null
                    ? CircleAvatar(
                        backgroundImage: AssetImage('images/profilepic.jpg'),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.postdocumets['profilepic']),
                      ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            documentSnapshot: widget.postdocumets,
                          ),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${widget.postdocumets['fastname']} ${widget.postdocumets['lastname']}"),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "@${widget.postdocumets['username']}",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                PopupMenuButton(
                  itemBuilder: (context) => <PopupMenuItem<String>>[
                    if (widget.postdocumets['email'] == Useremail.useremailget)
                      new PopupMenuItem<String>(
                          child: const Text('Edit'), value: 'Edit'),
                    if (widget.postdocumets['email'] == Useremail.useremailget)
                      new PopupMenuItem<String>(
                          child: const Text('Delete'), value: 'Delete'),
                    new PopupMenuItem<String>(
                        child: const Text('Report'), value: 'Report'),
                  ],
                  onSelected: (value) {
                    if (value == "Edit") {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Editpost(
                          documents: widget.postdocumets,
                        ),
                        isScrollControlled: true,
                      );
                    }
                    if (value == "Delete") {
                      firebasedata.deletepost(
                          Useremail.useremailget, widget.postdocumets.id);
                    }
                  },
                )
              ],
            ),
            Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.postdocumets['post'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(widget.postdocumets['post'][index]),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                widget.postdocumets['imageuploadbool']
                    ? Container(
                        height: 250.0,
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.postdocumets['image'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              height: 150.0,
                              width: 250.0,
                              child: Container(
                                child: ClipRRect(
                                  child: Image.network(
                                    widget.postdocumets['image'][index],
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
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
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Container(
                  child: widget.postdocumets['likeuser'].length < 1
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
                            Text("${widget.postdocumets['likeuser'].length}"),
                          ],
                        ),
                ),
                Spacer(),
                widget.postdocumets['comments'] == false
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: widget.postdocumets.reference
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List commentdatalist = snapshot.data!.docs
                                      .map((e) => e.id)
                                      .toList();
                                  return Container(
                                    child: Row(
                                      children: [
                                        Text("${commentdatalist.length}"),
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
                    if (widget.postdocumets['likeuser']
                        .contains(Useremail.useremailget)) {
                      widget.likefunction.removelike(
                          postemail: widget.postdocumets['email'],
                          postid: widget.postdocumets.id,
                          accountuseremail: Useremail.useremailget);
                    } else {
                      widget.likefunction.getlike(
                          postemail: widget.postdocumets['email'],
                          postid: widget.postdocumets.id,
                          accountuseremail: Useremail.useremailget);
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(widget.postdocumets['likeuser']
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
                              documentSnapshot: widget.postdocumets,
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
  }
}
