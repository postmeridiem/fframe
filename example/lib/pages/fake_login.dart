import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class FakeLogin extends StatelessWidget {
  const FakeLogin({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
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
