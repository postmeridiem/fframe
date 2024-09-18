// ignore: unused_import
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/screens/user/user.dart';

import 'package:example/models/appuser.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    super.key,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    // bool profileMode = getProfileMode();
    // if (profileMode) {
    //   return const UserProfileScreen();
    // }
    return DocumentScreen<AppUser>(
      // formKey: GlobalKey<FormState>(),
      collection: "users",
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (user, options) => user.toFirestore(),
      createNew: () => AppUser(),
      // query: (Query<AppUser> query) {
      //   return query.orderBy("lastName");
      // },

      documentTitle: (context, data) {
        return data.displayName ?? "New User";
      },

      headerBuilder: (BuildContext context, String documentTitle, AppUser data) {
        return Text(
          documentTitle,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },

      // Optional ListGrid widget
      viewType: ViewType.listgrid,
      listGrid: ListGridConfig<AppUser>(
        searchHint: "Search user name",
        columnSettings: listGridColumns,
      ),

      document: _document(),
    );
  }

  Document<AppUser> _document() {
    return Document<AppUser>(
      autoSave: false,
      extraActionButtons: (BuildContext context, SelectedDocument selectedDocument, bool isReadOnly, bool isNew, FFrameUser? user) {
        return [
          if (user != null && user.hasRole("firestoreaccess"))
            IconButton(
              tooltip: "Open Firestore Document",
              onPressed: () {
                String domain = "https://console.cloud.google.com";
                String application = "firestore/databases/-default-/data/panel";
                String collection = "users";
                String docId = selectedDocument.data.uid ?? "";
                String gcpProject = Fframe.of(context)!.firebaseOptions.projectId;
                Uri url = Uri.parse("$domain/$application/$collection/$docId?&project=$gcpProject");
                launchUrl(url);
              },
              icon: Icon(
                Icons.table_chart_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ];
      },
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
            childBuilder: (selecedDocument, readOnly) {
              return ProfileTab(
                user: selecedDocument.data,
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
            childBuilder: (selecedDocument, readOnly) {
              return RolesTab(
                user: selecedDocument.data,
              );
            },
          ),
        ];
      },
    );
  }

  // bool getProfileMode() {
  //   String? id = FRouter.of(context).queryStringParam("id");
  //   if (id != null && id == "profile") {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}

// class ProfileWidget extends StatelessWidget {
//   const ProfileWidget({
//     required this.user,
//     Key? key,
//   }) : super(key: key);

//   // Fields in a Widget subclass are always marked "final".
//   final AppUser user;

//   @override
//   Widget build(BuildContext context) {
//     List<String>? avatarText = user.displayName
//         ?.split(' ')
//         .map((part) => part.trim().substring(0, 1))
//         .toList();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         color: Theme.of(context).colorScheme.tertiary,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               if (avatarText != null || user.photoURL != null)
//                 CircleAvatar(
//                   radius: 18.0,
//                   backgroundImage: (user.photoURL == null)
//                       ? null
//                       : NetworkImage(user.photoURL!),
//                   backgroundColor: (user.photoURL == null)
//                       ? Colors.amber
//                       : Colors.transparent,
//                   child: (user.photoURL == null && avatarText != null)
//                       ? Text(
//                           "${avatarText.first}${avatarText.last}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       : null,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
