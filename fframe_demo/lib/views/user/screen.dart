import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe_demo/models/user.dart';
import 'package:fframe_demo/views/user/user.dart';
import 'package:fframe_demo/views/user/tabs/tabs.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ErrorScreen(error: Exception("Not implemented"));
    return DocumentScreen<User>(
      collection: "users",
      fromFirestore: User.fromFirestore,
      toFirestore: (user, options) => user.toFirestore(),
      createNew: () => User(),
      // createDocumentId: (User user) => {},
      //Optional title widget
      titleBuilder: (context, data) {
        return Text(data.displayName ?? "New User");
      },
      document: _document(),
      documentList: DocumentList(
        builder: (context, selected, data) {
          return UserListItem(
            user: data,
            selected: selected,
          );
        },
      ),
    );
  }

  Document<User> _document() {
    return Document<User>(
      autoSave: false,
      tabs: [
        DocumentTab<User>(
          tabBuilder: () {
            return const Tab(
              text: "Profile",
              icon: Icon(
                Icons.person,
              ),
            );
          },
          childBuilder: (user) {
            return ProfileTab(
              user: user,
            );
          },
        ),
        DocumentTab<User>(
          tabBuilder: () {
            return const Tab(
              text: "Roles",
              icon: Icon(
                Icons.lock_open,
              ),
            );
          },
          childBuilder: (user) {
            return RolesTab(
              user: user,
            );
          },
        ),
      ],
      // contextCards: [
      //   // (user) => ContextCard(
      //   //       user: user,
      //   //     ),
      //   // (user) => ContextCard(
      //   //       user: user,
      //   //     ),
      //   // (user) => ContextCard(
      //   //       user: user,
      //   //     ),
      // ],
    );
  }
}
