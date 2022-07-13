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
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(fontSize: 12.0),
                            onChanged: (String fieldValue) {
                              fireStoreQueryState.addQueryComponent(
                                id: searchOption.field,
                                queryComponent: (Query<T> query) {
                                  return query.where(searchOption.field, isEqualTo: fieldValue);
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        fireStoreQueryState.removeQueryComponent(id: searchOption.field);
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
                        fireStoreQueryState.addQueryComponent(
                          id: searchOption.field,
                          queryComponent: (Query<T> query) {
                            return query.where(searchOption.field, isEqualTo: selected);
                          },
                        );
                      });
                    },
                  );

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
