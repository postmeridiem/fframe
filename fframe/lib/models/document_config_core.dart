import 'package:flutter/material.dart';

/// Core DocumentConfig model without fframe UI dependencies.
/// This is used by DatabaseService for dependency injection scenarios.
class DocumentConfig<T> extends ChangeNotifier {
  final GlobalKey<FormState> formKey;
  final String collection;
  final T Function() createNew;
  final String initialViewType;
  final String documentTitle;
  final Widget Function(BuildContext, DocumentConfig<T>)? headerBuilder;
  final Future<void> Function(T, String)? preSave;
  final Future<void> Function(T, String)? preOpen;

  DocumentConfig({
    required this.formKey,
    required this.collection,
    required this.createNew,
    required this.initialViewType,
    required this.documentTitle,
    this.headerBuilder,
    this.preSave,
    this.preOpen,
  });
}