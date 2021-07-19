import 'package:flutter/material.dart';

class AppbarPage extends StatefulWidget {
  final String appbarname;
  const AppbarPage({Key? key, required this.appbarname}) : super(key: key);

  @override
  _AppbarPageState createState() => _AppbarPageState();
}

class _AppbarPageState extends State<AppbarPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Container(
        height: 60.0,
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                widget.appbarname,
                style: TextStyle(fontSize: 20.0),
              ),
              Spacer(),
              Card(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
