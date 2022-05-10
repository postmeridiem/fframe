# fframe
##FlutFrame

### installation
- install flutter per normal instructions
- pull repo
- set up a firestore database (see other instructions out of scope)
- get yourself a firebase_config.dart file in the lib dir (an empty one will be supplied firebase_config.dart.clean next to it)
- paste the firestore credentials in the config (which is gitignored to prevent upload to git) 
- start server with flutter run -d chrome  --web-port 8000 in the fframe_demo dir


### l10n support added
to update for l10n support you need to do the following
- copy l10n.yaml from fframe_demo dir to your project root
- add generate: true to the flutter section of your pubspec.yaml
- copy the l10n folder from fframe_demo/lib into your lib dir
- import 'package:your_package/l10n/l10n.dart'; into main.dart in your lib dir
- add l10nConfig: l10nConfig, to the Fframe instantiation in main.dart in your lib dir

for examples check the fframe_demo codebase. 

NOTE: when everything is added at once the flutter_gen package may not yet be available. In that case, comment out the missing imports in fframe_demo/lib/l10n/l10n.dart and the additional error in that same file. Then build the project, reload your IDE project and uncomment the temporary changes in l10n.dart
