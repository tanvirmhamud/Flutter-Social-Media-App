
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';

class Editpost extends StatefulWidget {
  final QueryDocumentSnapshot documents;
  const Editpost({Key? key, required this.documents}) : super(key: key);

  @override
  _EditpostState createState() => _EditpostState();
}

class _EditpostState extends State<Editpost> {
  List<String>? savetext;
// TextEditingController textEditingController =
//         TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firebasedatas = Provider.of<FirebasedataProvider>(context);
    String oldtext = widget.documents['post'].join("\n");
    return Container(
      height: MediaQuery.of(context).size.height - 32.0,
      child: Scaffold(
        floatingActionButton: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            child: IconButton(
              onPressed: () {
                firebasedatas.editpostimageupload(
                    Useremail.useremailget, widget.documents.id);
              },
              icon: Icon(Icons.add_a_photo),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            "Edit Post",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: ElevatedButton(
                  onPressed: savetext == null
                      ? null
                      : savetext!.isEmpty
                          ? null
                          : () {
                              firebasedatas.updatepost(Useremail.useremailget,
                                  widget.documents.id, savetext!);
                              Navigator.pop(context);
                            },
                  child: Text("Update Post")),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 10.0,
                  top: 10.0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.documents['profilepic']),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.documents['fastname']} ${widget.documents['lastname']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "@${widget.documents['username']}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: formkey,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 10.0,
                    right: 10.0,
                    left: 10.0,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: oldtext,
                        onSaved: (newValue) {},
                        onChanged: (value) {
                          setState(() {
                            savetext = value.split("\n");
                            print(savetext);
                          });
                        },
                        style: TextStyle(fontSize: 20.0),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 20.0),
                          hintText: "Whats on Your mind?",
                          border: InputBorder.none,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firebasedatas.db
                              .collection('users')
                              .doc(Useremail.useremailget)
                              .collection('post')
                              .doc(widget.documents.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 200.0,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!['image'].length,
                                  itemBuilder: (context, index) {
                                    int imagelength =
                                        snapshot.data!['image'].length;
                                    return Container(
                                      margin: EdgeInsets.all(10.0),
                                      height: 100.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Stack(
                                        children: [
                                          Material(
                                            elevation: 5,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              height: 180.0,
                                              width: 120.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(snapshot
                                                    .data!['image'][index]),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    firebasedatas
                                                        .removefireaseimage(
                                                            Useremail
                                                                .useremailget,
                                                            widget.documents.id,
                                                            snapshot
                                                                .data!['image']
                                                                    [index]
                                                                .toString(),
                                                            imagelength);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 15.0,
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
