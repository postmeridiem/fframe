import 'package:flutter/material.dart';
import 'package:example/models/user.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ProfileWidget(
        user: user,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.displayName!)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
          readOnly: true,
          controller: TextEditingController.fromValue(TextEditingValue(text: user.email!)),
        ),
      ),
    ]);
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    List<String>? avatarText = user.displayName?.split(' ').map((part) => part.trim().substring(0, 1)).toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (avatarText != null || user.photoURL != null)
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage: (user.photoURL == null) ? null : NetworkImage(user.photoURL!),
                  backgroundColor: (user.photoURL == null) ? Colors.amber : Colors.transparent,
                  child: (user.photoURL == null && avatarText != null)
                      ? Text(
                          "${avatarText.first}${avatarText.last}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
