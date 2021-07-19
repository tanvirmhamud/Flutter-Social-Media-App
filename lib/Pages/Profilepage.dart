import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Model/firebasedata.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/imageupload.dart';
import 'package:flutter_social_media/Widgets/profile_textfield.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ImageUploadProvider>(context);
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    String? fastname, lastname, username, countryname, phone, address;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: firebasedata.db
                .collection('users')
                .doc(Useremail.useremailget)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                var documents = snapshot.data;
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: documents!['profilepic'] == true
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream:
                                            firebasedata.streamDataCollection(
                                                Useremail.useremailget,
                                                'profilepic'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String profileimage = snapshot
                                                .data!.docs
                                                .map((e) =>
                                                    e['profile-imageurl'])
                                                .first;
                                            return Stack(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        maxRadius: 70.0,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                profileimage),
                                                      ),
                                                      Positioned(
                                                        top: 90,
                                                        bottom: 10,
                                                        left: 100,
                                                        right: 0,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30.0,
                                                          width: 30.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                          child: IconButton(
                                                              onPressed: () {
                                                                data.uploadimagefirebase(
                                                                    Useremail
                                                                        .useremailget);
                                                                setState(() {});
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        })
                                    : Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 70.0,
                                                  backgroundImage: AssetImage(
                                                      'images/profilepic.jpg'),
                                                ),
                                                Positioned(
                                                  top: 90,
                                                  bottom: 10,
                                                  left: 100,
                                                  right: 0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 30.0,
                                                    width: 30.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          data.uploadimagefirebase(
                                                              Useremail
                                                                  .useremailget);
                                                          setState(() {});
                                                        },
                                                        icon: Icon(Icons.edit)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                            Container(
                              child: Text(
                                "${documents['fastname']} ${documents['lastname']}",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              ProfileTextFieldPage(
                                hinttext: "Your fastname",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    fastname = newvalue;
                                  });
                                },
                                cardname: "Fastname:",
                                name: documents['fastname'],
                                onchange: (newvalue) {
                                  setState(() {
                                    fastname = newvalue;
                                  });
                                },
                              ),
                              ProfileTextFieldPage(
                                hinttext: "Your lastname",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    lastname = newvalue;
                                  });
                                },
                                cardname: "Lastname:",
                                name: documents['lastname'],
                                onchange: (newvalue) {
                                  setState(() {
                                    lastname = newvalue;
                                  });
                                },
                              ),
                              ProfileTextFieldPage(
                                hinttext: "Your username",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    username = newvalue;
                                  });
                                },
                                cardname: "Username:",
                                name: documents['username'],
                                onchange: (newvalue) {
                                  setState(() {
                                    username = newvalue;
                                  });
                                },
                              ),
                              ProfileTextFieldPage(
                                hinttext: "your Country Name",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    countryname = newvalue;
                                  });
                                },
                                cardname: "country:",
                                name: documents['country'],
                                onchange: (newvalue) {
                                  setState(() {
                                    countryname = newvalue;
                                  });
                                },
                              ),
                              ProfileTextFieldPage(
                                hinttext: "Your Phone Number",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    phone = newvalue;
                                  });
                                },
                                cardname: "Phone:",
                                name: documents['phone'],
                                onchange: (newvalue) {
                                  setState(() {
                                    phone = newvalue;
                                  });
                                },
                              ),
                              ProfileTextFieldPage(
                                hinttext: "your Address",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "This TextField Is Empty";
                                  }
                                },
                                onsave: (newvalue) {
                                  setState(() {
                                    address = newvalue;
                                  });
                                },
                                cardname: "Address",
                                name: documents['address'],
                                onchange: (newvalue) {
                                  setState(() {
                                    address = newvalue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  final form = formkey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    firebasedata.updatedata(
                                        fastname!,
                                        lastname,
                                        username,
                                        Useremail.useremailget,
                                        countryname,
                                        phone,
                                        address,
                                        context);
                                  }
                                },
                                child: Text("Save")),
                          ),
                        ],
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
      ),
    );
  }
}
