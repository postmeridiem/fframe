part of fframe;

//TODO: => Try and update in such a way the callee does not need to have firebase loaded?

// abstract class FFirebaseOptions implements FirebaseOptions {}


// class DefaultFirebaseConfig {
//   static FirebaseOptions get platformOptions {
//     if (kIsWeb) {
//       // Web
//       return const FirebaseOptions(
//           apiKey: "AIzaSyBWmy1m0VGbdM6gjKB2fAWCdni9ol6_hbI",
//           authDomain: "fframe-dev.firebaseapp.com",
//           projectId: "fframe-dev",
//           storageBucket: "fframe-dev.appspot.com",
//           messagingSenderId: "252859371693",
//           appId: "1:252859371693:web:5c67e3096937a7f1733624",
//           measurementId: "G-YM5SFM2J1X");
//     } else if (Platform.isIOS || Platform.isMacOS) {
//       // iOS and MacOS
//       //JS/AZ => not configured
//       return const FirebaseOptions(
//         apiKey: '',
//         appId: '',
//         messagingSenderId: '',
//         projectId: '',
//         authDomain: '',
//         iosBundleId: '',
//         databaseURL: '',
//         iosClientId: '',
//         androidClientId: '',
//         storageBucket: '',
//       );
//     } else {
//       // Android
//       //JS/AZ => not configured
//       return const FirebaseOptions(
//         apiKey: '',
//         appId: '',
//         messagingSenderId: '',
//         projectId: '',
//         authDomain: '',
//         databaseURL: '',
//         androidClientId: '',
//       );
//     }
//   }
// }
