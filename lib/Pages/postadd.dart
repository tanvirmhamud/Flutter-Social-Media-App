import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/imageupload.dart';
import 'package:flutter_social_media/Provider/otherfunction.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:flutter_social_media/homepage.dart';
import 'package:provider/provider.dart';

class PostAddPage extends StatefulWidget {
  const PostAddPage({Key? key}) : super(key: key);

  @override
  _PostAddPageState createState() => _PostAddPageState();
}

class _PostAddPageState extends State<PostAddPage> {
  List<String>? savetext;
  List<String>? savetext2;

  final formkey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textfield = Provider.of<OthderFunctionprovider>(context);
    final firebasedatas = Provider.of<FirebasedataProvider>(context);
    String? fastname, lastname, username, profilepic;
    bool imageupload = false;

   firebasedatas.postaddimageFileList != null ? imageupload = true : imageupload = false;

    return Scaffold(
      floatingActionButton: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          child: IconButton(
            onPressed: () {
              firebasedatas.postimageupload();
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
          "Create Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: ElevatedButton(
                onPressed: textfield.text == null
                    ? null
                    : textfield.text!.isEmpty
                        ? null
                        : () {
                            formkey.currentState!.save();

                            firebasedatas.firebasecreatedpostandimage(
                                Useremail.useremailget, savetext!, context, fastname!, lastname ,username, profilepic, imageupload);
                            print("$savetext");
                            textEditingController.clear();
                          },
                child: Text("Post")),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: firebasedatas.postaddpagefirebase(Useremail.useremailget),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var documents = snapshot.data;
              fastname = documents!['fastname'];
              lastname = documents['lastname'];
              username = documents['username'];

              return Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.0,
                        top: 10.0,
                      ),
                      child: Row(
                        children: [
                          documents['profilepic']
                              ? StreamBuilder<QuerySnapshot>(
                                  stream:
                                      firebasedatas.avaterpostaddpagefirebase(
                                          Useremail.useremailget),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String profileurl = snapshot.data!.docs.map((e) => e['profile-imageurl']).first;
                                      profilepic = profileurl;
                                      return CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profileurl),
                                      );
                                    } else {
                                      return CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/profilepic.jpg'),
                                      );
                                    }
                                  })
                              : CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/profilepic.jpg'),
                                ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${documents['fastname']} ${documents['lastname']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "@${documents['username']}",
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
                              controller: textEditingController,
                              onSaved: (newValue) {},
                              onChanged: (value) {
                                setState(() {
                                  textfield.settext(value);
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
                            if (firebasedatas.postaddimageFileList != null)
                              Container(
                                height: 200.0,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: firebasedatas
                                      .postaddimageFileList!.length,
                                  itemBuilder: (context, index) {
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
                                                child: Image.file(
                                                  File(firebasedatas
                                                      .postaddimageFileList![
                                                          index]
                                                      .path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    firebasedatas
                                                        .postaddimageFileList!
                                                        .removeAt(index);
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
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
