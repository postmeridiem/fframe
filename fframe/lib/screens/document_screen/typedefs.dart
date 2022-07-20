part of fframe;

typedef ContextCardBuilder<T> = Widget Function(
  T data,
);

typedef DocumentTabsBuilder<T> = List<DocumentTab<T>> Function(
  BuildContext context,
  T data,
  bool isReadOnly,
  bool isNew,
  FFrameUser? user,
);

typedef DocumentListItemBuilder<T> = Widget Function(
  BuildContext context,
  bool selected,
  T data,
  FFrameUser? user,
);

typedef DocumentStream<T> = Stream<DocumentSnapshot> Function(
  String? documentId,
);

typedef DocumentTabBuilder<T> = Widget Function(FFrameUser? user);

typedef DocumentTabChildBuilder<T> = Widget Function(
  T data,
  bool isReadOnly,
);

typedef TitleBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);
