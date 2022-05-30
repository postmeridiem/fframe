# A FlutFrame Starter App
## Installation Instructions

- set up a firestore database (INSTRUCTIONS NEEDED)
- get yourself a firebase_config.dart file in the lib dir (an empty one is supplied (firebase_config.dart.clean) in your new lib dir)
- paste the firestore credentials in the config (which is gitignored to prevent upload to git) 
- start server with flutter run -d chrome  --web-port 8000 in the root dir of your project, assuming that is where you copied the example
- ADD IMPROVED INSTRUCTIONS FOR RUNNING WITH FFRAME AS A PACKAGE

### l10n support added
For a new clone, no action is needed.
To update for l10n support you need to do the following
- copy l10n.yaml from the example dir to your project root
- add generate: true to the flutter section of your pubspec.yaml
- copy the l10n folder from example/lib into your lib dir
- import 'package:your_package/l10n/l10n.dart'; into main.dart in your lib dir
- add l10nConfig: l10nConfig, to the Fframe instantiation in main.dart in your lib dir

for examples check the example codebase. 

NOTE: when everything is added at once the flutter_gen package may not yet be available. In that case, comment out the missing imports in lib/l10n/l10n.dart and the additional error in that same file. Run *flutter gen-l10n* and then reload your IDE project and uncomment the temporary changes in l10n.dart
