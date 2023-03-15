import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:fframe/helpers/console_logger.dart';

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
        return "${suggestion.name}";
      },

      preSave: (Suggestion suggestion) {
        //Here you can do presave stuff to the context document.
        suggestion.saveCount++;
        return suggestion;
      },

      viewType: widget.suggestionQueryState == SuggestionQueryStates.active
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
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        );
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

      query: (query) {
        // return query.where("active", isNull: true);
        switch (widget.suggestionQueryState) {
          case SuggestionQueryStates.active:
            return query.where("active", isEqualTo: true);

          case SuggestionQueryStates.done:
            return query.where("active", isEqualTo: false);
        }
      },

      autoSelectFirst: false,
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
            dataCellBuilder: ((Suggestion suggestion, Function save) =>
                DataCell(
                  Text(suggestion.name ?? "?"),
                  onTap: () => Console.log("onTap ${suggestion.name}",
                      scope: "exampleApp.Suggestions", level: LogLevel.dev),
                  placeholder: false,
                )),
          ),
          DataGridConfigColumn(
            headerBuilder: (() => const DataColumn(
                  label: Text("Active"),
                )),
            dataCellBuilder: ((Suggestion suggestion, Function save) =>
                DataCell(
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
              return Tab01(
                suggestion: suggestion,
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
            childBuilder: (suggestion, readOnly) {
              return Tab02(
                suggestion: suggestion,
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
            childBuilder: (suggestion, readOnly) {
              return Tab03(
                suggestion: suggestion,
                readOnly: readOnly,
              );
            },
          )
        ];
      },
      contextCards: [
        (suggestion) => ContextCard(
              suggestion: suggestion,
            ),
      ],
    );
  }
}

// class FormCeptionWidget extends StatelessWidget {
//   const FormCeptionWidget({
//     Key? key,
//     required this.suggestion,
//   }) : super(key: key);

//   final Suggestion suggestion;

//   @override
//   Widget build(BuildContext context) {
//     return DocumentScreen<Suggestion>(
//       collection: "suggestions/${suggestion.id}/subcollectionname",
//       fromFirestore: Suggestion.fromFirestore,
//       toFirestore: (suggestion, options) {
//         return suggestion.toFirestore();
//       },
//       createDocumentId: (suggestion) {
//         return "${suggestion.name}";
//       },
//       createNew: () => Suggestion(),

//       //Optional title widget
//       titleBuilder: (BuildContext context, Suggestion data) {
//         return Text(
//           data.name ?? "New Suggestion",
//           style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
//         );
//       },

//       // Optional, override on the query string param which holds the document id
//       // queryStringIdParam: "formception",

//       // Optional Left hand (navigation/document selection pane)
//       documentList: DocumentList(
//         builder: (context, selected, data, user) {
//           return SuggestionListItem(
//             suggestion: data,
//             selected: selected,
//             user: user,
//           );
//         },
//       ),

//       // Center part, shows a firestore doc. Tabs possible
//       document: Document<Suggestion>(
//         autoSave: false,
//         documentTabsBuilder: (context, data, isReadOnly, isNew, fFrameUser) {
//           return [
//             DocumentTab<Suggestion>(tabBuilder: (user) {
//               return const Tab(
//                 text: "Suggestion",
//                 icon: Icon(
//                   Icons.pest_control,
//                 ),
//               );
//             }, childBuilder: (suggestion, readOnly) {
//               return const Text("FormCeption");
//             })
//           ];
//         },
//       ),
//     );
//   }
// }
