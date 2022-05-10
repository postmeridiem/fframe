import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/user.dart';
import 'package:example/views/user/user.dart';
import 'package:example/views/user/tabs/tabs.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
    required this.isActive,
  }) : super(key: key);
  final bool isActive;

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
        return Text(
          data.displayName ?? "New User",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },
      document: _document(),
      documentList: DocumentList(
        queryBuilder: (query) => query.where("active", isEqualTo: isActive),
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
              text: "Settings",
              icon: Icon(
                Icons.settings,
              ),
            );
          },
          childBuilder: (user) {
            return SettingsTab(
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