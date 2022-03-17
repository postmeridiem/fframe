import 'package:fframe_demo/views/suggestion/first_tab.dart';
import 'package:fframe_demo/views/suggestion/second_tab.dart';
import 'package:fframe_demo/views/suggestion/third_tab.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe_demo/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fframe_demo/constants/fonts.dart';

class SuggestionDocument extends StatefulWidget {
  const SuggestionDocument({Key? key, required this.suggestion, required this.documentReference}) : super(key: key);

  final Suggestion suggestion;
  final DocumentReference documentReference;

  @override
  State<SuggestionDocument> createState() => _SuggestionDocumentState();
}

class _SuggestionDocumentState extends State<SuggestionDocument> {
  final List<DocumentTab> documentTabs = [
    DocumentTab(
      tab: const Tab(
        text: "A Long List",
        icon: Icon(
          Icons.view_list,
        ),
      ),
      child: const FirstTab(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Placeholder",
        icon: Icon(
          Icons.settings_overscan,
        ),
      ),
      child: const SecondTab(),
    ),
    DocumentTab(
      tab: const Tab(
        text: "Ok or Not?",
        icon: Icon(
          Icons.flaky,
        ),
      ),
      child: const ThirdTab(),
    ),
  ];
  final List<ActionButton> actionButtons = [
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.close,
      ),
    ),
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.save,
      ),
    ),
    ActionButton(
      onPressed: () => {},
      icon: const Icon(
        Icons.add,
      ),
    ),
  ];

  final List<Widget> contextWidgets = const [
    ContextWidgetCard(title: "title 1 number"),
    ContextWidgetCard(title: "second"),
    ContextWidgetCard(title: "1 a 2 b 3 c 4 d"),
  ];

  @override
  Widget build(BuildContext context) {
    return ContentCanvas(
      title: widget.suggestion.name != null ? widget.suggestion.name! : 'New Sugestion',
      actionButtons: actionButtons,
      documentTabs: documentTabs,
      contextWidgets: contextWidgets,
      suggestion: widget.suggestion,
    );
  }
}

class ContentCanvas extends StatelessWidget {
  const ContentCanvas({
    Key? key,
    required this.suggestion,
    required this.title,
    required this.actionButtons,
    required this.documentTabs,
    this.contextWidgets,
  }) : super(key: key);

  final Suggestion suggestion;
  final String title;
  final List<ActionButton> actionButtons;
  final List<DocumentTab> documentTabs;
  final List<Widget>? contextWidgets;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DocumentCanvas(
            title: title,
            actionButtons: actionButtons,
            documentTabs: documentTabs,
            contextWidgets: contextWidgets,
          ),
        ),
        if (contextWidgets != null && contextWidgets!.isNotEmpty)
          SizedBox(
            width: 250,
            child: ContextCanvas(
              contextWidgets: contextWidgets!,
            ),
          ),
      ],
    );
  }
}

class DocumentCanvas extends StatelessWidget {
  const DocumentCanvas({
    Key? key,
    required this.title,
    required this.actionButtons,
    required this.documentTabs,
    this.contextWidgets,
  }) : super(key: key);

  // final Suggestion suggestion;
  final String title;
  final List<ActionButton> actionButtons;
  final List<DocumentTab> documentTabs;
  final List<Widget>? contextWidgets;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: documentTabs.length,
      child: Scaffold(
        primary: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                primary: false,
                title: DocumentTitle(title: title),
                floating: true,
                pinned: false,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                bottom: documentTabs.length != 1
                    ? TabBar(
                        tabs: documentTabs.map((documentTab) => documentTab.tab).toList(),
                      )
                    : null,
              ),
            ];
          },
          body: TabBarView(
            children: documentTabs.map((documentTab) => documentTab.child).toList(),
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: actionButtons,
        ),
      ),
    );
  }
}

class ContextCanvas extends StatelessWidget {
  const ContextCanvas({Key? key, required this.contextWidgets}) : super(key: key);
  final List<Widget> contextWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: contextWidgets!,
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentTitle extends StatelessWidget {
  const DocumentTitle({Key? key, required, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ContextWidgetCard extends StatelessWidget {
  const ContextWidgetCard({Key? key, context, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(children: [
            Text(title,
                style: TextStyle(
                  fontFamily: mainFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
            Divider(color: Theme.of(context).colorScheme.onBackground),
            Text(
              "injected widget goes here",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
