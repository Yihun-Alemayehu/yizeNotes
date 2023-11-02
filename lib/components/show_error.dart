import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,String title,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(title),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'))
        ],
      );
    },
  );
}
