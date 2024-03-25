part of '../../fframe.dart';

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

typedef ExtraActionButtonsBuilder<T> = List<Widget> Function(
  BuildContext context,
  SelectedDocument<T> selectedDocument,
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

typedef DocumentListHeaderBuilder<T> = Widget Function(
  BuildContext context,
  int documentCount,
);

typedef DocumentListFooterBuilder<T> = Widget Function(
  BuildContext context,
  int documentCount,
);

typedef DocumentStream<T> = Stream<DocumentSnapshot> Function(
  String? documentId,
);

typedef DocumentTabBuilder<T> = Widget Function(FFrameUser? user);

typedef DocumentTabChildBuilder<T> = Widget Function(
  SelectedDocument<T> data,
  bool isReadOnly,
);

typedef TitleBuilder<T> = Text Function(
  BuildContext context,
  T data,
);

typedef DocumentHeaderBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);

typedef DocumentScreenHeaderBuilder<T> = Widget Function();
typedef DocumentScreenFooterBuilder<T> = Widget Function();
