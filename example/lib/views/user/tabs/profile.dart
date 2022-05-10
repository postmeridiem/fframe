import 'package:flutter/material.dart';
import 'package:example/models/user.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    required this.user,
    Key? key,
  }) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final User user;

  @override
  Widget build(BuildContext context) {
    List<String>? avatarText = user.displayName
        ?.split(' ')
        .map((part) => part.trim().substring(0, 1))
        .toList();
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
                  child: (user.photoURL == null && avatarText != null)
                      ? Text(
                          "${avatarText.first}${avatarText.last}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                  backgroundImage: (user.photoURL == null)
                      ? null
                      : NetworkImage(user.photoURL!),
                  backgroundColor: (user.photoURL == null)
                      ? Colors.amber
                      : Colors.transparent,
                ),
              Text(
                "user: ${user.displayName ?? ''}",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onTertiary),
              ),
              Text(
                "active: ${user.active ?? ''}",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onTertiary),
              ),
              Text(
                "email: ${user.email ?? ''}",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
