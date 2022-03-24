//## +-+-+-+-+-+-+ DocumentListItem +-+-+-+-+-+-+ ##
// Builder for a single listitem in the document listing
part of fframe;

class DocumentList<T> {
  const DocumentList({
    required this.builder,
    this.queryBuilder,
  });
  final DocumentListItemBuilder<T> builder;
  final Query<T> Function(Query query)? queryBuilder;
}
