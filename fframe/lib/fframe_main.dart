part of 'fframe.dart';

enum SignInState {
  unknown,
  signedIn,
  signedOut,
}

// class InitialUri {
//   factory InitialUri({Uri? initialUri}) {
//     if (instance == null) {
//       Console.log("InitialUri", scope: "Fframe", level: LogLevel.fframe, color: ConsoleColor.white);
//       initialUri = initialUri ?? _getCleanedBaseUri();
//       Console.log("Initial Uri: ${initialUri.path} ${initialUri.queryParameters}", scope: "Fframe", level: LogLevel.dev, color: ConsoleColor.white);
//       instance = InitialUri._internal(initialUri);
//     }
//     return instance!;
//   }

//   static InitialUri? instance;
//   InitialUri._internal(this.initalUri);

//   Uri? initalUri;

//   static Uri _getCleanedBaseUri() {
//     return Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));
//   }

//   static InitialUri getInstance() {
//     return instance ?? InitialUri(); // Ensure instance is not null
//   }

//   Uri getInitialUri() {
//     return initalUri ?? _getCleanedBaseUri();
//   }

//   void clearInitialUri() {
//     initalUri = null;
//   }
// }

// ignore: must_be_immutable
class Fframe extends InheritedWidget {
  Fframe({
    super.key,
    this.title = "FlutFrame loading...",
    required this.firebaseOptions,
    required this.navigationConfig,
    required this.darkMode,
    required this.lightMode,
    required this.l10nConfig,
    required this.consoleLogger,
    this.themeMode = ThemeMode.system,
    this.providerConfigs,
    this.enableNotficationSystem = false,
    this.debugShowCheckedModeBanner = false,
    this.globalActions,
    this.postLoad,
    this.postSignIn,
    this.postSignOut,
  }) : super(child: FFramePreload()) {
    Console.log("+-=-=-=-=-=-=-=-=-=-=-= ${DateTime.now().toIso8601String()} -=-=-=-=-=-=-=-=-=-=-=-=-=-+", scope: "Fframe", level: LogLevel.dev, color: ConsoleColor.green);
    deepLinkUri = Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));
    Console.log("deepLinkUri: ${deepLinkUri!.path} ${deepLinkUri?.queryParameters}", scope: "Fframe", level: LogLevel.dev, color: ConsoleColor.white);
  }

  // static final Fframe instance = Fframe._internal();

  // Fframe._internal();

  final String title;

  final FirebaseOptions firebaseOptions;
  final List<GoogleProvider>? providerConfigs;
  final NavigationConfig navigationConfig;
  final ThemeData darkMode;
  final ThemeData lightMode;
  late ThemeMode themeMode;
  final L10nConfig l10nConfig;
  final Console consoleLogger;
  final bool enableNotficationSystem;
  final bool debugShowCheckedModeBanner;
  final List<Widget>? globalActions;
  final PostFunction? postLoad;
  final PostFunction? postSignIn;
  final PostFunction? postSignOut;

  Uri? deepLinkUri;

  FFrameUser? user;

  static Fframe? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Fframe>();
  }

  String? errorText;
  String? waitText;
  SignInState signInState = SignInState.unknown;

  Widget showErrorPage({required BuildContext context, required String errorText}) {
    this.errorText = errorText;
    return FRouter.of(context).errorPage(context: context);
  }

  Widget showWaitPage({required BuildContext context, required String waitText}) {
    this.waitText = waitText;
    return FRouter.of(context).waitPage(context: context);
  }

  void showSnackBar({required BuildContext context, String? message, Icon? icon, SnackBar? snackBar}) {
    assert(!(message == null && snackBar == null)); // Ensure not both are null
    if (snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 3)));
    }
  }

  void setThemeMode({required ThemeMode newThemeMode}) {
    themeMode = newThemeMode;
  }

  ThemeMode get getSystemThemeMode {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return (brightness == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  bool updateShouldNotify(Fframe oldWidget) {
    return true;
  }
}

class FFramePreload extends StatelessWidget {
  FFramePreload({super.key}) {
    Console.log("FframeFirebaseLoader", scope: "Fframe", level: LogLevel.fframe);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return const RootRestorationScope(
      restorationId: 'fframe',
      child: FframeFirebaseLoader(),
    );
  }
}

class FframeFirebaseLoader extends StatefulWidget {
  const FframeFirebaseLoader({
    super.key,
  });

  @override
  State<FframeFirebaseLoader> createState() => _FframeLoaderState();
}

class _FframeLoaderState extends State<FframeFirebaseLoader> {
  @override
  initState() {
    Console.log("FframeFirebaseLoader", scope: "Fframe", level: LogLevel.fframe);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseOptions firebaseOptions = Fframe.of(context)!.firebaseOptions;
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(options: firebaseOptions),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return FFWaitPage(message: "Connecting with backend services...");
          case ConnectionState.done:
            if (snapshot.error != null) {
              return FFErrorPage();
            }
            return const FframeL10nLoader();
        }
      },
    );
  }
}

class FframeL10nLoader extends StatefulWidget {
  const FframeL10nLoader({super.key});

  @override
  State<FframeL10nLoader> createState() => _FframeL10nLoaderState();
}

class _FframeL10nLoaderState extends State<FframeL10nLoader> {
  @override
  Widget build(BuildContext context) {
    return InitializeL10n(
      l10nConfig: Fframe.of(context)!.l10nConfig,
      l10Builder: (context, l10n) {
        if (l10n == null) {
          //Apparently stil loading.... give it a bit of time...
          return FFWaitPage(message: "Loading language library...");
        }

        return const FRouterLoader();
      },
    );
  }
}

class FRouterLoader extends StatefulWidget {
  const FRouterLoader({super.key});

  @override
  State<StatefulWidget> createState() => _FRouterLoaderState();
}

class _FRouterLoaderState extends State<FRouterLoader> {
  @override
  initState() {
    Console.log("FRouterLoader", scope: "Fframe", level: LogLevel.fframe);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return const SignInWithLink();
        } else if (snapshot.error != null) {
          return FFErrorPage();
        } else {
          //Check if user is signed in
          User? user = snapshot.data;
          if (Fframe.of(context)!.signInState == SignInState.unknown && user == null) {
            //User has just loaded application, but did sign in state is still unknown
            Fframe.of(context)!.signInState = SignInState.signedOut;
          } else if (Fframe.of(context)!.signInState == SignInState.unknown && user == null) {
            //User has just loaded application, but did not sign in
            Fframe.of(context)!.signInState = SignInState.signedOut;
          } else if (Fframe.of(context)!.signInState == SignInState.signedIn && user == null) {
            //User has just signed out
            Fframe.of(context)!.signInState = SignInState.signedOut;
            Fframe.of(context)!.user = null;
          } else if (Fframe.of(context)!.signInState == SignInState.unknown && user != null) {
            //User has just signed in
            Fframe.of(context)!.signInState = SignInState.signedIn;
          }

          //Update UI according to sign-in-state
          switch (Fframe.of(context)!.signInState) {
            case (SignInState.unknown):
              return const SignInWithLink();
            case (SignInState.signedOut):
              return FutureBuilder<void>(
                future: postSignOut(context),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return FFWaitPage(
                      message: "Running post sign-out scripts...",
                    );
                  } else if (snapshot.error != null) {
                    return FFErrorPage();
                  } else {
                    return InitFrouter();
                  }
                },
              );
            case (SignInState.signedIn):
              return FutureBuilder<IdTokenResult>(
                future: user!.getIdTokenResult(),
                builder: (BuildContext context, AsyncSnapshot<IdTokenResult> snapshot) {
                  if (!snapshot.hasData) {
                    return FFWaitPage(
                      message: "Loading user data...",
                    );
                  } else if (snapshot.error != null) {
                    return FFErrorPage();
                  } else {
                    Fframe.of(context)!.user = FFrameUser.fromFirebaseUser(firebaseUser: user, idTokenResult: snapshot.data!);
                    return FutureBuilder<void>(
                      future: postSignIn(context),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return FFWaitPage(
                            message: "Running post sign-in scripts...",
                          );
                        } else if (snapshot.error != null) {
                          return FFErrorPage();
                        } else {
                          return InitFrouter();
                        }
                      },
                    );
                  }
                },
              );
          }
        }
      },
    );
  }

  Future postSignIn(BuildContext context) async {
    if (Fframe.of(context)?.postSignIn != null) {
      await Fframe.of(context)!.postSignIn!(context);
    }
    return Future.value(true);
  }

  Future postSignOut(BuildContext context) async {
    if (Fframe.of(context)!.postSignOut != null) {
      await Fframe.of(context)!.postSignOut!(context);
    }
    return Future.value(true);
  }
}

class InitFrouter extends StatelessWidget {
  InitFrouter({super.key}) {
    Console.log("InitFrouter", scope: "Fframe", level: LogLevel.fframe);
  }

  @override
  Widget build(BuildContext context) {
    Console.log("InitFrouter", scope: "InitFrouter", level: LogLevel.fframe);

    return FRouterInit(
        mainScreen: MainScreen(
          appTitle: Fframe.of(context)!.title,
          l10nConfig: Fframe.of(context)!.l10nConfig,
        ),
        navigationConfig: Fframe.of(context)!.navigationConfig,
        user: Fframe.of(context)!.user,
        routerBuilder: (context) {
          return FframeBuilder();
        });
  }
}

class SignInWithLink extends StatefulWidget {
  const SignInWithLink({super.key});
  @override
  SignInWithLinkState createState() => SignInWithLinkState();
}

class SignInWithLinkState extends State<SignInWithLink> with WidgetsBindingObserver {
  @override
  void initState() {
    Console.log("SignInWithLinkState", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));
    Console.log("dynamic link research: ${uri.toString()} => ${FirebaseAuth.instance.isSignInWithEmailLink(uri.toString())}", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);

    if (FirebaseAuth.instance.isSignInWithEmailLink(uri.toString())) {
      if (uri.queryParameters.containsKey("hash")) {
        String hash = uri.queryParameters["hash"]!;
        String emailAddress = utf8.decode(base64.decode(hash));

        return FutureBuilder<UserCredential>(
            future: FirebaseAuth.instance.signInWithEmailLink(email: emailAddress, emailLink: uri.toString()),
            builder: (BuildContext context, AsyncSnapshot<UserCredential> snapshot) {
              if (!snapshot.hasData) {
                return FFWaitPage(
                  message: "Running post sign in link",
                );
              } else if (snapshot.error != null) {
                return FFErrorPage();
              } else {
                UserCredential? userCredential = snapshot.data;
                Console.log("Resulting user: ${userCredential?.user?.email}", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
                return FFWaitPage(message: "Signing in with link");
              }
            });
      } else {
        Console.log("emailAddress not found in hash", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
      }
    }
    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      title: Fframe.of(context)!.title,
      color: Theme.of(context).colorScheme.surface,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      builder: (context, child) {
        return Fframe.of(context)!.navigationConfig.signInConfig.signInTarget.contentPane ??
            FFErrorPage(
              message: "Sign in configuration not set",
            );
      },
    );
  }
}

class FframePostLoad extends StatefulWidget {
  const FframePostLoad({
    super.key,
  });

  @override
  State<FframePostLoad> createState() => _FframePostLoadState();
}

class _FframePostLoadState extends State<FframePostLoad> {
  @override
  initState() {
    Console.log("postLoad", scope: "fframeLog.postLoad", level: LogLevel.fframe);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Fframe.of(context)?.postLoad == null) {
      Console.log("No code provided", scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return FframeBuilder();
    } else {
      Console.log("Code executing", scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return FutureBuilder<void>(
        future: Fframe.of(context)!.postLoad!(context),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return FFWaitPage(
              message: "Intializing application",
            );
          } else if (snapshot.error != null) {
            return FFErrorPage();
          } else {
            return FframeBuilder();
          }
        },
      );
    }
  }
}

class FframeBuilder extends StatelessWidget {
  FframeBuilder({super.key}) {
    Console.log("FframeBuilder", scope: "Fframe", level: LogLevel.fframe);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      routeInformationParser: FNavigationRouteInformationParser(),
      routerDelegate: FNavigationRouterDelegate(),
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      locale: L10n.getLocale(),
      title: Fframe.of(context)!.title,
      color: Theme.of(context).colorScheme.surface,
    );
  }
}

typedef PostFunction = Function(
  BuildContext context,
);

class FFWaitPage extends StatelessWidget {
  FFWaitPage({super.key, this.message}) {
    Console.log("FFWaitPage", scope: "Fframe", level: LogLevel.fframe);
  }
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      Console.log("Show wait page with message $message", scope: "FFWaitPage", level: LogLevel.fframe);
    } else {
      Console.log("Show wait page", scope: "FFWaitPage", level: LogLevel.fframe);
    }

    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      title: Fframe.of(context)!.title,
      color: Theme.of(context).colorScheme.surface,
      builder: (context, child) {
        return Scaffold(
          body: (message != null)
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      children: <Widget>[
                        const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(message!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}

class FFErrorPage extends StatelessWidget {
  FFErrorPage({super.key, this.message}) {
    Console.log("FFErrorPage", scope: "Fframe", level: LogLevel.fframe);
  }
  final String? message;

  @override
  Widget build(BuildContext context) {
    Fframe.of(context)?.errorText = message;
    Console.log("Show error page with message $message", scope: "FFErrorPage", level: LogLevel.fframe);
    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      title: Fframe.of(context)!.title,
      color: Theme.of(context).colorScheme.surface,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      builder: (context, child) {
        return Scaffold(
          body: Fframe.of(context)!.navigationConfig.errorPage.contentPane!,
        );
      },
    );
  }
}

class FFRedirectPage extends StatelessWidget {
  FFRedirectPage({super.key}) {
    Console.log("FFErrorPage", scope: "Fframe", level: LogLevel.fframe);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      builder: (context, child) {
        return const Scaffold(
          body: Icon(Icons.forward),
        );
      },
    );
  }
}
