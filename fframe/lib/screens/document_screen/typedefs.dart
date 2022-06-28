part of fframe;

typedef ContextCardBuilder<T> = Widget Function(
  T data,
);

// typedef DocumentBuilder<T> = Widget Function(
//   BuildContext context,
//   T data,
//   bool readOnly,
// );

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
  bool readOnly,
);

typedef TitleBuilder<T> = Text Function(
  BuildContext context,
  T data,
);
