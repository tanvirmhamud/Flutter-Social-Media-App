import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/userchatpage.dart';
import 'package:flutter_social_media/Widgets/userchatpage.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final chatfunction = Provider.of<Userchatpageprovider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Chat"),
      ),
      body: Container(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: chatfunction.allchatuser(Useremail.useremailget),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Userchatpage(documentSnapshot: data),
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundImage:
                                    NetworkImage(data['profilepic']),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text(
                                      "${data['fastname']} ${data['lastname']}",
                                      style: TextStyle(
                                          fontSize: 17, letterSpacing: 0.3),
                                    )
                                  ],
                                ),
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
              }),
        ),
      ),
    );
  }
}
