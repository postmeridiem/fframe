import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String? waitText = Fframe.of(context)?.waitText;

    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      builder: (context, child) {
        return Scaffold(
          body: (waitText != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(waitText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     CircularProgressIndicator(
    //       color: color,
    //     ),
    //     if (waitText != null)
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Center(
    //           child: Text(
    //             waitText,
    //             style: TextStyle(
    //               color: Theme.of(context).colorScheme.onSurface,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //   ],
    // );
  }
}
