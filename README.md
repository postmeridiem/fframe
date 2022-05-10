# fframe
## FlutFrame

### Installation
- install flutter per normal instructions
- create a new flutter project
- copy the example dir into the root of your project
- continue following the instructions [here](https://github.com/postmeridiem/fframe/blob/main/example/installation.md)


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

<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

