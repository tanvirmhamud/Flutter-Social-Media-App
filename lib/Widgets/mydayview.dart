import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MydayView extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const MydayView({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  _MydayViewState createState() => _MydayViewState();
}

class _MydayViewState extends State<MydayView> {
  int pagenum = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              pagenum = value;
            });
          },
          children: [
            for (var i = 0; i < widget.documentSnapshot['myday'].length; i++)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.documentSnapshot['myday'][i],
                  fit: BoxFit.cover,
                ),
              )
          ],
        ),
        Positioned(
          top: 50.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.documentSnapshot['myday'].length; i++)
                Flexible(
                  child: AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 3.0),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: pagenum == i ? Colors.white : Colors.grey,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                )
            ],
          ),
        ),
        Positioned(
          top: 55.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 23,
                      backgroundImage:
                          NetworkImage(widget.documentSnapshot['profilepic']),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "${widget.documentSnapshot['fastname']} ${widget.documentSnapshot['lastname']}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
