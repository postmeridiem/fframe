import 'package:flutter/material.dart';

class ThemeDropdown extends StatefulWidget {
  // ignore: use_super_parameters
  const ThemeDropdown({Key? key}) : super(key: key);

  @override
  State<ThemeDropdown> createState() => _ThemeDropdownState();
}

class _ThemeDropdownState extends State<ThemeDropdown> {
  String dropdownValue = 'Theme: auto';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Theme: auto', 'Theme: light', 'Theme: dark'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class LocaleDropdown extends StatefulWidget {
  // ignore: use_super_parameters
  const LocaleDropdown({Key? key}) : super(key: key);

  @override
  State<LocaleDropdown> createState() => _LocaleDropdownState();
}

class _LocaleDropdownState extends State<LocaleDropdown> {
  String dropdownValue = 'Locale: en-US';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Locale: en-US', 'Locale: nl-NL'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
