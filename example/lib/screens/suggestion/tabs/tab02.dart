import 'package:fframe/fframe.dart';
import 'package:example/models/suggestion.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart';

class Tab02 extends StatelessWidget {
  Tab02({
    Key? key,
    required this.suggestion,
    required this.readOnly,
  }) : super(key: key);
  final Suggestion suggestion;
  final bool readOnly;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "tab2 value",
              ),
              readOnly: readOnly,
              initialValue: suggestion.fieldTab2 ?? '',
              validator: (value) {
                if (!Validator().validString(value)) {
                  return 'Enter a valid value';
                }
                suggestion.fieldTab2 = value;
                return null;
              },
            ),
          ),
          const Divider(),
          const Text("List of users:"),
          SizedBox(
            child: QueryFromFireStore<AppUser>(
              collection: "users",
              fromFirestore: AppUser.fromFirestore,
              toFirestore: (user, options) => user.toFirestore(),
              builder: (BuildContext context, List<AppUser> appUsers) {
                return Column(
                    children: appUsers
                        .map(
                          (AppUser appUser) => Text(appUser.displayName ?? "?"),
                        )
                        .toList());
              },
            ),
          ),
        ],
      ),
    );
  }
}
// 