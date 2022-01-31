import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {int seconds = 1}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      width: text.length * 10,
      duration: Duration(seconds: seconds),
      content: Text(text)));
}
