//## +-+-+-+-+-+-+ DocumentListItem +-+-+-+-+-+-+ ##
// Builder for a single listitem in the document listing
part of fframe;

class DocumentList<T> {
  const DocumentList({
    required this.query,
    required this.builder,
  });
  final Query<T> query;
  final DocumentListItemBuilder<T> builder;
}

// class BuildDocumentListItem<T> extends StatelessWidget {
//   const BuildDocumentListItem({
//     Key? key,
//     required this.builder,
//     required this.selected,
//     required this.data,
//   }) : super(key: key);
//   final DocumentListItemBuilder<T> builder;
//   final bool selected;
//   final T data;

//   @override
//   Widget build(BuildContext context) {
//     return builder(context, selected, data);
//   }
// }

// typedef DocumentListItem<T> = Widget Function({
//   BuildContext context,
//   bool selected,
//   T data,
// });
