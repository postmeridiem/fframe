import 'package:flutter/material.dart';

class PaletteForm extends StatefulWidget {
  const PaletteForm({Key? key}) : super(key: key);

  @override
  State<PaletteForm> createState() => _PaletteFormFormState();
}

class _PaletteFormFormState extends State<PaletteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("presenting palette");
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
                        style: TextStyle(fontFamily: "Raleway"),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                "Raleway",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Raleway",
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
                      color: Theme.of(context).colorScheme.tertiary,
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
                        "colorScheme.background\ncolorScheme.onBackground",
                        style: TextStyle(
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 20,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.background,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
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
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.primary,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
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
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
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
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.tertiary,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
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
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.surface,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 20,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.surfaceVariant,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
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
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.error,
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
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Sample Text",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              fontSize: 20,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.errorContainer,
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
