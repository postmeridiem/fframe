import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

class FakeLogin extends StatelessWidget {
  const FakeLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Fake Login (without roles)"),
            onPressed: () {
              FRouter.of(context).signIn();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            child: const Text("Fake Login (with role: user)"),
            onPressed: () {
              FRouter.of(context).signIn(roles: ["user"]);
            },
          ),
        ],
      ),
    );
  }
}
