part of '../../fframe.dart';

class ListGridDocument<T> extends ConsumerStatefulWidget {
  const ListGridDocument({
    super.key,
    required this.documentConfig,
    required this.listGridController,
    required this.documentOpen,
  });
  final DocumentConfig<T> documentConfig;
  final ListGridController listGridController;
  final bool documentOpen;

  @override
  ConsumerState<ListGridDocument<T>> createState() => _ListGridDocumentState<T>();
}

class _ListGridDocumentState<T> extends ConsumerState<ListGridDocument<T>> {
  @override
  Widget build(BuildContext context) {
    // DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    // DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;
    if (widget.documentOpen) {
      return Row(
        children: [
          widget.listGridController.listGridConfig.hideListOnDocumentOpen
              ? const IgnorePointer()
              : const SizedBox(
                  width: 300,
                  child: IgnorePointer(),
                ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.listGridController.listGridConfig.widgetBackgroundColor,
                // color: Colors.cyan,
                border: Border(
                  left: BorderSide(
                    width: 1,
                    color: widget.listGridController.listGridConfig.widgetBackgroundColor ?? widget.listGridController.theme.colorScheme.background,
                  ),
                  top: BorderSide(
                    width: 1,
                    color: widget.listGridController.listGridConfig.widgetBackgroundColor ?? widget.listGridController.theme.colorScheme.background,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: widget.listGridController.listGridConfig.widgetBackgroundColor ?? widget.listGridController.theme.colorScheme.background,
                  ),
                ),
              ),
              // color: Theme.of(context).colorScheme.surface,
              // child: Text(
              //   queryState.queryString.toString(),
              // )
              // child: Column(children: [Text("${document}")]),
              child: ScreenBody<T>(
                key: ValueKey("ScreenBody_${widget.documentConfig.collection}"),
              ),
            ),
          ),
        ],
      );
    } else {
      return const IgnorePointer();
    }
  }
}
