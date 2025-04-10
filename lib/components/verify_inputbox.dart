import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newone/constants.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int index;
  final int totalBoxes;

  const OtpBox(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.index,
      required this.totalBoxes});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          SizedBox(
            width: 50.0,
            height: 60.0,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty) {
                  FocusScope.of(context).previousFocus();
                }
                //Do something with the user input.
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              showCursor: false,
              cursorHeight: 25.0,
              style: TextStyle(
                fontSize: 30.0,
              ),
              decoration: kOPTFieldDecoration,
            ),
          ),
        ],
      ),
    );
  }
}
