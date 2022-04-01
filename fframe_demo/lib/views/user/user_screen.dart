import 'package:fframe_demo/models/user.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe_demo/views/user/user.dart';
import 'package:fframe_demo/views/user/user_document.dart';
import 'package:flutter/material.dart';

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
      //   key: key,
      //   query: UserService().userByMakeStream,
      //   documentStream: (String? documentId) => UserService().documentStream(documentId: documentId),
      //   // documentTabs: const [],
      //   //Left hand (navigation/document selection pane)
      //   documentListItem: DocumentListItem(
      //     builder: (context, bool selected, User user) {
      //       //List Tile per user
      //       return UserList(
      //         user: user,
      //         selected: selected,
      //       );
      //     },
      //   ),
      //   titleBuilder: (User user) {
      //     return Text(user.name ?? "New User");
      //   },
      //   // Right hand (document) pane
      //   documentBuilder: (
      //     BuildContext context,
      //     DocumentReference<User> documentReference,
      //     User user,
      //     // List actionButtons,
      //     // List<DocumentTab> documentTabs,
      //     // List<Widget>? contextWidgets,
      //   )
      //       // documentBuilder: (context, DocumentReference<User> documentReference, User user)
      //       {
      //     return UserDocument(
      //       user: user,
      //       documentReference: documentReference,
      //     );
      //   },
    );
  }

  Document<User> _document() {
    return Document<User>(
      autoSave: false,
      tabs: [
        DocumentTab<User>(
          tabBuilder: () {
            return const Tab(
              text: "User",
              icon: Icon(
                Icons.person,
              ),
            );
          },
          childBuilder: (user) {
            return UserDocument(
              user: user,
              // user: user,
            );
          },
        ),
      ],
      contextCards: [
        // (user) => ContextCard(
        //       user: user,
        //     ),
        // (user) => ContextCard(
        //       user: user,
        //     ),
        // (user) => ContextCard(
        //       user: user,
        //     ),
      ],
    );
  }
}
