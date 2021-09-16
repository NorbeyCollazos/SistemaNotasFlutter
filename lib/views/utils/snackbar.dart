import 'package:flutter/material.dart';

class Snackbar {
  static void showSnackbar(BuildContext context, GlobalKey<ScaffoldState> key,
      String text, Color color) {
    if (context == null) return;
    if (key == null) return;
    if (key.currentState == null) return;
    if (color == null) color = Colors.amber;

    FocusScope.of(context).requestFocus(new FocusNode());

    key.currentState?.removeCurrentSnackBar();
    key.currentState.showSnackBar(new SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}
