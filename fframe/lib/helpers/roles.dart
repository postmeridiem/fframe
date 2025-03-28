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
  bool isLoading = false;

  Future<List<String>> getUserRoles(BuildContext context) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-getUserRoles");
      HttpsCallableResult<List<dynamic>> functionResults = await callable(<String, dynamic>{
        'uid': widget.uid,
      });
      return functionResults.data.map((roleDynamic) => roleDynamic.toString()).toList();
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
    return [];
  }

  Future<void> assignRoleGroup(BuildContext context, String groupName, List<T> roles) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Role Group Change"),
        content: Text("This will remove all existing roles and assign only the $groupName roles. Proceed?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    final newRoles = roles.map((r) => r.name).toList();
    await assignMultipleRoles(context, newRoles);
  }

  Future<void> toggleUserRole(BuildContext context, String role, bool add) async {
    try {
      final functionName = add ? "fframeAuth-addUserRole" : "fframeAuth-removeUserRole";
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(functionName);
      HttpsCallableResult<List<dynamic>> functionResults = await callable(<String, dynamic>{
        'uid': widget.uid,
        'role': role,
      });
      setState(() {
        userRoles = functionResults.data.map((roleDynamic) => roleDynamic.toString()).toList();
      });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<void> assignMultipleRoles(BuildContext context, List<String> newRoles) async {
    setState(() {
      isLoading = true;
    });

    try {
      final currentRoles = await getUserRoles(context);

      for (final role in currentRoles) {
        final callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-removeUserRole");
        await callable({'uid': widget.uid, 'role': role});
      }

      for (final role in newRoles) {
        final callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable("fframeAuth-addUserRole");
        await callable({'uid': widget.uid, 'role': role});
      }

      final updatedRoles = await getUserRoles(context);
      setState(() {
        userRoles = updatedRoles;
      });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.amber[900]),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: Colors.amber[900]))),
          ],
        ),
        actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop())],
      ),
    );
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Column(
                        children: widget.appRoles.entries
                            .map(
                              (entry) => SwitchListTile(
                                title: Text(entry.value),
                                value: userRoles.contains(entry.key),
                                onChanged: (bool newValue) => toggleUserRole(context, entry.key, newValue),
                                activeColor: Theme.of(context).indicatorColor,
                              ),
                            )
                            .toList(),
                      ),
              ],
            );
        }
      },
    );
  }
}
