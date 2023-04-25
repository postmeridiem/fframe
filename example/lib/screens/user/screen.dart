// ignore: unused_import
import 'package:example/pages/empty_page.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/screens/user/user.dart';
import 'package:example/screens/user/tabs/tabs.dart';

import 'package:example/models/appuser.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },
      queryBuilder: (query) => query.orderBy("displayName"),
      document: _document(),
      documentList: DocumentList(
        // hoverSelect: true,
        showCreateButton: false,
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
    );
  }
}
