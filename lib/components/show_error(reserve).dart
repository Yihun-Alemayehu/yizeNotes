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

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are You Sure ?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No')),
        ],
      );
    },
  ).then((value) => value ?? false);
}