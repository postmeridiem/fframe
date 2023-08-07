import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

List<ListGridActionMenu<Suggestion>> listgridActionMenu<Suggestion>() {
  return [
    ListGridActionMenu<Suggestion>(
      label: "Create new...",
      icon: Icons.new_label,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
            label: "Create new...",
            icon: Icons.new_label,
            requireSelection: false,
            clickHandler: <Suggestion>(
              BuildContext context,
              FFrameUser? user,
              List<SelectedDocument> selectedDocuments,
              Function createDocument,
            ) {
              createDocument();
              // debugPrint("clickHandler with type $T");
              // selectedDocuments.forEach((documentId, currentDocument)
              // debugPrint("now do create");

              // DocumentScreenConfig documentScreenConfig =
              //     DocumentScreenConfig.of(context) as DocumentScreenConfig;
              // // DocumentConfig<T> documentConfig =
              // //     documentScreenConfig.documentConfig as DocumentConfig<T>;
              // documentScreenConfig.create<Suggestion>(context: context);

              // T newDocument = documentConfig.createNew();
              // T newDocument = documentScreenConfig.create();

              // QueryDocumentSnapshot howToGetHere;
              // documentScreenConfig.selectDocument(context, howToGetHere);

              //ToDo: Show new document on interface

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: ListTile(
                    leading: Icon(
                      Icons.toggle_off_outlined,
                      color: Colors.amber[900],
                    ),
                    title: Text(
                      "You clicked new $Suggestion",
                    ),
                    textColor: Colors.amber[900],
                  ),
                ),
              );
            }),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      label: "Toggle active",
      icon: Icons.toggle_off_outlined,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Set inactive",
          icon: Icons.toggle_off_outlined,
          clickHandler: <Suggestion>(
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument<Suggestion>> selectedDocuments,
            Function createDocument,
          ) {
            List<SelectedDocument<Suggestion>> curSet = selectedDocuments;
            curSet.map((selectedDocument) {
              Suggestion suggestion = selectedDocument.document;
              debugPrint("${suggestion}");

              // DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context) as DocumentScreenConfig;
              // DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;
              // // TODO: Arno, pls hlp...
              // // how do I make this save using the embedded document models?
              // // I can make my own connection to the backend and to a cheap write,
              // // but that is not very clean.

              // Suggestion currentSuggestion = currentDocument as Suggestion;
              // currentSuggestion.active = false;
              // documentConfig.toFirestore(currentDocument, SetOptions(merge: true));
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.toggle_off_outlined,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "Toggled ${selectedDocuments.length} documents to the inactive state.",
                  ),
                  textColor: Colors.amber[900],
                ),
              ),
            );
          },
        ),
        ListGridActionMenuItem<Suggestion>(
          label: "Set active",
          icon: Icons.toggle_on,
          clickHandler: <Suggestion>(
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            selectedDocuments.map((SelectedDocument selectedDocument) {
              // Suggestion suggestion = selectedDocument.document as Suggestion;
              // suggestion!.active = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.toggle_on,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "Toggled ${selectedDocuments.length} documents to the active state.",
                  ),
                  textColor: Colors.amber[900],
                ),
              ),
            );
          },
        ),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Delete",
          icon: Icons.delete_outline,
          clickHandler: <Suggestion>(
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            selectedDocuments.map((selectedDocument) {
              debugPrint(
                  "NOT deleting ${selectedDocument.document.name}. Jus' printing this.");
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "NOT deleting ${selectedDocuments.length} documents... Jus' giving you this snack.",
                  ),
                  textColor: Colors.amber[900],
                ),
              ),
            );
          },
        ),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Help...",
          icon: Icons.help_outline,
          requireSelection: false,
          clickHandler: (
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            launchUrl(
              Uri.parse(
                  'https://github.com/postmeridiem/fframe/blob/main/fframe/lib/screens/listgrid_screen/listgrid.md'),
              webOnlyWindowName: "_blank",
            );
          },
        ),
      ],
    ),
  ];
}
