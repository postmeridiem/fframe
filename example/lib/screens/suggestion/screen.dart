// ignore_for_file: unnecessary_import, unnecessary_null_comparison, use_super_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:example/services/suggestion_service.dart';
import 'package:example/models/suggestion.dart';
import 'suggestion.dart';

enum SuggestionQueryStates { active, done }

class SuggestionScreen<Suggestion> extends StatefulWidget {
  const SuggestionScreen({
    Key? key,
    required this.suggestionQueryState,
  }) : super(key: key);
  final SuggestionQueryStates suggestionQueryState;

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
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
        return suggestion.name;
      },

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      preOpen: (Suggestion suggestion) {
        //Here you can do pre open stuff to the context document.
        return suggestion;
      },

      viewType: widget.suggestionQueryState == SuggestionQueryStates.active ? ViewType.auto : ViewType.grid,

      createNew: () => Suggestion(
        active: true,
        createdBy: FirebaseAuth.instance.currentUser?.displayName ?? "unknown at ${DateTime.now().toLocal()}",
      ),

      // string containing a document title for display purposes
      documentTitle: (BuildContext context, Suggestion data) {
        return data.name ?? "New Suggestion";
      },

      //Optional title widget
      // headerBuilder: (BuildContext context, String documentTitle, Suggestion data) {
      //   return Text(
      //     documentTitle,
      //     style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      //   );
      // },

      query: (query) {
        // return query.where("active", isNull: true);
        switch (widget.suggestionQueryState) {
          case SuggestionQueryStates.active:
            return query.where("active", isEqualTo: true);

          case SuggestionQueryStates.done:
            return query.where("active", isEqualTo: false);
        }
      },

      // query: (Query<Suggestion> query) {
      //   return query.where("active", isEqualTo: null);
      // },

      // documentScreenHeaderBuilder: () => const SizedBox(
      //   height: 40,
      //   child: Placeholder(
      //     child: Center(
      //       child: Text("DocumentScreenHeaderBuilder"),
      //     ),
      //   ),
      // ),

      // documentScreenFooterBuilder: () => const SizedBox(
      //   height: 40,
      //   child: Placeholder(
      //     child: Center(
      //       child: Text("DocumentScreenFooterBuilder"),
      //     ),
      //   ),
      // ),

      // Optional, override on the query string param which holds the document id
      // queryStringIdParam: "docId",

      // searchConfig: SearchConfig(
      //   defaultField: "name",
      //   searchOptions: [
      //     SearchOption(
      //       caption: "Name",
      //       field: "name",
      //       type: SearchOptionType.string,
      //       sort: SearchOptionSortOrder.asc,
      //     ),
      //     SearchOption(
      //       caption: "Author",
      //       field: "createdBy",
      //       type: SearchOptionType.string,
      //     ),
      //     SearchOption(
      //       caption: "Creation date",
      //       field: "creationDate",
      //       type: SearchOptionType.datetime,
      //       comparisonOperator: SearchOptionComparisonOperator.greater,
      //     ),
      //     SearchOption(
      //       caption: "Active",
      //       field: "active",
      //       type: SearchOptionType.boolean,
      //     ),
      //   ],
      // ),

      // Optional Left hand (navigation/document selection pane)
      documentList: DocumentList(
        footerBuilder: (context, documentCount) {
          return Column(
            children: [
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Listing $documentCount items"),
              ),
            ],
          );
        },
        builder: (context, selected, data, user) {
          return SuggestionListItem(
            suggestion: data,
            selected: selected,
            user: user,
          );
        },
        // showCreateButton: true,

        hoverSelect: false,
        // headerBuilder: ((context, snapshot) {
        //   return const SizedBox(
        //     height: 40,
        //     child: Placeholder(
        //       child: Center(
        //         child: Text("DocumentListHeaderBuilder"),
        //       ),
        //     ),
        //   );
        // }),
        // footerBuilder: ((context, snapshot) {
        //   return SizedBox(
        //     height: 40,
        //     child: Placeholder(
        //       child: Center(
        //         child: Text("${snapshot.docs.length} of ${snapshot.hasMore ? "many" : snapshot.docs.length}"),
        //       ),
        //     ),
        //   );
        // }),
      ),

      dataGrid: DataGridConfig<Suggestion>(
        rowsPerPage: 30,
        // rowHeight: 200,
        dataGridConfigColumns: [
          DataGridConfigColumn(
            headerBuilder: (() => const DataColumn(
                  label: Text("Name"),
                )),
            dataCellBuilder: ((Suggestion suggestion, Function save) => DataCell(
                  Text(suggestion.name ?? "?"),
                  onTap: () => Console.log("onTap ${suggestion.name}", scope: "exampleApp.Suggestions", level: LogLevel.dev),
                  placeholder: false,
                )),
          ),
          DataGridConfigColumn(
            headerBuilder: (() => const DataColumn(
                  label: Text("Active"),
                )),
            dataCellBuilder: ((Suggestion suggestion, Function save) => DataCell(
                  Switch(
                    value: (suggestion.active ?? false),
                    onChanged: (bool value) {
                      suggestion.active = value;
                      save();
                      // DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
                    },
                  ),
                )),
          ),
        ],
      ),
      // Center part, shows a firestore doc. Tabs possible
      document: suggestionDocument(),
    );
  }
}

Document<Suggestion> suggestionDocument() {
  return Document<Suggestion>(
    scrollableHeader: false,
    showCloseButton: true,
    showCopyButton: true,
    showEditToggleButton: true,
    showCreateButton: true,
    showDeleteButton: true,
    showSaveButton: true,
    showValidateButton: true,
    extraActionButtons: (context, selectedDocument, isReadOnly, isNew, user) {
      return [
        if (selectedDocument.data.active == false)
          TextButton.icon(
            onPressed: () {
              selectedDocument.data.active = true;
              selectedDocument.save(context: context);
            },
            icon: const Icon(Icons.check, color: Colors.redAccent),
            label: const Text("Mark as Active"),
          ),
        if (selectedDocument.data.active == true)
          TextButton.icon(
            onPressed: () {
              selectedDocument.data.active = false;
              selectedDocument.save(context: context);
            },
            icon: const Icon(Icons.close, color: Colors.greenAccent),
            label: Text(
              "Mark as Done",
              style: TextStyle(
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
        if (user != null && user.hasRole("firestoreaccess"))
          IconButton(
            tooltip: "Open Firestore Document",
            onPressed: () {
              String domain = "https://console.cloud.google.com";
              String application = "firestore/databases/-default-/data/panel";
              String collection = "suggestions";
              String docId = selectedDocument.data.id ?? "";
              String gcpProject = Fframe.of(context)!.firebaseOptions.projectId;
              Uri url = Uri.parse("$domain/$application/$collection/$docId?&project=$gcpProject");
              launchUrl(url);
            },
            icon: Icon(
              Icons.table_chart_outlined,
              color: Theme.of(context).indicatorColor,
            ),
          ),
      ];
    },
    documentTabsBuilder: (context, suggestion, isReadOnly, isNew, fFrameUser) {
      return [
        if (fFrameUser!.hasRole('user') || fFrameUser.hasRole('fietsbel'))
          DocumentTab<Suggestion>(
            tabBuilder: (user) {
              return Tab(
                text: "${suggestion.name}",
                icon: const Icon(
                  Icons.pest_control,
                ),
              );
            },
            childBuilder: (selectedDocument, readOnly) {
              return Tab01(
                suggestion: selectedDocument.data,
                readOnly: readOnly,
                // user: user,
              );
            },
          ),
        DocumentTab<Suggestion>(
          tabBuilder: (user) {
            return const Tab(
              text: "Placeholder",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (selectedDocument, readOnly) {
            return Tab02(
              suggestion: selectedDocument.data,
              readOnly: readOnly,
            );
          },
        ),
        DocumentTab<Suggestion>(
          tabBuilder: (user) {
            return const Tab(
              text: "Ok or Not?",
              icon: Icon(
                Icons.settings_overscan,
              ),
            );
          },
          childBuilder: (selectedDocument, readOnly) {
            return Tab03(
              suggestion: selectedDocument.data,
              readOnly: readOnly,
            );
          },
        ),
      ];
    },
    contextCards: [
      (suggestion) => ContextCard(
            suggestion: suggestion,
          ),
    ],
  );
}
