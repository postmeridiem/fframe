part of '../../fframe.dart';

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({super.key, required this.contextWidgets});
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
    super.key,
    required this.contextDrawerOpen,
  });

  final bool contextDrawerOpen;

  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig = DocumentScreenConfig.of(context)!.documentConfig as DocumentConfig<T>;
    if (contextDrawerOpen) {
      // if the document canvas gets too small, render this
      if (documentConfig.document.contextCards != null && documentConfig.document.contextCards!.isNotEmpty) {
        return SizedBox(
          width: 250,
          child: ContextCanvas(
            contextWidgets: documentConfig.document.contextCards!
                .map(
                  (contextCardBuilder) => contextCardBuilder(documentScreenConfig.selectionState.data),
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
  const DrawerButton({super.key, required this.scaffoldKey});
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
