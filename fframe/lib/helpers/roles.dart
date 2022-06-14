import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class RolesManager extends StatefulWidget {
  const RolesManager({
    Key? key,
    required this.uid,
    required this.appRoles,
  }) : super(key: key);
  final Map<String, String> appRoles;
  final String uid;

  @override
  State<RolesManager> createState() => _RolesManagerState();
}

class _RolesManagerState extends State<RolesManager> {
  List<String> userRoles = [];

  addUserRole(BuildContext context, String role) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-addUserRole");
      HttpsCallableResult<List<dynamic>> functionResults = await callable(<String, dynamic>{
        'uid': widget.uid,
        'role': role,
      });
      setState(() {
        userRoles = functionResults.data.map((roleDynamic) => roleDynamic.toString()).toList();
      });
    } on FirebaseFunctionsException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(
            leading: Icon(
              Icons.error,
              color: Colors.amber[900],
            ),
            title: Text('${e.message}'),
            textColor: Colors.amber[900],
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  removeUserRole(BuildContext context, String role) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-removeUserRole");
      HttpsCallableResult<List<dynamic>> functionResults = await callable(<String, dynamic>{
        'uid': widget.uid,
        'role': role,
      });
      setState(() {
        userRoles = functionResults.data.map((roleDynamic) => roleDynamic.toString()).toList();
      });
    } on FirebaseFunctionsException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(
            leading: Icon(
              Icons.error,
              color: Colors.amber[900],
            ),
            title: Text('${e.message}'),
            textColor: Colors.amber[900],
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<String>> getUserRoles(BuildContext context) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-getUserRoles");
      HttpsCallableResult<List<dynamic>> functionResults = await callable(<String, dynamic>{
        'uid': widget.uid,
      });
      return functionResults.data.map((roleDynamic) => roleDynamic.toString()).toList();
    } on FirebaseFunctionsException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(
            leading: Icon(
              Icons.error,
              color: Colors.amber[900],
            ),
            title: Text('${e.message}'),
            textColor: Colors.amber[900],
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getUserRoles(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return FRouter.of(context).waitPage;
            case ConnectionState.waiting:
              return FRouter.of(context).waitPage;
            case ConnectionState.active:
              return FRouter.of(context).waitPage;
            case ConnectionState.done:
              if (snapshot.hasData) {
                userRoles = snapshot.data!;
              }
              return ListView(
                children: widget.appRoles.entries
                    .map(
                      (MapEntry mapEntry) => SwitchListTile(
                        title: Text("${mapEntry.value}"),
                        value: userRoles.contains(mapEntry.key),
                        onChanged: (bool newValue) => {
                          if (newValue == false) {removeUserRole(context, mapEntry.key)} else {addUserRole(context, mapEntry.key)}
                        },
                      ),
                    )
                    .toList(),
              );
          }
        });
  }
}
