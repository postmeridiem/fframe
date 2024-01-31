import 'package:example/models/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

// import 'package:example/models/suggestion.dart';

List<ListGridActionMenu<Suggestion>> listgridActionMenu() {
  return [
    ListGridActionMenu(
      label: "Create new...",
      icon: Icons.new_label,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
            label: "Create new ...",
            icon: Icons.playlist_add_outlined,
            processSelection: false,
            onClick: (context, user, _, DocumentScreenConfig? documentScreenConfig) {
              documentScreenConfig!.selectDocument(context, documentScreenConfig.create<Suggestion>(context: context));
              return;
            }),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      label: "Toggle active",
      icon: Icons.toggle_off_outlined,
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Set inactive",
          icon: Icons.toggle_off_outlined,
          onClick: (BuildContext context, FFrameUser? user, SelectedDocument<Suggestion>? selectedDocument, _) {
            selectedDocument?.data?.active = false;
            return selectedDocument;
          },
        ),
        ListGridActionMenuItem<Suggestion>(
          label: "Set Active",
          icon: Icons.toggle_on,
          onClick: (BuildContext context, FFrameUser? user, SelectedDocument<Suggestion>? selectedDocument, _) {
            selectedDocument?.data?.active = true;
            return selectedDocument;
          },
        ),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Delete",
          icon: Icons.delete_outline,
          onClick: (context, user, selectedDocument, _) {
            debugPrint("NOT deleting ${selectedDocument.toString()}. Just printing this.");

            return;
          },
        ),
      ],
    ),
    ListGridActionMenu<Suggestion>(
      menuItems: [
        ListGridActionMenuItem<Suggestion>(
          label: "Help...",
          icon: Icons.help_outline,
          processSelection: false,
          onClick: (context, _, __, ___) {
            launchUrl(
              Uri.parse('https://github.com/postmeridiem/fframe/blob/main/fframe/lib/screens/listgrid_screen/listgrid.md'),
              webOnlyWindowName: "_blank",
            );
            return;
          },
        ),
      ],
    ),
  ];
}
