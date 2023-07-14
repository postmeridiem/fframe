import 'package:fframe/fframe.dart';

List<SwimlaneSetting<SwimlanesTask>> swimlanesSettings = [
  SwimlaneSetting(
    header: "New",
    status: "new",
  ),
  SwimlaneSetting(
    header: "Triage",
    status: "triage",
  ),
  SwimlaneSetting(
    header: "In Progress",
    status: "in-progress",
  ),
  SwimlaneSetting(
    header: "Quality",
    status: "quality",
    roles: ["testrole"],
  ),
  SwimlaneSetting(
    header: "Done",
    status: "done",
  ),
];
