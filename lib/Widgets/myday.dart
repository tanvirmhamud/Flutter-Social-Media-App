import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/myday.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';

import 'mydayview.dart';

class Mydaypagesliver extends StatelessWidget {
  const Mydaypagesliver({
    Key? key,
    required this.mydayfunction,
  }) : super(key: key);

  final MydayProvider mydayfunction;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: mydayfunction.db
                        .collection('users')
                        .doc(Useremail.useremailget)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var accountuser = snapshot.data;
                        return Container(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: mydayfunction.mydayview(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CustomScrollView(
                                    scrollDirection: Axis.horizontal,
                                    slivers: [
                                      SliverToBoxAdapter(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 10.0),
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all()),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      mydayfunction
                                                          .mydayimageupload(
                                                              Useremail
                                                                  .useremailget,
                                                              accountuser![
                                                                  'profilepicurl'],
                                                              accountuser[
                                                                  'fastname'],
                                                              accountuser[
                                                                  'lastname'],
                                                              accountuser[
                                                                  'username'],
                                                              accountuser[
                                                                  'email']);
                                                    },
                                                    icon: Icon(Icons.add)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            var data =
                                                snapshot.data!.docs[index];
                                            return Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      MydayView(
                                                                        documentSnapshot:
                                                                            data,
                                                                      ),
                                                              isScrollControlled:
                                                                  true);
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Container(
                                                            height: 210.0,
                                                            width: 120.0,
                                                            child:
                                                                Image.network(
                                                              data['myday'][0],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 15,
                                                  bottom: 172,
                                                  left: 10,
                                                  right: 80,
                                                  child: Container(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      height: 20.0,
                                                      width: 20.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.network(
                                                          data['profilepic'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
