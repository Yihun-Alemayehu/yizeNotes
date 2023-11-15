import 'package:Yize_Notes/components/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: ()=>{
      'Ok': null,
    },
  );
}
