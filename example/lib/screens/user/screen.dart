// ignore: unused_import
import 'package:example/pages/empty_page.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/screens/user/user.dart';
import 'package:example/screens/user/tabs/tabs.dart';

import 'package:example/models/appuser.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
    required this.isActive,
  }) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return DocumentScreen<AppUser>(
      // formKey: GlobalKey<FormState>(),
      collection: "users",
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (user, options) => user.toFirestore(),
      createNew: () => AppUser(),
      // query: (Query<AppUser> query) {
      //   return query.orderBy("lastName");
      // },
      titleBuilder: (context, data) {
        return Text(
          data.displayName ?? "New User",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },
      document: _document(),
      documentList: DocumentList(
        hoverSelect: true,
        showCreateButton: false,
        queryBuilder: (query) =>
            query.orderBy("displayName").where("active", isEqualTo: isActive),
        builder: (context, selected, data, fFrameUser) {
          return UserListItem(
            user: data,
            selected: selected,
            fFrameUser: fFrameUser,
          );
        },
      ),
    );
  }

  Document<AppUser> _document() {
    return Document<AppUser>(
      autoSave: false,
      documentTabsBuilder: (context, data, isReadOnly, isNew, fFrameUser) {
        return [
          DocumentTab<AppUser>(
            tabBuilder: (fFrameUser) {
              return const Tab(
                text: "Profile",
                icon: Icon(
                  Icons.person,
                ),
              );
            },
            childBuilder: (user, readOnly) {
              return ProfileTab(
                user: user,
              );
            },
          ),
          DocumentTab<AppUser>(
            tabBuilder: (fFrameUser) {
              return const Tab(
                text: "Roles",
                icon: Icon(
                  Icons.lock_open,
                ),
              );
            },
            childBuilder: (user, readOnly) {
              return RolesTab(
                user: user,
              );
            },
          ),
        ];
      },
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
