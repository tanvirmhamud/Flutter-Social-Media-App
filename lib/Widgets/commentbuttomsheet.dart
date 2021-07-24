import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/commentfunction.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class CommentButtomSheet extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const CommentButtomSheet({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _CommentButtomSheetState createState() => _CommentButtomSheetState();
}

class _CommentButtomSheetState extends State<CommentButtomSheet> {
  final testfieldcontroll = TextEditingController();
  bool sendbutton = false;
  String? commenttext;
  @override
  Widget build(BuildContext context) {
    final commentfunction = Provider.of<CommentFunction>(context);
    return Container(
      height: MediaQuery.of(context).size.height - 31,
      child: StreamBuilder<DocumentSnapshot>(
          stream: commentfunction.db
              .collection("users")
              .doc(Useremail.useremailget)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userdata = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite),
                            Text(
                                "${widget.documentSnapshot['likeuser'].length}"),
                          ],
                        ),
                        Divider(
                          height: 0.0,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: widget.documentSnapshot['comments'] == false
                          ? Container(
                              child: Center(
                                child: Text("No comment..."),
                              ),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: widget.documentSnapshot.reference
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    padding: EdgeInsets.all(0.0),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var commentdata =
                                          snapshot.data!.docs[index];
                                      return Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  commentdata['profilepic']),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${commentdata['fastname']} ${commentdata['lastname']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                        "${commentdata['commentstext']}"),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Container(
                                                      child: commentdata[
                                                                  'comentimage'] ==
                                                              null
                                                          ? Container(
                                                              width: 0.0,
                                                            )
                                                          : Container(
                                                              height: 130.0,
                                                              width: 80.0,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: Image
                                                                    .network(
                                                                  commentdata[
                                                                      'comentimage'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
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
                  Container(
                    child: Column(
                      children: [
                        Divider(
                          height: 0.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                              child: Container(
                            margin: EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              children: [
                                commentfunction.file == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 5.0,
                                              top: 5.0,
                                            ),
                                            height: 80.0,
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Container(
                                              height: 80.0,
                                              width: 100.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.file(
                                                  commentfunction.file,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                commentfunction.imageremove();
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: IconButton(
                                          onPressed: () {
                                            commentfunction.commentimage();
                                          },
                                          icon:
                                              Icon(Icons.camera_alt_outlined)),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.only(),
                                        child: TextFormField(
                                          controller: testfieldcontroll,
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              setState(() {
                                                sendbutton = false;
                                              });
                                            } else {
                                              setState(() {
                                                commentfunction
                                                    .commentetxt(value);
                                                sendbutton = true;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 3,
                                          minLines: 1,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 5,
                                                bottom: 11,
                                                top: 11,
                                                right: 5),
                                            hintText: "Write a comment...",
                                            filled: true,
                                            fillColor: Colors.grey[300],
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.emoji_emotions)),
                                    sendbutton
                                        ? IconButton(
                                            onPressed: () {
                                              commentfunction.sendcomment(
                                                  widget.documentSnapshot[
                                                      'email'],
                                                  widget.documentSnapshot.id,
                                                  commentfunction.commenttext!,
                                                  userdata!['email'],
                                                  userdata['fastname'],
                                                  userdata['lastname'],
                                                  userdata['profilepicurl']);
                                              testfieldcontroll.clear();
                                            },
                                            icon: Icon(Icons.send))
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }),
    );
  }
}
