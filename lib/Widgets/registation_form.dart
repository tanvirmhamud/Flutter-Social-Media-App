import 'package:flutter/material.dart';

class RegistationForm extends StatefulWidget {
  final String hinttext;
  final FormFieldValidator<String> validation;
  final FormFieldSetter<String> savevalue;


  const RegistationForm(
      {Key? key, required this.hinttext, required this.validation, required this.savevalue})
      : super(key: key);

  @override
  _RegistationFormState createState() => _RegistationFormState();
}

class _RegistationFormState extends State<RegistationForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: 300.0,
      child: TextFormField(
          validator: widget.validation,
          onSaved: widget.savevalue,
          
          decoration: InputDecoration(
            hintText: widget.hinttext,
            border: InputBorder.none,
            focusColor: Colors.blueAccent,
            filled: true,
            fillColor: Colors.grey[300],
            contentPadding: const EdgeInsets.only(
                left: 14.0, bottom: 8.0, top: 8.0, right: 14.0),
            focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white),
              borderRadius: new BorderRadius.circular(4.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.white),
              borderRadius: new BorderRadius.circular(4.0),
            ),
          )),
    );
  }
}
