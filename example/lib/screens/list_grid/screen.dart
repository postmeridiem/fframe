import 'package:fframe/helpers/console_logger.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';
import 'list_grid.dart';

enum ListGridQueryStates { active, done }

class ListGridScreen<Suggestion> extends StatefulWidget {
  const ListGridScreen({
    Key? key,
    required this.listgridQueryState,
  }) : super(key: key);
  final ListGridQueryStates listgridQueryState;

  @override
  State<ListGridScreen> createState() => _ListGridScreenState();
}

class _ListGridScreenState extends State<ListGridScreen> {
  @override
  Widget build(BuildContext context) {
    return DocumentScreen<Suggestion>(
      //Indicate where the documents are located and how to convert them to and fromt their models.
      // formKey: GlobalKey<FormState>(),
      collection: "suggestions",
      fromFirestore: Suggestion.fromFirestore,
      toFirestore: (suggestion, options) {
        return suggestion.toFirestore();
      },
      createDocumentId: (suggestion) {
        return "${suggestion.name}";
      },

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      viewType: widget.listgridQueryState == ListGridQueryStates.active
          ? ViewType.auto
          : ViewType.grid,

      createNew: () => Suggestion(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ??
            "unknown at ${DateTime.now().toLocal()}",
      ),

      //Optional title widget
      titleBuilder: (BuildContext context, Suggestion data) {
        return Text(
          data.name ?? "New Suggestion",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },

      // Optional ListGrid widget
      listGrid: ListGridConfig<Suggestion>(
        searchHint: "search suggestion names",
        // widgetBackgroundColor: Colors.amber,
        // widgetColor: Colors.pink,
        // widgetTextColor: Colors.pink,
        // widgetTextSize: 20,
        // widgetAccentColor: Colors.cyan,
        // rowBorder: 1,
        // cellBorder: 1,
        // cellPadding: const EdgeInsets.all(16),
        // cellVerticalAlignment: TableCellVerticalAlignment.top,
        // cellBackgroundColor: Colors.amber,
        // // defaultTextStyle: const TextStyle(fontSize: 16, color: Colors.amber),
        // showHeader: false,
        // // showFooter: false,
        actionBar: sampleActionMenus(),
        rowsSelectable: true,
        columnSettings: listGridColumns,
      ),

      // Center part, shows a firestore doc. Tabs possible
      document: _document(context),
      // document: _document(),
    );
  }

  Document<Suggestion> _document(BuildContext context) {
    return Document<Suggestion>(
      scrollableHeader: false,
      showCloseButton: true,
      showCopyButton: true,
      showEditToggleButton: true,
      showCreateButton: true,
      showDeleteButton: true,
      showSaveButton: true,
      showValidateButton: true,
      extraActionButtons: (context, suggestion, isReadOnly, isNew, user) {
        return [
          if (suggestion.active == false)
            TextButton.icon(
              onPressed: () {
                suggestion.active = true;
                DocumentScreenConfig.of(context)!
                    .save<Suggestion>(context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.check, color: Colors.redAccent),
              label: const Text("Mark as Active"),
            ),
          if (suggestion.active == true)
            TextButton.icon(
              onPressed: () {
                suggestion.active = false;
                DocumentScreenConfig.of(context)!
                    .save<Suggestion>(context: context, closeAfterSave: false);
              },
              icon: const Icon(Icons.close, color: Colors.greenAccent),
              label: const Text("Mark as Done"),
            ),
        ];
      },
      documentTabsBuilder:
          (context, suggestion, isReadOnly, isNew, fFrameUser) {
        return [
          DocumentTab<Suggestion>(
            tabBuilder: (user) {
              return Tab(
                text: "${suggestion.name}",
                icon: const Icon(
                  Icons.pest_control,
                ),
              );
            },
            childBuilder: (suggestion, readOnly) {
              return DocTab(
                suggestion: suggestion,
                readOnly: readOnly,
                // user: user,
              );
            },
          ),
        ];
      },
    );
  }
}

List<ListGridActionMenu<T>> sampleActionMenus<T>() {
  return [
    ListGridActionMenu(
      label: "Toggle active",
      icon: Icons.toggle_off_outlined,
      menuItems: [
        ListGridActionMenuItem(
          label: "Set inactive",
          icon: Icons.toggle_off_outlined,
          clickHandler: (context, user, selectedDocumentsById) {
            selectedDocumentsById.forEach((documentId, currentDocument) {
              // TODO: Arno, pls hlp...
              // how do I make this save using the embedded document models?
              // I can make my own connection to the backend and to a cheap write,
              // but that is not very clean.

              Suggestion currentSuggestion = currentDocument as Suggestion;
              currentSuggestion.active = false;
              currentSuggestion.toFirestore();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.toggle_off_outlined,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "Toggled ${selectedDocumentsById.length} documents to the inactive state.",
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
          clickHandler: (context, user, selectedDocumentsById) {
            selectedDocumentsById.forEach((documentId, currentDocument) {
              // Suggestion currentSuggestion = currentDocument as Suggestion;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.toggle_on,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "Toggled ${selectedDocumentsById.length} documents to the active state.",
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
          label: "Delete",
          icon: Icons.delete_outline,
          clickHandler: (context, user, selectedDocumentsById) {
            selectedDocumentsById.forEach((documentId, currentSuggestion) {
              Console.log(
                "NOT deleting ${currentSuggestion.name}. Jus' printing this.",
                scope: "exampleApp.ListGrid.deleteAction",
                level: LogLevel.prod,
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "NOT deleting ${selectedDocumentsById.length} documents... Jus' giving you this snack.",
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
          clickHandler: (context, user, selectedDocumentsById) {
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
