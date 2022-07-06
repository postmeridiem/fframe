import 'package:flutter/material.dart';

class SearchConfig {
  final List<SearchOption> searchOptions;

  SearchConfig({required this.searchOptions});
}

class SearchOption {
  final String caption;
  final String field;
  final SearchOptionType type;
  late String stringValue = "";
  late bool boolValue = true;
  late DateTime dateTimeValue = DateTime.now();
  SearchOption({required this.caption, required this.field, required this.type});
}

enum SearchOptionType {
  string,
  boolean,
  datetime,
}

class DocumentSearch<T> extends StatefulWidget {
  const DocumentSearch({Key? key}) : super(key: key);

  @override
  State<DocumentSearch> createState() => _DocumentSearchState<T>();
}

class _DocumentSearchState<T> extends State<DocumentSearch> {
  final SearchConfig searchConfig = SearchConfig(searchOptions: [
    SearchOption(caption: "Author", field: "createdBy", type: SearchOptionType.string),
    SearchOption(caption: "Name", field: "name", type: SearchOptionType.string),
    SearchOption(caption: "Creation date", field: "creationDate", type: SearchOptionType.datetime),
    SearchOption(caption: "Active", field: "active", type: SearchOptionType.boolean),
  ]);

  List<SearchOption> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<SearchOption>(
      // displayStringForOption: ((option) => option.caption),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable.empty();
        }
        final Iterable<SearchOption> searchOptions = searchConfig.searchOptions.where(
          (SearchOption searchOption) {
            return searchOption.caption.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
          },
        );
        return searchOptions;
      },
      optionsViewBuilder: (
        BuildContext context,
        void Function(SearchOption) onSelected,
        Iterable<SearchOption> searchOptions,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
                width: 300,
                child: Wrap(
                  children: searchOptions.map((SearchOption searchOption) {
                    return GestureDetector(
                      onTap: () {
                        onSelected(searchOption);
                      },
                      child: Chip(
                        label: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(searchOption.caption),
                        ),
                      ),
                    );
                  }).toList(),
                )),
          ),
        );
      },
      fieldViewBuilder: (BuildContext buildContext, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = "";
        return Wrap(
          children: [
            ...selectedOptions.map((SearchOption searchOption) {
              // Widget chipContent;
              switch (searchOption.type) {
                case SearchOptionType.string:
                  return InputChip(
                    label: Row(
                      children: [
                        Text(searchOption.caption),
                        const Padding(
                          padding: EdgeInsets.only(left: 1, right: 4),
                          child: Text(":"),
                        ),
                        const Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 12.0),
                          ),
                        )
                      ],
                    ),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        selectedOptions.remove(searchOption);
                      });
                    },
                  );
                case SearchOptionType.boolean:
                  return ChoiceChip(
                    label: Row(
                      children: [
                        Text(searchOption.caption),
                        const Padding(
                          padding: EdgeInsets.only(left: 1, right: 4),
                          child: Text(":"),
                        ),
                        Text("${searchOption.boolValue}"),
                      ],
                    ),
                    selected: searchOption.boolValue,
                    onSelected: (bool selected) {
                      setState(() {
                        searchOption.boolValue = selected;
                      });
                    },
                  );

                // deleteIcon: const Icon(Icons.close),
                // onDeleted: () {
                //   setState(() {
                //     selectedOptions.remove(searchOption);
                //   });
                // },

                // chipContent = Switch(
                //   value: searchOption.boolValue,
                //   onChanged: (bool newValue) {
                //     setState(() {
                //       searchOption.boolValue = newValue;
                //     });
                //   },
                // );

                case SearchOptionType.datetime:
                  return Chip(
                    label: Row(
                      children: [
                        Text(searchOption.caption),
                        const Padding(
                          padding: EdgeInsets.only(left: 1, right: 4),
                          child: Text(":"),
                        ),
                        const Text("TODO"),
                      ],
                    ),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        selectedOptions.remove(searchOption);
                      });
                    },
                  );
              }

              // return Chip(
              //   label: Row(
              //     children: [
              //       Text(searchOption.caption),
              //       const Padding(
              //         padding: EdgeInsets.only(left: 1, right: 4),
              //         child: Text(":"),
              //       ),
              //       chipContent
              //     ],
              //   ),
              //   deleteIcon: const Icon(Icons.close),
              //   onDeleted: () {
              //     setState(() {
              //       selectedOptions.remove(searchOption);
              //     });
              //   },
              // );
            }),
            TextField(
              focusNode: fieldFocusNode,
              controller: fieldTextEditingController,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
      onSelected: (SearchOption searchOption) {
        setState(() {
          selectedOptions.add(searchOption);
        });
      },
    );
  }
}

// class SearchOptionSelector extends StatelessWidget {
//   const SearchOptionSelector({Key? key, required this.searchOption}) : super(key: key);
//   final SearchOption searchOption;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Chip(
//         label: Text(searchOption.caption),
//       ),
//     );
//   }
// }
