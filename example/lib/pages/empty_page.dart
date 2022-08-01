import 'dart:async';

import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedCrossFade(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 1250),
            reverseDuration: const Duration(milliseconds: 1250),
            firstChild: Icon(
              Icons.coffee_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            secondChild: Icon(
              Icons.coffee_maker_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            crossFadeState:
                _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          Text(
            "Much empty",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ]);
  }
}
