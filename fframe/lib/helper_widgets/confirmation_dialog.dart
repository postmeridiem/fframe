import 'package:flutter/material.dart';

Future<bool> confirmationDialog({
  required BuildContext context,
  required String cancelText,
  required String continueText,
  required String titleText,
  required Widget child,
}) async {
  // set up the buttons

  bool returnValue = false;
  Widget cancelButton = TextButton(
    child: Text(cancelText),
    onPressed: () {
      returnValue = false;
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(continueText),
    onPressed: () {
      returnValue = true;
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      AlertDialog alertDialog = AlertDialog(
        title: Text(titleText),
        content: child,
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      return alertDialog;
    },
  );

  return returnValue;
}
