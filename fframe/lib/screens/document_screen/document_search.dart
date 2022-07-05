import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocSearch extends SearchDelegate<String> {
  DocSearch({required this.contextPage});

  BuildContext contextPage;
  // late WebViewController controller;
  final _suggestions = ["suggestions"];

  @override
  String get searchFieldLabel => "Enter a web address";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // close(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return context.widget;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? _suggestions : [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => ListTile(leading: const Icon(Icons.arrow_left), title: Text(suggestions[index])),
    );
  }
}

// class DocSearch extends ConsumerStatefulWidget {
//   const DocSearch({
//     Key? key,
//     this.child,
//   }) : super(key: key);
//   final Widget? child;
//   @override
//   ConsumerState<DocSearch> createState() => _DocSearchState();
// }

// class _DocSearchState extends ConsumerState<DocSearch> {
//   // any text input originating from the query field ends up here
//   // should somehow get provided to the fframe user in the screen.dart
//   // so they can use it in the query builder. Will try applying a double where()
//   // to apply before it even gets there.
//   Map<String, Map> docListQuerySelections = {};
//   late Map<String, Map> docListQueryOptions = {
//     "active": {"query": "true", "selected": false, "removable": false},
//     "email": {"query": "me@jsc.im", "selected": false, "removable": true},
//     "name": {"query": "Jeroen Schweitzer", "selected": true, "removable": true},
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.secondary,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           queryChips(),
//           // DropdownButtonHideUnderline(
//           //   child: DropdownButton<String>(
//           //     hint: Text("Start typing"),
//           //     value: "",
//           //     items: [
//           //       const DropdownMenuItem<String>(
//           //         value: "1111",
//           //         child: Text("1:"),
//           //       ),
//           //       const DropdownMenuItem<String>(
//           //         value: "2222",
//           //         child: Text("2:"),
//           //       ),
//           //       // ...docListQueryOptions.entries
//           //       //     .map((MapEntry<String, Map<dynamic, dynamic>> entry) => DropdownMenuItem<String>(
//           //       //           value: entry.key,
//           //       //           child: Text(entry.key),
//           //       //         ))
//           //       //     .toList(),
//           //     ],
//           //     onChanged: (value) {},
//           //   ),
//           // ),
//           TextField(
//             autofillHints: docListQueryOptions.entries.map((MapEntry<String, Map<dynamic, dynamic>> entry) => "${entry.key}:").toList(),
//             textInputAction: TextInputAction.newline,
//             onChanged: (String query) {
//               if (query.substring((query.length - 1).clamp(0, query.length)) == ":") {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       L10n.string(
//                         'doclistsearch_filterchiptip',
//                         placeholder: "TIP: Hit enter after typing ':' to create a filter chip...",
//                       ),
//                     ),
//                   ),
//                 );
//               }
//               docListQueryOptions["q"]!["query"] = query;
//             },
//             onSubmitted: (String query) {
//               if (query.contains(":")) {
//                 docListQueryOptions["q"]!["query"] = "";
//                 Map<String, dynamic> newChip = {
//                   "query": "true",
//                   "selected": false,
//                   "removable": true,
//                 };

//                 List queryList = query.split(":");
//                 String chipKey = queryList[0];
//                 newChip["query"] = queryList[1];
//                 docListQueryOptions[chipKey] = newChip;
//                 // if user types a : here, it should auto chip
//                 // put some trottling in: only one chip at a time
//                 // so we don't overload the firestore index?
//               }

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Search not implemented yet..."),
//                 ),
//               );
//               debugPrint("$docListQueryOptions");
//             },
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
//               prefixIcon: Icon(Icons.search),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   queryChips() {
//     List<Widget> chips = [];

//     docListQuerySelections.forEach(
//       (key, value) {
//         if (key != "q") {
//           debugPrint("Chip created for $key: ${value["query"]}");
//           chips.add(
//             Padding(
//               padding: const EdgeInsets.only(top: 2, bottom: 1),
//               child: InputChip(
//                 label: RichText(
//                   text: TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: "$key: ",
//                         style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onBackground),
//                       ),
//                       TextSpan(
//                         text: value["query"],
//                         style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
//                       ),
//                     ],
//                   ),
//                 ),
//                 backgroundColor: Theme.of(context).colorScheme.background,
//                 selected: docListQueryOptions[key]!["selected"],
//                 onSelected: (bool selected) {
//                   // TODO: figure out why this does not work.
//                   docListQueryOptions[key]!["selected"] = selected;
//                   debugPrint("$docListQueryOptions");
//                 },
//                 onDeleted: docListQueryOptions[key]!["removable"] ? () {} : null,
//               ),
//             ),
//           );
//         }
//       },
//     );
//     return Padding(
//       padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
//       child: Wrap(children: chips),
//     );
//   }
// }
