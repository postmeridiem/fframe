import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';

// import 'package:example/services/page_service.dart';
import 'package:example/models/fframe_page.dart';
import 'tabloader.dart';

enum TabloaderQueryStates { active, done }

class TabloaderScreen<Tabloader> extends StatefulWidget {
  const TabloaderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TabloaderScreen> createState() => _TabloaderScreenState();
}

class _TabloaderScreenState extends State<TabloaderScreen> {
  @override
  Widget build(BuildContext context) {
    return DocumentScreen<FframePage>(
      //Indicate where the documents are located and how to convert them to and fromt their models.
      // formKey: GlobalKey<FormState>(),
      collection: "fframe/pages/collection",
      fromFirestore: FframePage.fromFirestore,
      toFirestore: (page, options) {
        return page.toFirestore();
      },
      createDocumentId: (page) {
        return "${page.name}";
      },
      createNew: () {
        return FframePage();
      },

      preSave: (FframePage page) {
        //Here you can do presave stuff to the context document.
        page.saveCount++;
        return page;
      },

      //Optional title widget
      titleBuilder: (BuildContext context, FframePage data) {
        return Text(
          data.name ?? "New Tabloader",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
      },

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        showCreateButton: false,
        builder: (context, selected, data, user) {
          return PageListItem(
            page: data,
            selected: selected,
            user: user,
          );
        },
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: _document(context),
      // document: _document(),
    );
  }

  Document<FframePage> _document(BuildContext context) {
    return Document<FframePage>(
      showSaveButton: false,
      showCloseButton: false,
      prefetchTabs: false,
      documentTabsBuilder: (context, page, isReadOnly, isNew, fFrameUser) {
        return [
          DocumentTab<FframePage>(
            tabBuilder: (user) {
              return const Tab(
                text: "TAB 1",
              );
            },
            childBuilder: (page, readOnly) {
              return Tab01(
                page: page,
                readOnly: readOnly,
                // user: user,
              );
            },
          ),
          DocumentTab<FframePage>(
            tabBuilder: (user) {
              return const Tab(
                text: "TAB 2",
              );
            },
            childBuilder: (page, readOnly) {
              return Tab02(
                page: page,
                readOnly: readOnly,
              );
            },
          ),
          DocumentTab<FframePage>(
            tabBuilder: (user) {
              return const Tab(
                text: "TAB 3",
              );
            },
            childBuilder: (page, readOnly) {
              return Tab03(
                page: page,
                readOnly: readOnly,
              );
            },
          )
        ];
      },
    );
  }
}
