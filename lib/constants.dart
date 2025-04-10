import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(
      color: Colors.black54, fontSize: 13.0, fontWeight: FontWeight.normal),
  fillColor: Color(0xFFE0F7FA),
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);

const kOPTFieldDecoration = InputDecoration(
  hintText: '_',
  hintStyle: TextStyle(
    fontSize: 30.0,
    color: Colors.grey,
  ),
  fillColor: Color(0xFFE0F7FA),
  counterText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
