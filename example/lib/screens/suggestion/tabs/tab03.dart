import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart';

class Tab03 extends StatefulWidget {
  const Tab03({
    Key? key,
    required this.suggestion,
    required this.readOnly,
  }) : super(key: key);
  final Suggestion suggestion;
  final bool readOnly;

  @override
  State<Tab03> createState() => _Tab03State();
}

class _Tab03State extends State<Tab03> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "tab3 value",
            ),
            readOnly: widget.readOnly,
            initialValue: widget.suggestion.fieldTab3 ?? '',
            validator: (value) {
              if (!Validator().validString(value)) {
                return 'Enter a valid value';
              }
              widget.suggestion.fieldTab3 = value;
              return null;
            },
          ),
          const Divider(),
          const Text("From your user doc"),
          SizedBox(
            child: ReadFromFireStoreByDocumentId<AppUser>(
              collection: "users",
              documentId: Fframe.of(context)!.user!.uid!,
              fromFirestore: AppUser.fromFirestore,
              toFirestore: (user, options) => user.toFirestore(),
              builder: (BuildContext context, FirestoreDocument<AppUser> appUserDocument) {
                return Text(appUserDocument.data!.displayName ?? "?");
              },
            ),
          ),
        ],
      ),
    );
  }
}
