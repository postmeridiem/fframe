import 'package:fframe/helpers/roles.dart';
import 'package:example/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:example/models/appuser.dart';

class RolesTab extends StatelessWidget {
  // ignore: use_super_parameters
  const RolesTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return FframeRolesManager(
      uid: user.uid!,
      appRoles: appRoles,
    );
  }
}
