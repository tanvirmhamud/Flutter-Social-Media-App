import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Pages/userprofile.dart';
import 'package:flutter_social_media/Provider/likefunction.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';

import 'commentbuttomsheet.dart';

class Allpostshow extends StatelessWidget {
  const Allpostshow({
    Key? key,
    required this.postdocumets,
    required this.likefunction,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> postdocumets;
  final Likeprovider likefunction;

  @override
  Widget build(BuildContext context) {
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
                postdocumets['profilepic'] == null
                    ? CircleAvatar(
                        backgroundImage: AssetImage('images/profilepic.jpg'),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(postdocumets['profilepic']),
                      ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            documentSnapshot: postdocumets,
                          ),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${postdocumets['fastname']} ${postdocumets['lastname']}"),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "@${postdocumets['username']}",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
              ],
            ),
            Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postdocumets['post'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(postdocumets['post'][index]),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                postdocumets['imageuploadbool']
                    ? Container(
                        height: 250.0,
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: postdocumets['image'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              height: 150.0,
                              width: 250.0,
                              child: Container(
                                child: ClipRRect(
                                  child: Image.network(
                                    postdocumets['image'][index],
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
                  child: postdocumets['likeuser'].length < 1
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
                            Text("${postdocumets['likeuser'].length}"),
                          ],
                        ),
                ),
                Spacer(),
                postdocumets['comments'] == false
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: postdocumets.reference
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
                    if (postdocumets['likeuser']
                        .contains(Useremail.useremailget)) {
                      likefunction.removelike(
                          postemail: postdocumets['email'],
                          postid: postdocumets.id,
                          accountuseremail: Useremail.useremailget);
                    } else {
                      likefunction.getlike(
                          postemail: postdocumets['email'],
                          postid: postdocumets.id,
                          accountuseremail: Useremail.useremailget);
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(postdocumets['likeuser']
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
                              documentSnapshot: postdocumets,
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
