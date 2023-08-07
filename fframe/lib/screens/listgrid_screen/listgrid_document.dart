part of fframe;

class ListGridDocument<T> extends ConsumerStatefulWidget {
  const ListGridDocument({
    super.key,
    required this.documentConfig,
    required this.listgrid,
    required this.documentOpen,
  });
  final DocumentConfig<T> documentConfig;
  final ListGridController listgrid;
  final bool documentOpen;

  @override
  ConsumerState<ListGridDocument<T>> createState() =>
      _ListGridDocumentState<T>();
}

class _ListGridDocumentState<T> extends ConsumerState<ListGridDocument<T>> {
  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig documentScreenConfig =
        DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig =
        documentScreenConfig.documentConfig as DocumentConfig<T>;
    return widget.documentOpen
        ? Row(
            children: [
              const SizedBox(
                width: 300,
                child: IgnorePointer(),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.listgrid.widgetBackgroundColor,
                    // color: Colors.cyan,
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: widget.listgrid.widgetBackgroundColor,
                      ),
                      top: BorderSide(
                        width: 1,
                        color: widget.listgrid.widgetBackgroundColor,
                      ),
                      right: BorderSide(
                        width: 1,
                        color: widget.listgrid.widgetBackgroundColor,
                      ),
                    ),
                  ),
                  // color: Theme.of(context).colorScheme.surface,
                  // child: Text(
                  //   queryState.queryString.toString(),
                  // )
                  // child: Column(children: [Text("${document}")]),
                  child: ScreenBody<T>(
                    key: ValueKey("ScreenBody_${documentConfig.collection}"),
                  ),
                ),
              ),
            ],
          )
        : const IgnorePointer();
  }
}
