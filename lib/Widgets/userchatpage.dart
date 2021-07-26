import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/userchatpage.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class Userchatpage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const Userchatpage({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _UserchatpageState createState() => _UserchatpageState();
}

class _UserchatpageState extends State<Userchatpage> {
  bool sendbutton = false;
  String? messagetext;
  @override
  Widget build(BuildContext context) {
    final chatfunction = Provider.of<Userchatpageprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
              stream: chatfunction.db
                  .collection("users")
                  .doc(Useremail.useremailget)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Material(
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: 60.0,
                            child: Container(
                              margin: EdgeInsets.only(top: 0.0, left: 0.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      )),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.documentSnapshot['profilepic']),
                                    maxRadius: 23,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "${widget.documentSnapshot['fastname']} ${widget.documentSnapshot['lastname']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.0,
                          ),
                          Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: chatfunction.getmessage(
                                      Useremail.useremailget,
                                      widget.documentSnapshot['email']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            color: Colors.green,
                                            margin: EdgeInsets.all(10),
                                            child: Text(snapshot
                                                .data!.docs[index]['message']),
                                          );
                                        },
                                      );
                                    } else {
                                      return Container(
                                        child:
                                            Center(child: Text("no message")),
                                      );
                                    }
                                  }),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Divider(
                                  height: 0.0,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.camera)),
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  setState(() {
                                                    sendbutton = true;
                                                    messagetext = value;
                                                  });
                                                } else {
                                                  setState(() {
                                                    sendbutton = false;
                                                  });
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 3,
                                              minLines: 1,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[300],
                                                filled: true,
                                                hintText: "Write something....",
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                  top: 5.0,
                                                  left: 10.0,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFE0E0E0)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFE0E0E0)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        sendbutton
                                            ? IconButton(
                                                onPressed: () {
                                                  chatfunction.sendmessage(
                                                      Useremail.useremailget,
                                                      widget.documentSnapshot[
                                                          'email'],
                                                      messagetext!);
                                                },
                                                icon: Icon(Icons.send))
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
