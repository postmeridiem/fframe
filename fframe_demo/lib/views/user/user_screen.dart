import 'package:fframe/screens/errorscreen.dart';
import 'package:fframe_demo/models/user.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe_demo/services/user_service.dart';
import 'package:fframe_demo/views/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(error: Exception("Not implemented"));
    // return DocumentScreen<User>(
    //   key: key,
    //   query: UserService().userByMakeStream,
    //   documentStream: (String? documentId) => UserService().documentStream(documentId: documentId),
    //   // documentTabs: const [],
    //   //Left hand (navigation/document selection pane)
    //   documentListItem: DocumentListItem(
    //     builder: (context, bool selected, User user) {
    //       //List Tile per suggestion
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
    // );
  }
}
