import 'package:fframe/controllers/appUserStateController.dart';
import 'package:fframe/providers/globalProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateNotifierProvider);

    UserStateSignedIn user = userState as UserStateSignedIn;
    print("Getting profile for: " + user.appUser.uid);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text("Display name: "),
              Text(user.appUser.displayName!),
              Text(" ("),
              Text(user.appUser.email!),
              Text(")"),
            ],
          ),
        ),
        IconButton(
          onPressed: userState.signOut,
          icon: Icon(Icons.logout_outlined),
          tooltip: "Sign out ${userState.appUser.displayName}",
        ),
      ],
    );
  }
}
