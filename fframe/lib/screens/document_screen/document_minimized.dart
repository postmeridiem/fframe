part of '../../fframe.dart';

class MinimizedDocumentsWatcher extends StatefulWidget {
  const MinimizedDocumentsWatcher({super.key});

  @override
  State<MinimizedDocumentsWatcher> createState() => _MinimizedDocumentsWatcherState();
}

class _MinimizedDocumentsWatcherState extends State<MinimizedDocumentsWatcher> {
  EdgeInsets padding = SelectionState.instance.padding;
  @override
  void initState() {
    super.initState();

    SelectionState.instance.addListener(updatePadding);
  }

  updatePadding() {
    if (SelectionState.instance.padding != padding) {
      setState(() {
        padding = SelectionState.instance.padding;
      });
    }
  }

  @override
  dispose() {
    super.dispose();
    SelectionState.instance.removeListener(updatePadding);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: padding,
      duration: const Duration(seconds: 1),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ListenableBuilder(
            listenable: SelectionState.instance,
            builder: (context, child) {
              List<SelectionStateTracker> minimizedDocuments = SelectionState.instance.minimizedDocuments;
              return Wrap(
                textDirection: TextDirection.rtl,
                verticalDirection: VerticalDirection.up,
                spacing: 4.0,
                runSpacing: 4.0,
                direction: Axis.horizontal,
                children: minimizedDocuments
                    .map((SelectionStateTracker selectionStateTracker) => MinimizedDocument(
                          selectionStateTracker: selectionStateTracker,
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MinimizedDocument extends StatelessWidget {
  const MinimizedDocument({
    super.key,
    required this.selectionStateTracker,
  });
  final SelectionStateTracker selectionStateTracker;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: selectionStateTracker.trackerId,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set corner radius to 0 for hard edges
            ),
          ),
          onPressed: () {
            SelectionState.instance.maximizeDocument(selectionStateTracker.selectedDocument);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              selectionStateTracker.titleBuilder(context: context),
              IconButton(
                icon: const Icon(
                  Icons.maximize,
                ),
                onPressed: () {
                  SelectionState.instance.maximizeDocument(selectionStateTracker.selectedDocument);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () {
                  SelectionState.instance.closeDocument(selectionStateTracker.selectedDocument);
                },
              ),
            ],
          )),
    );
  }
}
