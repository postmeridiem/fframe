part of fframe;

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.contextWidgets}) : super(key: key);
  final List<Widget> contextWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: contextWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class ContextDrawer<T> extends StatelessWidget {
  const ContextDrawer({
    Key? key,
    required this.queryState,
    required this.contextDrawerOpen,
  }) : super(key: key);

  final QueryState<T> queryState;
  final bool contextDrawerOpen;

  @override
  Widget build(BuildContext context) {
    DocumentConfig<T> documentConfig = InheritedDocument.of(context)!.documentConfig as DocumentConfig<T>;
    if (contextDrawerOpen) {
      // if the document canvas gets too small, render this
      if (documentConfig.document.contextCards != null && documentConfig.document.contextCards!.isNotEmpty) {
        return SizedBox(
          width: 250,
          child: ContextCanvas(
            contextWidgets: documentConfig.document.contextCards!
                .map(
                  (contextCardBuilder) => contextCardBuilder(queryState.context),
                )
                .toList(),
          ),
        );
      } else {
        return const IgnorePointer();
      }
    } else {
      return DrawerButton(scaffoldKey: GlobalKey<ScaffoldState>());
    }
  }
}

class DrawerButton extends StatefulWidget {
  const DrawerButton({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<DrawerButton> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.scaffoldKey.currentState != null && widget.scaffoldKey.currentState!.hasEndDrawer) {
      return LimitedBox(
        maxWidth: 12,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(
              seconds: 2,
            ),
            child: widget.scaffoldKey.currentState!.isEndDrawerOpen
                ? IconButton(
                    onPressed: () => setState(
                      () => widget.scaffoldKey.currentState!.openDrawer(),
                    ),
                    icon: const Icon(Icons.arrow_forward_ios),
                    iconSize: 10,
                    splashRadius: 12,
                  )
                : IconButton(
                    onPressed: () => setState(
                      () => widget.scaffoldKey.currentState!.openEndDrawer(),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    iconSize: 10,
                    splashRadius: 12,
                  ),

            // ? const Icon(Icons.arrow_forward_ios) : const Icon(Icons.arrow_back_ios_new),
          ),
        ),
      );
    }
    return const IgnorePointer();
  }
}
