import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController _controller;
  final String _hintText;
  final FocusNode _focusNode;
  late TextInputType _type;
  late bool isPassword;

  InputField(this._controller, this._hintText, this._focusNode,
      {bool isPassword = false, TextInputType type = TextInputType.text}) {
    this.isPassword = isPassword;
    _type = type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
      child: TextFormField(
        keyboardType: _type,
        controller: _controller,
        focusNode: _focusNode,
        obscureText: isPassword,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.4), width: 3.0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.4), width: 3.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.8), width: 3.0)),
          fillColor: Color.fromRGBO(255, 255, 255, 0.4),
          filled: true,
          labelText: _hintText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
