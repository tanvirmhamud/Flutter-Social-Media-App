import 'package:flutter/material.dart';

class ProfileTextFieldPage extends StatefulWidget {
  final String cardname;
  final String name;
  final String hinttext;
  final FormFieldValidator<String> validation;
  final FormFieldSetter onchange;
  final FormFieldSetter onsave;
  const ProfileTextFieldPage(
      {Key? key,
      required this.cardname,
      required this.name,
      required this.onchange,
      required this.validation,
      required this.onsave, required this.hinttext})
      : super(key: key);

  @override
  _ProfileTextFieldPageState createState() => _ProfileTextFieldPageState();
}

class _ProfileTextFieldPageState extends State<ProfileTextFieldPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(widget.cardname),
            ),
          ),
          Expanded(
            child: TextFormField(
              validator: widget.validation,
              onChanged: widget.onchange,
              onSaved: widget.onsave,
              initialValue: widget.name,
              decoration: InputDecoration(border: OutlineInputBorder(),hintText: widget.hinttext),
            ),
          ),
        ],
      ),
    );
  }
}
