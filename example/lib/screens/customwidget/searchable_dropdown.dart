import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.label,
    required this.controller,
    required this.values,
    required this.onSelected,
    this.width,
    this.inputDecorationTheme,
    this.onFilter,
    this.lowercaseLabel = true,
  });

  final String label;
  final TextEditingController controller;
  final List<T> values;
  final void Function(T? value) onSelected;
  final double? width;
  final InputDecorationTheme? inputDecorationTheme;
  final Function(String filter)? onFilter; // Add the onFilter parameter
  final bool lowercaseLabel;

  @override
  State<SearchableDropdown<T>> createState() => _GenericDropdownMenuState<T>();
}

class _GenericDropdownMenuState<T> extends State<SearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownMenu<T>(
        width: widget.width ?? constraints.maxWidth,
        controller: widget.controller,
        requestFocusOnTap: true,
        enableFilter: true,
        label: Text(widget.label, style: const TextStyle(fontSize: 13.5)),
        inputDecorationTheme: widget.inputDecorationTheme,
        onSelected: widget.onSelected,
        filterCallback: (List<DropdownMenuEntry<T>> entries, String controllerText) {
          final String trimmedFilter = controllerText.trim().toLowerCase();
          if (trimmedFilter.isEmpty) {
            return entries;
          }

          // Filter for partial matches
          final List<DropdownMenuEntry<T>> filteredEntries = entries.where((DropdownMenuEntry<T> entry) {
            final String label = entry.label.toLowerCase();
            return label.contains(trimmedFilter);
          }).toList();

          // If no match, return the original list to avoid errors
          return filteredEntries.isNotEmpty ? filteredEntries : entries;
        },
        dropdownMenuEntries: widget.values.map<DropdownMenuEntry<T>>((T value) {
          return DropdownMenuEntry<T>(
            value: value,
            label: widget.lowercaseLabel ? value.toString().split('.').last.toLowerCase() : value.toString(),
            trailingIcon: value == widget.controller.text ? const Icon(Icons.check_rounded) : null,
          );
        }).toList(),
      );
    });
  }
}
