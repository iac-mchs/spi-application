import 'package:flutter/material.dart';

class TabButtonWidget extends StatelessWidget {
  final int pageIndex;
  final String buttonText;
  final bool isActive;
  final PageController pageController;

  TabButtonWidget(
      this.pageIndex, this.buttonText, this.pageController, { this.isActive = false });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (event) {
        pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3), topRight: Radius.circular(3)),
        ),
        splashColor: Colors.white10,
        color: isActive ? Colors.white : Colors.transparent,
        padding: EdgeInsets.all(19),
        onPressed: () {},
        child: Text(
          buttonText.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: isActive ? Colors.black : Color(0xFF83C3EC),
            letterSpacing: 0.01,
          ),
        ),
      ),
    );
  }
}
