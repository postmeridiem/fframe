import 'package:example/models/user.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({
    required this.user,
    required this.selected,
    Key? key,
  }) : super(key: key);
  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    List<String>? avatarText = user.displayName?.split(' ').map((part) => part.trim().substring(0, 1)).toList();
    return ListTile(
      selected: selected,
      leading: (avatarText != null || user.photoURL != null)
          ? CircleAvatar(
              radius: 18.0,
              backgroundImage: (user.photoURL == null) ? null : NetworkImage(user.photoURL!),
              backgroundColor: (user.photoURL == null) ? Colors.amber : Colors.transparent,
              child: (user.photoURL == null && avatarText != null)
                  ? Text(
                      "${avatarText.first}${avatarText.last}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            )
          : null,
      selectedColor: Theme.of(context).colorScheme.onTertiary,
      selectedTileColor: Theme.of(context).colorScheme.tertiary,
      title: Text(
        user.displayName ?? "?",
        style: TextStyle(
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
