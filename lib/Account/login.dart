import 'package:flutter/material.dart';
import 'package:flutter_social_media/Account/register.dart';
import 'package:flutter_social_media/Provider/account.dart';
import 'package:flutter_social_media/Widgets/registation_form.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    final providerdata = Provider.of<Accountprovider>(context);
    return Scaffold(
      body: Container(
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
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Dancing Script',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        margin: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                      ),
                      RegistationForm(
                        hinttext: "Email",
                        validation: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Email";
                          } else if (!value.contains("@")) {
                            return "Enter Valid Email";
                          }
                        },
                        savevalue: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                      RegistationForm(
                        hinttext: "Password",
                        validation: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Password";
                          } else if (value.length < 6) {
                            return "Enter Your 6 Character Password";
                          }
                        },
                        savevalue: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final form = formkey.currentState;
                            if (form!.validate()) {
                              form.save();
                              providerdata.accountsignin(
                                  _email!, _password, context);
                            }
                          },
                          child: Text("Login")),
                    ],
                  ),
                ),
              ),
            )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ));
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("Don't Have Any Account?"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            child: Text("Registation"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
