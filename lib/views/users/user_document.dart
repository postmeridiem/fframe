import 'package:fframe/models/user.dart';
import 'package:fframe/services/userService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Shows the selected customer in the right hand pane
class UserDocument extends StatelessWidget {
  UserDocument({required this.user, required this.documentReference, Key? key}) : super(key: key);
  final DocumentReference documentReference;
  final User user;
  final UserService usersService = UserService();
  // bool _toggled = false; //Dit kan niet... en zit op het verkeerde nivo. Toggled is niet een state van het document maar
  //is een state van de toggle-switch. Dus die ziet in de allClaims Loop

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.name!)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User UID',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.id!)),
        ),
      ),
    ]);
  }
}

// class RolesSwitchTile extends StatelessWidget {
//   RolesSwitchTile({
//     required this.claim,
//     required this.user,
//     required this.documentReference,
//     Key? key,
//   }) : super(key: key);
//   final MapEntry claim;
//   final User user;
//   final DocumentReference documentReference;
//   final UserService usersService = UserService();
//   @override
//   Widget build(BuildContext context) {
//     return SwitchListTile(
//       title: Text("${claim.value}"),
//       value: user.claims!.contains(claim.key),
//       onChanged: (bool value) {
//         {
//           if (value == true) {
//             user.claims!.add(claim.key);
//           } else {
//             user.claims!.remove(claim.key);
//           }
//           usersService.applyChanges(user: user, documentReference: documentReference);
//           //Stappenplan:
//           //1: Neem de waarce van de huidige claim (claim.key)
//           //2: Voeg de waaede van (1) toe aan user.claims
//           //3: Update de waarde in de database

//           //TODO: Put the change in the roles and commit the roles to the database
//         }
//         ;
//       },
//     );
//   }
// }

// class UserClaimsSwitch extends StatefulWidget {
//   const UserClaimsSwitch({Key? key}) : super(key: key);

//   @override
//   State<UserClaimsSwitch> createState() => _UserClaimsSwitchState();
// }

// class _UserClaimsSwitchState extends State<UserClaimsSwitch> {
//   bool _lights = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children:[
//         ...allClaims.entries.map((MapEntry mapEntry) {
//         return SwitchListTile (
//        title:  Text ("${mapEntry.key} => ${mapEntry.value}"),
//        value: _lights,
//        onChanged:(value) {
//          setState(() {
//            _lights = value;
//          });
//        },
//         )
//       }.toList(),

//     );
//       ]
//     // return SwitchListTile(
//     //   title: const Text('Lights'),
//     //   value: _lights,
//     //   onChanged: (bool value) {
//     //     setState(() {
//     //       _lights = value;
//     //     });
//     //   },
//     //   secondary: const Icon(Icons.lightbulb_outline),
//     // );
//   }
// }

// return Column(
//   children: [
//     Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "FiresStore Document Reference",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Divider(),
//             Text("id: ${documentReference.id}"),
//             Text("path: ${documentReference.path}"),
//             Text("parent: ${documentReference.parent}"),
//           ],
//         ),
//       ),
//     ),
//     Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "User",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Divider(),
//             Text("id: ${users.id}"),
//             Text("name: ${users.displayName}"),
//             Text("Email: ${users.email}"),
//             Text("User Editor: ${users.userEditor}"),
//             Switch(
//               value: users.userEditor!,
//               onChanged: (bool value) {
//                 users.userEditor = value;
//                 usersService.applyChanges(users: users, documentReference: documentReference);
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   ],
// );
