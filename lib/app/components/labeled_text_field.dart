import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String? text;
  final Color? textColor;
  final Color? labelColor;

  LabeledTextField(this.label, {this.text, this.textColor, this.labelColor});

  @override
  Widget build(BuildContext context) {
    dynamic fieldText = text == null || text!.length <= 0 || text == 'null' ? '-' : text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14.0,
                color: labelColor ?? Color(0xFFC0D2E0),
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.only(top: 4.0)),
        Text(fieldText,
            style: TextStyle(
                fontSize: 14.0,
                color: textColor ?? Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.only(bottom: 8.0)),
      ],
    );
  }
}