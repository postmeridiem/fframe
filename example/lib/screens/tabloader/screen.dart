import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

// import 'package:example/services/page_service.dart';
import 'package:example/models/fframe_page.dart';
import 'tabloader.dart';

enum TabloaderQueryStates { active, done }

class TabloaderScreen<Tabloader> extends StatefulWidget {
  const TabloaderScreen({
    super.key,
  });

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

      documentTitle: (BuildContext context, FframePage data) {
        return data.name ?? "New Tabloader";
      },

      //Optional title widget
      headerBuilder: (BuildContext context, String documentTitle, FframePage data) {
        return Text(
          documentTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
      document: tabLoaderDocument(context),
    );
  }
}

Document<FframePage> tabLoaderDocument(BuildContext context) {
  return Document<FframePage>(
    showSaveButton: false,
    showCloseButton: false,
    prefetchTabs: false,
    withEndDrawer: false,
    documentTabsBuilder: (context, page, isReadOnly, isNew, fFrameUser) {
      return [
        DocumentTab<FframePage>(
          tabBuilder: (user) {
            return const Tab(
              text: "TAB 1",
            );
          },
          childBuilder: (selectedDocument, readOnly) {
            return Tab01(
              page: selectedDocument.data,
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
          childBuilder: (selectedDocument, readOnly) {
            return Tab02(
              page: selectedDocument.data,
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
          childBuilder: (selectedDocument, readOnly) {
            return Tab03(
              page: selectedDocument.data,
              readOnly: readOnly,
            );
          },
        )
      ];
    },
  );
}
