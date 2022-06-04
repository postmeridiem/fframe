import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

class FakeLogin extends StatelessWidget {
  const FakeLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Fake Login"),
        onPressed: () {
          FRouter.of(context).login();
        },
      ),
    );
  }
}
