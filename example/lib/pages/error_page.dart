import 'dart:async';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final duration = const Duration(seconds: 2);

  bool _first = false;

  @override
  void initState() {
    Timer.periodic(duration, (timer) {
      setState(() {
        _first = !_first;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuild Error page $_first");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
            firstChild: const Icon(
              Icons.error,
              size: 48.0,
              key: ValueKey("error_icon_white"),
            ),
            secondChild: Icon(
              Icons.error,
              size: 48.0,
              color: Colors.redAccent.shade700,
              key: const ValueKey("error_icon_red"),
            ),
            crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Fframe.of(context)?.errorText ?? "Something failed succesfully"),
          ),
        ],
      ),
    );
  }
}
