import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.error,
            size: 48.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Something failed succesfully"),
          ),
        ],
      ),
    );
  }
}
