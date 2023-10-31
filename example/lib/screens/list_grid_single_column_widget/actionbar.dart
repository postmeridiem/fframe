import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

// import 'package:example/models/suggestion.dart';

List<ListGridActionMenu<Suggestion>> listgridActionMenu<Suggestion>() {
  return [
    ListGridActionMenu(
      label: "Create new...",
      icon: Icons.new_label,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Create new...",
          icon: Icons.playlist_add_outlined,
          requireSelection: false,
          clickHandler: (
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            createDocument();

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
          },
        ),
      ],
    ),
    ListGridActionMenu(
      label: "Toggle active",
      icon: Icons.toggle_off_outlined,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Set inactive",
          icon: Icons.toggle_off_outlined,
          clickHandler: (
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            selectedDocuments.map((selectedDocument) {
              // DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context) as DocumentScreenConfig;
              // DocumentConfig<Suggestion> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<Suggestion>;
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
        ListGridActionMenuItem(
          label: "Set Active",
          icon: Icons.toggle_on,
          clickHandler: (
            BuildContext context,
            FFrameUser? user,
            List<SelectedDocument> selectedDocuments,
            Function createDocument,
          ) {
            selectedDocuments.map((selectedDocument) {
              Suggestion currentDocument =
                  selectedDocument.document as Suggestion;
              // currentDocument.active = false;
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
    ListGridActionMenu(
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Delete",
          icon: Icons.delete_outline,
          clickHandler: (
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
    ListGridActionMenu(
      menuItems: [
        ListGridActionMenuItem(
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
