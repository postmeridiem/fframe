import 'package:example/themes/config.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class PaletteForm extends StatefulWidget {
  // ignore: use_super_parameters
  const PaletteForm({Key? key}) : super(key: key);

  @override
  State<PaletteForm> createState() => _PaletteFormFormState();
}

class _PaletteFormFormState extends State<PaletteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Console.log("Opening PaletteForm", scope: "exampleApp.Settings");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(300),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "Fonts",
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: const SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "OpenSans",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "OpenSans",
                                ),
                              ),
                              Text(
                                " / ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "RobotoMono",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "RobotoMono",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Text(""),
                    Text(""),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.background\ncolorScheme.onSurface",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.primary\ncolorScheme.onPrimary",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.secondary\ncolorScheme.onSecondary",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.tertiary\ncolorScheme.onTertiary",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.surface\ncolorScheme.onSurface",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.surfaceVariant\ncolorScheme.onSurfaceVariant",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.primaryContainer\ncolorScheme.onPrimaryContainer",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.secondaryContainer\ncolorScheme.onSecondaryContainer",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.error\ncolorScheme.onError",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.error,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "colorScheme.errorContainer\ncolorScheme.onErrorContainer",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                              fontSize: 20,
                              fontFamily: "OpenSans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        "SignalColor() configuration",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constAccentColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constAccentColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constWaitingColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constWaitingColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constRunningColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constRunningColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constSuccessColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constSuccessColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constWarningColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constWarningColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Card(
                            color: SignalColors().constErrorColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ".constErrorColor",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
