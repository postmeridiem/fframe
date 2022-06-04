import 'package:fframe/helpers/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocSearch extends ConsumerStatefulWidget {
  const DocSearch({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;
  @override
  // _BottomNavBarV2State createState() => _BottomNavBarV2State();
  ConsumerState<DocSearch> createState() => _DocSearchState();
}

class _DocSearchState extends ConsumerState<DocSearch> {
  // any text input originating from the query field ends up here
  // should somehow get provided to the fframe user in the screen.dart
  // so they can use it in the query builder. Will try applying a double where()
  // to apply before it even gets there.
  late Map<String, Map> doclistqueries = {
    "q": {"query": "", "selected": true, "removable": false},
    // "active": {"query": "true", "selected": false, "removable": false},
    // "email": {"query": "me@jsc.im", "selected": false, "removable": true},
    // "name": {"query": "Jeroen Schweitzer", "selected": true, "removable": true},
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          queryChips(),
          TextField(
            autofocus: true,
            onChanged: (String query) {
              if (query.substring((query.length - 1).clamp(0, query.length)) ==
                  ":") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      L10n.string(
                        'doclistsearch_filterchiptip',
                        placeholder:
                            "TIP: Hit enter after typing ':' to create a filter chip...",
                      ),
                    ),
                  ),
                );
              }
              doclistqueries["q"]!["query"] = query;
            },
            onSubmitted: (String query) {
              if (query.contains(":")) {
                doclistqueries["q"]!["query"] = "";
                Map<String, dynamic> newChip = {
                  "query": "true",
                  "selected": false,
                  "removable": true,
                };

                List queryList = query.split(":");
                String chipKey = queryList[0];
                newChip["query"] = queryList[1];
                doclistqueries[chipKey] = newChip;
                // if user types a : here, it should auto chip
                // put some trottling in: only one chip at a time
                // so we don't overload the firestore index?
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Search not implemented yet..."),
                ),
              );
              debugPrint("$doclistqueries");
            },
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  queryChips() {
    List<Widget> chips = [];

    doclistqueries.forEach(
      (key, value) {
        if (key != "q") {
          debugPrint("Chip created for $key: ${value["query"]}");
          chips.add(
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 1),
              child: InputChip(
                label: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "$key: ",
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      TextSpan(
                        text: value["query"],
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                selected: doclistqueries[key]!["selected"],
                onSelected: (bool selected) {
                  // TODO: figure out why this does not work.
                  doclistqueries[key]!["selected"] = selected;
                  debugPrint("$doclistqueries");
                },
                onDeleted: doclistqueries[key]!["removable"] ? () {} : null,
              ),
            ),
          );
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
      child: Wrap(children: chips),
    );
  }
}
