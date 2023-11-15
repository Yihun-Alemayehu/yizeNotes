import 'package:Yize_Notes/components/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are your sure ?',
    optionsBuilder: ()=>{
      'Yes': true,
      'Cancel': false
    },
  ).then((value) => value ?? false);
}
