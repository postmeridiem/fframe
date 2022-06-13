part of fframe;

typedef ContextCardBuilder<T> = Widget Function(
  T data,
);

typedef DocumentBuilder<T> = Widget Function(
  BuildContext context,
  DocumentReference<T> documentReference,
  T data,
);

typedef DocumentListItemBuilder<T> = Widget Function(
  BuildContext context,
  bool selected,
  T data,
);

typedef DocumentStream<T> = Stream<DocumentSnapshot> Function(
  String? documentId,
);

typedef DocumentTabBuilder<T> = Widget Function();

typedef DocumentTabChildBuilder<T> = Widget Function(T data);

typedef TitleBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);
