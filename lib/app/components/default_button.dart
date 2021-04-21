import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  Color? hoveredColor;
  Color? pressedColor;
  Color? focusedColor;
  Color? disabledColor;
  Color defaultColor;
  bool isDisabled;

  DefaultButton(this.text,
      {this.hoveredColor,
      this.focusedColor,
      this.pressedColor,
      this.defaultColor = const Color(0xFF01437b),
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return defaultColor;
    }

    double getElevation(Set<MaterialState> states) {
      return 2.0;
    }

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 45.0),
      child: ElevatedButton(
        onPressed: isDisabled ? null : () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(getColor),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)),
          elevation: MaterialStateProperty.resolveWith(getElevation),
        ),
        child: new Text(
          text,
          style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
