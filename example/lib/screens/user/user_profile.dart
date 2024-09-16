import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    FFrameUser? fFrameUser = Fframe.of(context)?.user;
    if (fFrameUser != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // ProfileWidget(
            //   user: fFrameUser as AppUser,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text("Timestamp"),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("${fFrameUser.timeStamp?.toLocal()}"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text("User Token"),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("${fFrameUser.firebaseUser?.refreshToken}"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text("Roles"),
                  ),
                  Expanded(
                    flex: 3,
                    child: UserProfileRoleChips(fFrameUser: fFrameUser),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text("Name"),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(TextEditingValue(text: fFrameUser.displayName ?? "")),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text("Email"),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(TextEditingValue(text: fFrameUser.email!)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text("no profile active");
    }
  }
}

class UserProfileRoleChips extends StatelessWidget {
  const UserProfileRoleChips({
    super.key,
    required this.fFrameUser,
  });

  final FFrameUser fFrameUser;

  @override
  Widget build(BuildContext context) {
    List<Widget> roleChips = [];

    for (String role in fFrameUser.roles) {
      roleChips.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Chip(
          label: Text(role),
        ),
      ));
    }

    return Row(
      children: roleChips,
    );
  }
}
