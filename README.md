# fframe
## FlutFrame

### installation
- install flutter per normal instructions
- create a new flutter project
- copy the example dir into the root of your project
- continue following the instructions [here](https://github.com/postmeridiem/fframe/blob/main/example/readme.md)


### l10n support added
For a new clone, no action is needed.
To update for l10n support you need to do the following
- copy l10n.yaml from fframe_demo dir to your project root
- add generate: true to the flutter section of your pubspec.yaml
- copy the l10n folder from fframe_demo/lib into your lib dir
- import 'package:your_package/l10n/l10n.dart'; into main.dart in your lib dir
- add l10nConfig: l10nConfig, to the Fframe instantiation in main.dart in your lib dir

for examples check the fframe_demo codebase. 

NOTE: when everything is added at once the flutter_gen package may not yet be available. In that case, comment out the missing imports in fframe_demo/lib/l10n/l10n.dart and the additional error in that same file. Then build the project, reload your IDE project and uncomment the temporary changes in l10n.dart
