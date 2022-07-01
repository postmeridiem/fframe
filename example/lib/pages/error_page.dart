import 'dart:async';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final duration = const Duration(seconds: 10);

  bool _first = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _first = !_first;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            firstChild: Icon(
              Icons.error,
              size: 48.0,
              key: const ValueKey("error_icon_white"),
              color: Theme.of(context).colorScheme.onBackground,
            ),
            secondChild: Icon(
              Icons.error,
              size: 48.0,
              color: Theme.of(context).colorScheme.error,
              key: const ValueKey("error_icon_red"),
            ),
            crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Fframe.of(context)?.errorText ?? "Something failed succesfully",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
