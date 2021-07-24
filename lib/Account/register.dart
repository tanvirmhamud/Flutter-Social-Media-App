

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Account/login.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/account.dart';
import 'package:flutter_social_media/Widgets/registation_form.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  PageController? _controller;
  int pagechange = 0;
  bool previewbutton = false;
  bool useradddata = false;
  bool submitbutton = false;
  bool validationchack = false;
  bool submitdata = false;
  String? valuesave;
  String? fastname, lastname, username, email, password;
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  


  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    final providerdata = Provider.of<Accountprovider>(context);
    from_validation_chack() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();

      submitdata
          ? providerdata.accountcreated(context, fastname!, lastname, username, email, password)
          : print("submit data false");

      setState(() {
        validationchack = true;
      });
      print("$fastname , $lastname, $username, $email, $password");
    } else {
      setState(() {
        validationchack = false;
        print("validation chack false");
      });
    }
  }

    return Scaffold(
      key: scaffoldkey,
      body: StreamBuilder<QuerySnapshot>(
          stream: firebasedata.db.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Form(
                      key: formkey,
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(10.0),
                        duration: Duration(seconds: 2),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Registation",
                                  style: TextStyle(
                                    fontFamily: 'Dancing Script',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 180.0,
                                  width: 300.0,
                                  child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: _controller,
                                    children: [
                                      Column(
                                        children: [
                                          RegistationForm(
                                            hinttext: "Fast Name",
                                            validation: (value) =>
                                                value!.isEmpty
                                                    ? "Enter Fastname"
                                                    : null,
                                            savevalue: (newValue) {
                                              setState(() {
                                                fastname = newValue!;
                                              });
                                            },
                                          ),
                                          RegistationForm(
                                            hinttext: "Last Name",
                                            validation: (value) =>
                                                value!.isEmpty
                                                    ? "Enter Lastname"
                                                    : null,
                                            savevalue: (newValue) {
                                              setState(() {
                                                lastname = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          RegistationForm(
                                            hinttext: "User Name",
                                            validation: (value) {
                                              if (snapshot.data!.docs.any(
                                                  (element) =>
                                                      element['username'] ==
                                                      value)) {
                                                return "User Name Allready used. Try Another One";
                                              } else if (value!.isEmpty) {
                                                return "Enter Your Email";
                                              }
                                            },
                                            savevalue: (newValue) {
                                              setState(() {
                                                username = newValue!;
                                              });
                                            },
                                          ),
                                          RegistationForm(
                                            hinttext: "Email",
                                            validation: (value) {
                                              if (snapshot.data!.docs.any(
                                                  (element) =>
                                                      element['email'] ==
                                                      value)) {
                                                return "Email is already use";
                                              } else if (value!.isEmpty) {
                                                return "Enter Your Email";
                                              }
                                            },
                                            savevalue: (newValue) {
                                              setState(() {
                                                email = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          RegistationForm(
                                            hinttext: "Password",
                                            validation: (value) =>
                                                value!.isEmpty
                                                    ? "Enter Your Password"
                                                    : null,
                                            savevalue: (newValue) {
                                              setState(() {
                                                password = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(
                                width: 250.0,
                                margin: EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    previewbutton
                                        ? Container(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                
                                                if (pagechange > 0) {
                                                  setState(() {
                                                    pagechange--;
                                                    submitbutton = false;
                                                    _controller!.animateToPage(
                                                        pagechange,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        curve: Curves
                                                            .easeInOutCubic);
                                                  });
                                                }
                                                if (pagechange < 1) {
                                                  setState(() {
                                                    previewbutton = false;
                                                  });
                                                }
                                              },
                                              child: Text("Preview"),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    submitbutton
                                        ? Container(
                                            child: providerdata.isloading == false
                                                ? providerdata.loginbuttonshow == false
                                                    ? ElevatedButton(
                                                        onPressed: () {
                                                          from_validation_chack();

                                                          if (pagechange < 2) {
                                                            setState(() {
                                                              pagechange++;
                                                              previewbutton =
                                                                  true;
                                                              submitdata = true;
                                                            });
                                                            from_validation_chack();
                                                          }
                                                         
                                                        },
                                                        child: Text("Submit"),
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginPage(),
                                                              ));
                                                        },
                                                        child:
                                                            Text("login Now"))
                                                : Container(
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ))
                                        : Container(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  from_validation_chack();
                                                  if (validationchack == true) {
                                                    if (pagechange < 2) {
                                                      setState(() {
                                                        pagechange++;
                                                        previewbutton = true;
                                                        _controller!.animateToPage(
                                                            pagechange,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            curve: Curves
                                                                .easeInOutCubic);
                                                      });
                                                    }
                                                    if (pagechange == 2) {
                                                      setState(() {
                                                        submitbutton = true;
                                                        submitdata = true;
                                                      });
                                                    }
                                                  } else {
                                                    print(
                                                        "validation chack false");
                                                  }
                                                },
                                                child: Text("Next"))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              );
          }),
    );
  }
}
