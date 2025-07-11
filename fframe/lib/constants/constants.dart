Map<String, String> allClaims = {
  "userViewer": "Allow viewing of all registered users",
  "userEditor": "Allow editing of all registered users",
  // "userCreator": "Creation of a registered user",

  "clientViewer": "Allow viewing of all registered client",
  "clientEditor": "Allow editing of all registered client",
  "clientCreator": "Allow creating of a registered client",

  "runConfigViewer": "Allow viewing of all registered runConfigs",
  "runConfigEditor": "Allow Editing of all registered runConfigs",
  "runConfigCreator": "Allow creating of a registered runConfig",

  "runViewer": "Allow viewing of all registered run",
  "runEditor": "Allow Editing of all registered run",
  "runCreator": "Allow creating of a registered run",
};

enum ScreenSize { phone, tablet, large, unknown }

// Defining the re-indexing increment for swimlanes lane position calculation:
// Reasoning behind the value: providing "space" for reordering, to better avoid complex fractions.
const double lanePositionIncrement = 1000.0;
