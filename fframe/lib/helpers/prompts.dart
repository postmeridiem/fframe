import 'package:flutter/material.dart';

Future<bool> promptOK({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  bool selection = true;
  selection = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(
          top: 12.0,
          bottom: 8.0,
          right: 14.0,
          left: 14.0,
        ),
        contentPadding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 24.0,
          left: 24.0,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          right: 24.0,
          left: 24.0,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  minHeight: 150,
                  maxWidth: 250,
                ),
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Click OK to continue.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  ) as bool;
  return selection;
}

Future<bool> promptOKCancel({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  bool selection = true;
  selection = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(
          top: 12.0,
          bottom: 8.0,
          right: 14.0,
          left: 14.0,
        ),
        contentPadding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 24.0,
          left: 24.0,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          right: 24.0,
          left: 24.0,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  minHeight: 150,
                  maxWidth: 250,
                ),
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Do you want to continue?',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  ) as bool;
  return selection;
}
