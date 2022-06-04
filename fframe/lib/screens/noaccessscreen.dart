import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoAccessScreen extends StatelessWidget {
  const NoAccessScreen(this.initialRoute, {Key? key}) : super(key: key);
  final String initialRoute;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              color: Colors.redAccent[700],
              size: 48.0,
            ),
            TextButton(
              onPressed: () => context.go(initialRoute),
              child: Text(
                L10n.string(
                  'errors_homelink',
                  placeholder: "Home",
                ),
              ),
            ),
          ],
        ),
      );
}
