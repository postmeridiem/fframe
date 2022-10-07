import 'package:fframe/helpers/roles.dart';
import 'package:example/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:example/models/appuser.dart';

class RolesTab extends StatelessWidget {
  const RolesTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FframeRolesManager(
        uid: user.uid!,
        appRoles: appRoles,
      ),
      // child: Card(
      //   color: Theme.of(context).colorScheme.tertiary,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       children: [
      //         Text("current roles according to  user: ${user.customClaims!['roles'] ?? ''}"),
      //         Text("uid: ${user.uid ?? ''}"),
      //         TextButton(
      //           onPressed: () async {
      //             HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-getUserRoles");
      //             final functionResults = await callable(<String, dynamic>{
      //               'uid': user.uid,
      //             });
      //             debugPrint("getUserRoles: ${functionResults.data?.toString()}");
      //           },
      //           child: const Text("getUserRoles"),
      //         ),
      //         TextButton(
      //           onPressed: () async {
      //             try {
      //               HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-addUserRole");
      //               final functionResults = await callable(<String, dynamic>{
      //                 'uid': user.uid,
      //                 'role': 'TestRole',
      //               });
      //               debugPrint("addUserRole: ${functionResults.data?.toString()}");
      //             } on FirebaseFunctionsException catch (e) {
      //               ScaffoldMessenger.of(context).showSnackBar(
      //                 SnackBar(
      //                   content: ListTile(
      //                     leading: Icon(
      //                       Icons.error,
      //                       color: Colors.amber[900],
      //                     ),
      //                     title: Text('${e.message}'),
      //                     textColor: Colors.amber[900],
      //                   ),
      //                 ),
      //               );
      //             } catch (e) {
      //               debugPrint(e.toString());
      //             }
      //           },
      //           child: const Text("addUserRole"),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
