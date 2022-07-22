import 'package:intl/intl.dart';

import 'package:fframe/controllers/query_state_controller.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

class DocumentSearch<T> extends StatefulWidget {
  const DocumentSearch({Key? key}) : super(key: key);

  @override
  State<DocumentSearch> createState() => _DocumentSearchState<T>();
}

class _DocumentSearchState<T> extends State<DocumentSearch> {
  List<SearchOption> selectedOptions = [];
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DocumentScreenConfig documentScreenConfig = DocumentScreenConfig.of(context)!;
    DocumentConfig<T> documentConfig = documentScreenConfig.documentConfig as DocumentConfig<T>;
    SearchConfig<T>? searchConfig = documentConfig.searchConfig;
    FireStoreQueryState<T> fireStoreQueryState = DocumentScreenConfig.of(context)?.fireStoreQueryState as FireStoreQueryState<T>;

    if (searchConfig == null) {
      return const IgnorePointer();
    }

    return Autocomplete<SearchOption>(
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
        searchConfig.optionMap = mapConfigs(searchOptions);
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
      fieldViewBuilder: (
        BuildContext buildContext,
        TextEditingController autocompleteController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        autocompleteController.text = "";
        return Wrap(
          children: [
            ...selectedOptions.map((SearchOption searchOption) {
              // Widget chipContent;
              switch (searchOption.type) {
                case SearchOptionType.string:
                  if (searchOption.isSelected) {
                    TextEditingController chipController = TextEditingController();
                    chipController.text = searchOption.stringValue;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InputChip(
                        label: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Text(
                                searchOption.caption,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1, right: 4),
                              child: Text(":"),
                            ),
                            Expanded(
                              child: TextField(
                                controller: chipController,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                                focusNode: focusNode,
                                onChanged: (String fieldValue) {
                                  fireStoreQueryState.removeQueryComponent(
                                    id: 'autocomplete',
                                  );
                                  if (fieldValue != '') {
                                    fireStoreQueryState.addQueryComponent(
                                      id: searchOption.field,
                                      queryComponent: (Query<T> query) {
                                        return query.where(searchOption.field, isGreaterThanOrEqualTo: fieldValue).where(searchOption.field, isLessThanOrEqualTo: fieldValue + '~');
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      fireStoreQueryState.removeQueryComponent(
                                        id: searchOption.field,
                                      );
                                    });
                                  }
                                },
                                onSubmitted: (String fieldValue) {
                                  setState(() {
                                    searchOption.stringValue = fieldValue;
                                    searchOption.isSelected = false;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        deleteIcon: const Icon(Icons.close, size: 10),
                        onDeleted: () {
                          setState(() {
                            searchOption.stringValue = '';
                            fireStoreQueryState.removeQueryComponent(id: searchOption.field);
                            selectedOptions.remove(searchOption);
                          });
                        },
                        isEnabled: searchOption.isSelected,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ActionChip(
                        label: Row(
                          children: [
                            Text(
                              searchOption.caption,
                              style: const TextStyle(fontSize: 10),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1, right: 4),
                              child: Text(
                                ":",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Text(
                              searchOption.stringValue,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            searchOption.isSelected = true;
                          });
                        },
                      ),
                    );
                  }
                case SearchOptionType.boolean:
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: InputChip(
                      label: Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                        child: Row(
                          children: [
                            Text(
                              searchOption.caption,
                              style: const TextStyle(fontSize: 10),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1, right: 4),
                              child: Text(":"),
                            ),
                            Switch(
                              value: searchOption.boolValue,
                              onChanged: (bool selected) {
                                setState(() {
                                  searchOption.boolValue = selected;
                                  fireStoreQueryState.addQueryComponent(
                                    id: searchOption.field,
                                    queryComponent: (Query<T> query) {
                                      return query.where(searchOption.field, isEqualTo: selected);
                                    },
                                  );
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 10),
                      onDeleted: () {
                        setState(() {
                          fireStoreQueryState.removeQueryComponent(id: searchOption.field);
                          selectedOptions.remove(searchOption);
                        });
                      },
                      isEnabled: searchOption.isSelected,
                    ),
                  );

                case SearchOptionType.user:
                case SearchOptionType.int:
                case SearchOptionType.datetime:
                case SearchOptionType.date:
                case SearchOptionType.time:
                  Icon _selectedOperatorIcon;
                  switch (searchOption.comparisonOperator) {
                    case SearchOptionComparisonOperator.lesser:
                      _selectedOperatorIcon = const Icon(Icons.chevron_left);
                      break;
                    case SearchOptionComparisonOperator.greater:
                      _selectedOperatorIcon = const Icon(Icons.chevron_right);
                      break;
                    case SearchOptionComparisonOperator.equal:
                      _selectedOperatorIcon = const Icon(Icons.drag_handle);
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: InputChip(
                      label: Row(
                        children: [
                          Text(
                            searchOption.caption,
                            style: const TextStyle(fontSize: 10),
                          ),
                          _selectedOperatorIcon,
                          // SizedBox(
                          //   child: IconButton(
                          //     onPressed: () {},
                          //     icon: _selectedOperatorIcon,
                          //   ),
                          // ),
                          // PopupMenuButton<SearchOptionComparisonOperator>(
                          //   // Callback that sets the selected popup menu item.
                          //   onSelected:
                          //       (SearchOptionComparisonOperator operator) {
                          //     setState(() {
                          //       searchOption.comparisonOperator = operator;
                          //     });
                          //   },
                          //   splashRadius: 1,
                          //   icon: _selectedOperatorIcon,
                          //   itemBuilder: (BuildContext context) => <
                          //       PopupMenuEntry<SearchOptionComparisonOperator>>[
                          //     PopupMenuItem<SearchOptionComparisonOperator>(
                          //       value: SearchOptionComparisonOperator.lesser,
                          //       child: Row(
                          //         children: [
                          //           const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Icon(Icons.chevron_left),
                          //           ),
                          //           Text(
                          //             L10n.string(
                          //               "doclistsearch_lesser",
                          //               placeholder: "less than",
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     PopupMenuItem<SearchOptionComparisonOperator>(
                          //       value: SearchOptionComparisonOperator.greater,
                          //       child: Row(
                          //         children: [
                          //           const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Icon(Icons.chevron_right),
                          //           ),
                          //           Text(
                          //             L10n.string(
                          //               "doclistsearch_greater",
                          //               placeholder: "greater than",
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     PopupMenuItem<SearchOptionComparisonOperator>(
                          //       value: SearchOptionComparisonOperator.equal,
                          //       child: Row(
                          //         children: [
                          //           const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Icon(Icons.drag_handle),
                          //           ),
                          //           Text(
                          //             L10n.string(
                          //               "doclistsearch_equal",
                          //               placeholder: "equal to",
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                              focusNode: focusNode,
                              initialValue: DateFormat('yyyy-MM-dd').format(searchOption.dateTimeValue),
                              onChanged: (String fieldValue) {
                                fireStoreQueryState.addQueryComponent(
                                  id: searchOption.field,
                                  queryComponent: (Query<T> query) {
                                    return query.where(searchOption.field, isEqualTo: fieldValue);
                                  },
                                );
                              },
                              // decoration: const InputDecoration(
                              //   contentPadding: EdgeInsets.only(
                              //       left: 12, top: 0, right: 12, bottom: 0),
                              // ),
                            ),
                            // child: InputDatePickerFormField(
                            //   firstDate: DateTime(2020),
                            //   lastDate: DateTime(2030, 12, 12),
                            //   initialDate: searchOption.dateTimeValue,
                            //   onDateSubmitted: (date) {
                            //     setState(() {
                            //       searchOption.dateTimeValue = date;
                            //     });
                            //   },
                            // ),
                          ),
                        ],
                      ),
                      deleteIcon: const Icon(Icons.close, size: 10),
                      onDeleted: () {
                        setState(() {
                          selectedOptions.remove(searchOption);
                        });
                      },
                      isEnabled: searchOption.isSelected,
                    ),
                  );
              }
            }),
            TextField(
              focusNode: fieldFocusNode,
              controller: autocompleteController,
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                // suffixIcon: IconButton(
                //   onPressed: fireStoreQueryState.reset,
                //   icon: const Icon(Icons.clear),
                // ),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
              onChanged: (String fieldValue) {
                if (fieldValue != '') {
                  if (fieldValue.substring((fieldValue.length - 1).clamp(0, fieldValue.length)) == ":") {
                    String _curkey = fieldValue.substring(0, (fieldValue.length - 1)).toLowerCase();
                    if (searchConfig.optionMap.containsKey(_curkey)) {
                      setState(() {
                        SearchOption _searchOption = searchConfig.optionMap[_curkey] as SearchOption;

                        fireStoreQueryState.removeQueryComponent(
                          id: 'autocomplete',
                        );
                        autocompleteController.text = "";
                        _searchOption.isSelected = true;
                        if (!selectedOptions.contains(_searchOption)) {
                          selectedOptions.add(_searchOption);
                        }
                        focusNode.requestFocus();
                      });
                    }

                    // if (!selectedOptions.contains(searchOption)) {

                  }

                  fireStoreQueryState.addQueryComponent(
                    id: 'autocomplete',
                    queryComponent: (Query<T> query) {
                      return query.where(searchConfig.defaultField, isGreaterThanOrEqualTo: fieldValue).where(searchConfig.defaultField, isLessThanOrEqualTo: fieldValue + '~');
                    },
                  );
                } else {
                  fireStoreQueryState.removeQueryComponent(
                    id: 'autocomplete',
                  );
                }
              },
            ),
          ],
        );
      },
      onSelected: (SearchOption searchOption) {
        setState(() {
          searchOption.isSelected = true;
          if (!selectedOptions.contains(searchOption)) {
            selectedOptions.add(searchOption);
            fireStoreQueryState.removeQueryComponent(
              id: 'autocomplete',
            );
            focusNode.requestFocus();
          } else {
            searchOption.isSelected;
            focusNode.requestFocus();
          }
        });
      },
    );
  }

  Map<String, SearchOption> mapConfigs(Iterable<SearchOption> searchOptions) {
    Map<String, SearchOption> output = {};
    for (SearchOption searchOption in searchOptions) {
      output[searchOption.field] = searchOption;
      output[searchOption.caption.toLowerCase()] = searchOption;
    }
    return output;
  }
}
