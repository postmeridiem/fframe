import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

class FakeLogin extends StatelessWidget {
  const FakeLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        NavigationNotifier navigationNotifier = ref.read(navigationProvider);
        return Center(
          child: ElevatedButton(
            child: const Text("Fake Login"),
            onPressed: () {
              navigationNotifier.isSignedIn = true;
            },
          ),
        );
      },
    );
  }
}
