import 'package:flutter/material.dart';

class ButomnavigationBarpage extends StatefulWidget {
  final Function onpressed;
  final int selectedtab;
  const ButomnavigationBarpage({Key? key, required this.onpressed, required this.selectedtab})
      : super(key: key);

  @override
  _ButomnavigationBarpageState createState() => _ButomnavigationBarpageState();
}

class _ButomnavigationBarpageState extends State<ButomnavigationBarpage> {
  int isselectedtab = 0;
  @override
  Widget build(BuildContext context) {
    isselectedtab = widget.selectedtab;
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isselectedtab = 0;
                  widget.onpressed(0);
                });
              },
              icon: Icon(
                Icons.home,
                size: isselectedtab == 0 ? 30.0 : 24.0,
                color: isselectedtab == 0 ? Colors.indigo : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isselectedtab = 1;
                  widget.onpressed(1);
                });
              },
              icon: Icon(
                Icons.chat,
                size: isselectedtab == 1 ? 30.0 : 24.0,
                color: isselectedtab == 1 ? Colors.indigo : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isselectedtab = 2;
                  widget.onpressed(2);
                });
              },
              icon: Icon(
                Icons.add,
                size: isselectedtab == 2 ? 30.0 : 24.0,
                color: isselectedtab == 2 ? Colors.indigo : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isselectedtab = 3;
                  widget.onpressed(3);
                });
              },
              icon: Icon(
                Icons.notifications,
                size: isselectedtab == 3 ? 30.0 : 24.0,
                color: isselectedtab == 3 ? Colors.indigo : Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isselectedtab = 4;
                  widget.onpressed(4);
                });
              },
              icon: Icon(
                Icons.logout,
                size: isselectedtab == 4 ? 30.0 : 24.0,
                color: isselectedtab == 4 ? Colors.indigo : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
