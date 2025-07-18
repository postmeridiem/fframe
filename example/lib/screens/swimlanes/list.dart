import 'package:example/models/suggestion.dart';

import 'package:fframe/fframe.dart';

List<SwimlaneSetting<Suggestion>> swimlanesSettings = [
  SwimlaneSetting(
    id: "new",
    header: "New",
    query: (Query<Suggestion> query) {
      return query.where("status", isEqualTo: "new");
    },
    onLaneDrop: (Suggestion suggestion, double? priority, _) {
      suggestion.status = "new";
      return suggestion;
    },
    onPriorityChange: (Suggestion suggestion, double? priority) {
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    canChangePriority: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
    canChangeSwimLane: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return false;
    },
  ),
  SwimlaneSetting(
    id: "triage",
    header: "Triage",
    query: (Query<Suggestion> query) {
      return query.where("status", isEqualTo: "triage");
    },
    onLaneDrop: (Suggestion suggestion, double? priority, _) {
      suggestion.status = "triage";
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    onPriorityChange: (Suggestion suggestion, double? priority) {
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    canChangePriority: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
    canChangeSwimLane: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
  ),
  SwimlaneSetting(
    id: "inProgress",
    header: "In Progress",
    query: (Query<Suggestion> query) {
      return query.where("status", isEqualTo: "inProgress");
    },
    onLaneDrop: (Suggestion suggestion, double? priority, _) {
      suggestion.status = "inProgress";
      return suggestion;
    },
    onPriorityChange: (Suggestion suggestion, double? priority) {
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    canChangePriority: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      if (sourcePriority != targetPriority) {
        //Allow only if priority is in the same integer
        return false;
      }
      return true;
    },
    canChangeSwimLane: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
  ),
  SwimlaneSetting(
    id: "quality",
    header: "Quality",
    roles: ["testrole"],
    query: (Query<Suggestion> query) {
      return query.where("status", isEqualTo: "quality");
    },
    onLaneDrop: (Suggestion suggestion, double? priority, _) {
      suggestion.status = "quality";
      return suggestion;
    },
    onPriorityChange: (Suggestion suggestion, double? priority) {
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    // onLanePositionChange: (Suggestion suggestion, double? lanePosition) {
    //   // Dummy implementation, as Suggestion doesn't have a field for lanePosition
    //   Console.log('onLanePositionChange called with target lanePosition of $lanePosition');
    //   return suggestion;
    // },
    canChangePriority: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
    canChangeSwimLane: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
  ),
  SwimlaneSetting(
    id: "done",
    header: "Done",
    query: (Query<Suggestion> query) {
      return query.where("status", isEqualTo: "done");
    },
    onLaneDrop: (Suggestion suggestion, double? priorit, _) {
      suggestion.status = "done";
      return suggestion;
    },
    onPriorityChange: (Suggestion suggestion, double? priority) {
      suggestion.priority = priority ?? 5.0;
      return suggestion;
    },
    canChangePriority: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return false;
    },
    canChangeSwimLane: (SelectedDocument<Suggestion> selectedDocument, roles, sourceSwimmingLane, sourcePriority, targetPriority) {
      return true;
    },
  ),
];
