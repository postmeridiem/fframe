import 'dart:async';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

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
    String errorText = Fframe.of(context)?.errorText ?? "Something failed succesfully";
    String? httpLink;
    int linkIndex = errorText.toLowerCase().split(" ").indexWhere((String word) => word.startsWith("http://") || word.startsWith("https://"));
    if (linkIndex != -1) {
      List<String> errorArray = errorText.split(" ");
      httpLink = errorArray.elementAt(linkIndex);
      errorArray.removeAt(linkIndex);
      errorText = errorArray.join(" ");
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
            secondChild: Icon(
              Icons.error,
              size: 48.0,
              key: const ValueKey("error_icon_white"),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            firstChild: Icon(
              Icons.error,
              size: 48.0,
              color: Theme.of(context).colorScheme.error,
              key: const ValueKey("error_icon_red"),
            ),
            crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                errorText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (httpLink != null)
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(httpLink!));
              },
              child: Text(
                "link",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            )
        ],
      ),
    );
  }
}
