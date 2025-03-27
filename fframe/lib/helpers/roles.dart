import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FframeRolesManager<T extends Enum> extends StatefulWidget {
  const FframeRolesManager({
    super.key,
    required this.uid,
    required this.appRoles,
    required this.roleGroups,
  });

  final Map<String, String> appRoles;
  final Map<String, List<T>> roleGroups;
  final String uid;

  @override
  State<FframeRolesManager> createState() => _FframeRolesManagerState<T>();
}

class _FframeRolesManagerState<T extends Enum> extends State<FframeRolesManager<T>> {
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.amber[900]),
              const SizedBox(width: 8),
              Expanded(child: Text("${e.message}", style: TextStyle(color: Colors.amber[900]))),
            ],
          ),
        ),
      );
    } catch (e) {
      Console.log("ERROR: ${e.toString()}", scope: "fframeAuth.addUserRole", level: LogLevel.prod);
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.amber[900]),
              const SizedBox(width: 8),
              Expanded(child: Text("${e.message}", style: TextStyle(color: Colors.amber[900]))),
            ],
          ),
        ),
      );
    } catch (e) {
      Console.log("ERROR: ${e.toString()}", scope: "fframeAuth.removeUserRole", level: LogLevel.prod);
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
      if (!context.mounted) return [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.amber[900]),
              const SizedBox(width: 8),
              Expanded(child: Text("${e.message}", style: TextStyle(color: Colors.amber[900]))),
            ],
          ),
        ),
      );
    } catch (e) {
      Console.log("ERROR: ${e.toString()}", scope: "fframeAuth.getUserRoles", level: LogLevel.prod);
    }
    return [];
  }

  Future<void> assignRoleGroup(BuildContext context, String groupName, List<T> roles) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Role Group Change"),
        content: Text("This will remove all existing roles and assign only the ${groupName} roles. Proceed?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    for (final role in userRoles) {
      await removeUserRole(context, role);
    }

    for (final roleEnum in roles) {
      final roleKey = roleEnum.name;
      final roleString = widget.appRoles[roleKey];
      if (roleString != null) {
        await addUserRole(context, roleKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getUserRoles(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return FRouter.of(context).waitPage(context: context, text: "Loading user roles");
          case ConnectionState.done:
            if (snapshot.hasData) {
              userRoles = snapshot.data!;
            }
            return Column(
              children: [
                // Sticky role group buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: widget.roleGroups.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => assignRoleGroup(context, entry.key, entry.value),
                            child: Text("Apply ${entry.key} Roles"),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Divider(height: 32),
                ...widget.appRoles.entries.map(
                  (entry) => SwitchListTile(
                    title: Text(entry.value),
                    value: userRoles.contains(entry.key),
                    onChanged: (bool newValue) {
                      if (newValue == false) {
                        removeUserRole(context, entry.key);
                      } else {
                        addUserRole(context, entry.key);
                      }
                    },
                    activeColor: Theme.of(context).indicatorColor,
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
