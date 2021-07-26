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
      backgroundColor: Colors.grey,
      body: StreamBuilder<DocumentSnapshot>(
          stream: chatfunction.db
              .collection("users")
              .doc(Useremail.useremailget)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 90.0,
                      color: Colors.indigoAccent,
                      child: Container(
                        margin: EdgeInsets.only(top: 30.0, left: 0.0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
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
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: null,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10.0),
                                height: 100.0,
                                color: Colors.green,
                              );
                            },
                          );
                        }
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
                                        keyboardType: TextInputType.multiline,
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
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFE0E0E0)),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFE0E0E0)),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                                widget
                                                    .documentSnapshot['email'],
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
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
