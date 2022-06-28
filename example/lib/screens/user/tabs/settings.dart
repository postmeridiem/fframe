import 'package:flutter/material.dart';
import 'package:example/models/appuser.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Theme Selection:",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
              ),
            ),
            Expanded(
              child: ThemeToggle(),
            ),
          ],
        ),
      ),
    ]);
  }
}

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  @override
  Widget build(BuildContext context) {
    List<bool> isSelected = [true, false, false];
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
          //wut
        });
      },
      isSelected: isSelected,
      children: <Widget>[
        SizedBox(
          width: 200,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.radio_button_checked),
              ),
              Text("auto"),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.radio_button_unchecked),
              ),
              Text("light"),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.radio_button_unchecked),
              ),
              Text("dark"),
            ],
          ),
        ),
      ],
    );
  }
}
