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
  final textcontrollar = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool sendbutton = false;
  String? messagetext;
  var listmessage;
  var listmessagelenght;

  bool? islastmessageleft(int index) {
    if (index > 0 &&
            listmessage != "" &&
            listmessage[index - 1]['messagefrom'] == Useremail.useremailget ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool? islastmessageright(int index) {
    if (index > 0 &&
            listmessage != "" &&
            listmessage[index - 1]['messagefrom'] != Useremail.useremailget ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool? isfastmessageright(int index) {
    if (index == listmessagelenght - 1 ||
        listmessage != "" &&
            listmessage[index + 1]['messagefrom'] != Useremail.useremailget) {
      return true;
    } else {
      return false;
    }
  }

  bool? isfastmessageleft(int index) {
    if (index == listmessagelenght - 1 ||
        listmessage[index + 1]["messagefrom"] == Useremail.useremailget) {
      return true;
    } else {
      return false;
    }
  }

  bool? singlefastmessageright(int index) {
    if (islastmessageright(index) == true && index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool? singlefastmessageleft(int index) {
    if (islastmessageleft(index) == true && index == 0) {
      return true;
    } else {
      return false;
    }
  }

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
                          Column(
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
                                        backgroundImage: NetworkImage(widget
                                            .documentSnapshot['profilepic']),
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
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: chatfunction.getmessage(
                                      Useremail.useremailget,
                                      widget.documentSnapshot['email']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      listmessage = snapshot.data!.docs;
                                      listmessagelenght =
                                          snapshot.data!.docs.length;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        reverse: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var message =
                                              snapshot.data!.docs[index];

                                          return textmessagestyle(
                                              message, index);
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
                                              controller: textcontrollar,
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
                                                    messagetext!,
                                                  );

                                                  textcontrollar.clear();

                                                  _scrollController.animateTo(
                                                    0.0,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeOut,
                                                  );
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

  Widget textmessagestyle(QueryDocumentSnapshot message, int index) {
    return Container(
      child: Column(
        children: [
          message['messagefrom'] == Useremail.useremailget
              ? Container(
                  margin: EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 300.0),
                        margin: EdgeInsets.only(
                          bottom: islastmessageright(index) == true ? 5 : 3,
                        ),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: singlefastmessageright(index) == true
                                ? isfastmessageright(index) == true
                                    ? Radius.circular(15.0)
                                    : Radius.circular(3.0)
                                : isfastmessageright(index) == true
                                    ? Radius.circular(15.0)
                                    : Radius.circular(3.0),
                            bottomRight: islastmessageright(index) == true
                                ? Radius.circular(15.0)
                                : isfastmessageright(index) == true
                                    ? Radius.circular(3.0)
                                    : Radius.circular(3.0),
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          ),
                          color: Colors.indigoAccent,
                        ),
                        child: Text(
                          message['message'],
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    left: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      islastmessageleft(index) == true
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  widget.documentSnapshot['profilepic']),
                              maxRadius: 15,
                            )
                          : Container(
                              margin: EdgeInsets.only(left: 30.0),
                              child: null,
                            ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 300.0),
                        margin: EdgeInsets.only(
                          bottom: islastmessageleft(index) == true ? 10 : 3,
                        ),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: singlefastmessageleft(index) == true
                                ? islastmessageleft(index) == true
                                    ? Radius.circular(3.0)
                                    : Radius.circular(15.0)
                                : isfastmessageleft(index) == true
                                    ? Radius.circular(15.0)
                                    : Radius.circular(3.0),
                            bottomLeft: islastmessageleft(index) == true
                                ? Radius.circular(15.0)
                                : isfastmessageleft(index) == true
                                    ? Radius.circular(3.0)
                                    : Radius.circular(3.0),
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: Text(message['message']),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
