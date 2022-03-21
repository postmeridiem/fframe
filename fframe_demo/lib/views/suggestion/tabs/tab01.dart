import 'package:flutter/material.dart';
import 'package:fframe/helpers/validator.dart';
import 'package:fframe_demo/models/suggestion.dart';

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
        Text("Author: ${suggestion.createdBy ?? "unknown"}"),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  controller: TextEditingController.fromValue(TextEditingValue(text: suggestion.name!)),
                  validator: (curValue) {
                    if (validator.validString(curValue)) {
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
                    // TODO @AZ: can this be moved into a validator class function entirely to avoid repeating patterns?
                    if (validator.validIcon(curValue)) {
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