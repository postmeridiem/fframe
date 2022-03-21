import 'package:flutter/material.dart';
import 'package:fframe/helpers/validator.dart';

import 'package:fframe_demo/models/suggestion.dart';
import 'package:fframe_demo/services/suggestion_service.dart';

class Tab01 extends StatelessWidget {
  const Tab01({Key? key, required this.suggestion}) : super(key: key);
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    // register shared validator class for common patterns
    var validator = Validator();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Author",
                  ),
                  controller: TextEditingController.fromValue(TextEditingValue(text: (suggestion.createdBy ?? "unknown"))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    // hoverColor: Color(0xFFFF00C8),
                    // hoverColor: Theme.of(context).indicatorColor,
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  controller: TextEditingController.fromValue(TextEditingValue(text: suggestion.name!)),
                  validator: (curValue) {
                    // TODO @AZ: should this be moved into a validator class function entirely to avoid repeating patterns?
                    if (validator.validString(curValue)) {
                      suggestion.name = curValue;
                      return null;
                    } else {
                      return 'Enter a valid name';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Icon",
                  ),
                  controller: TextEditingController.fromValue(TextEditingValue(text: suggestion.icon!)),
                  validator: (curValue) {
                    if (validator.validIcon(curValue)) {
                      // apply value to the model
                      suggestion.icon = curValue;
                      return null;
                    } else {
                      return 'Enter a valid icon string';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phone'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Map'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.photo_album),
              //   title: Text('Album'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.phone),
              //   title: Text('Phonelast'),
              // ),