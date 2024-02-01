part of 'fframe.dart';

enum SignInState {
  unknown,
  signedIn,
  signedOut,
}

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
    this.debugShowCheckedModeBanner = true,
    this.globalActions,
    this.postLoad,
    this.postSignIn,
    this.postSignOut,
  }) : super(child: const FFramePreload()) {
    Console.log("+-=-=-=-=-=-=-=-=-=-=-= ${DateTime.now().toIso8601String()} -=-=-=-=-=-=-=-=-=-=-=-=-=-+", scope: "Fframe", level: LogLevel.dev);
  }

  final String title;

  final FirebaseOptions firebaseOptions;
  final List<ProviderConfiguration>? providerConfigs;
  final NavigationConfig navigationConfig;
  final ThemeData darkMode;
  final ThemeData lightMode;
  late ThemeMode themeMode;
  final L10nConfig l10nConfig;
  final Console consoleLogger;
  final bool debugShowCheckedModeBanner;
  final List<Widget>? globalActions;
  final PostFunction? postLoad;
  final PostFunction? postSignIn;
  final PostFunction? postSignOut;

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
  const FFramePreload({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return const ProviderScope(
      child: RootRestorationScope(
        restorationId: 'fframe',
        child: FframeFirebaseLoader(),
      ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(options: Fframe.of(context)!.firebaseOptions),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const FFWaitPage(message: "Connecting with backend services...");
          case ConnectionState.done:
            if (snapshot.error != null) {
              return const FFErrorPage();
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
          return const FFWaitPage(message: "Loading language library...");
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
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return const FFWaitPage(
            message: 'Awaiting authentication..',
          );
        } else if (snapshot.error != null) {
          return const FFErrorPage();
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
                    return const FFWaitPage(
                      message: "Running post sign-out scripts...",
                    );
                  } else if (snapshot.error != null) {
                    return const FFErrorPage();
                  } else {
                    return const InitFrouter();
                  }
                },
              );
            case (SignInState.signedIn):
              return FutureBuilder<IdTokenResult>(
                future: user!.getIdTokenResult(),
                builder: (BuildContext context, AsyncSnapshot<IdTokenResult> snapshot) {
                  if (!snapshot.hasData) {
                    return const FFWaitPage(
                      message: "Loading user data...",
                    );
                  } else if (snapshot.error != null) {
                    return const FFErrorPage();
                  } else {
                    Fframe.of(context)!.user = FFrameUser.fromFirebaseUser(firebaseUser: user, idTokenResult: snapshot.data!);
                    return FutureBuilder<void>(
                      future: postSignIn(context),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return const FFWaitPage(
                            message: "Running post sign-in scripts...",
                          );
                        } else if (snapshot.error != null) {
                          return const FFErrorPage();
                        } else {
                          return const InitFrouter();
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
  const InitFrouter({super.key});

  @override
  Widget build(BuildContext context) {
    Console.log("InitFrouter", scope: "InitFrouter", level: LogLevel.dev);

    return FRouterInit(
        mainScreen: MainScreen(
          appTitle: Fframe.of(context)!.title,
          l10nConfig: Fframe.of(context)!.l10nConfig,
        ),
        navigationConfig: Fframe.of(context)!.navigationConfig,
        routerBuilder: (context) {
          return const FframeBuilder();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Console.log("dynamic link research: ${Uri.base} => ${FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())}", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
    Uri uri = Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));

    if (FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())) {
      if (uri.queryParameters.containsKey("hash")) {
        String hash = uri.queryParameters["hash"]!;
        String emailAddress = utf8.decode(base64.decode(hash));

        return FutureBuilder<UserCredential>(
            future: FirebaseAuth.instance.signInWithEmailLink(email: emailAddress, emailLink: Uri.base.toString()),
            builder: (BuildContext context, AsyncSnapshot<UserCredential> snapshot) {
              if (!snapshot.hasData) {
                return const FFWaitPage(
                  message: "Running post sign in link",
                );
              } else if (snapshot.error != null) {
                return const FFErrorPage();
              } else {
                UserCredential? userCredential = snapshot.data;
                Console.log("Resulting user: ${userCredential?.user?.email}", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
                return const FFWaitPage(message: "Signing in with link");
              }
            });
      } else {
        Console.log("emailAddress not found in hash", scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
      }
    }
    return const FFWaitPage(
      message: 'Awaiting link authentication...',
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Fframe.of(context)?.postLoad == null) {
      Console.log("No code provided", scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return const FframeBuilder();
    } else {
      Console.log("Code executing", scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return FutureBuilder<void>(
        future: Fframe.of(context)!.postLoad!(context),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const FFWaitPage(
              message: "Intializing application",
            );
          } else if (snapshot.error != null) {
            return const FFErrorPage();
          } else {
            return const FframeBuilder();
          }
        },
      );
    }
  }
}

class FframeBuilder extends StatelessWidget {
  const FframeBuilder({super.key});
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
  const FFWaitPage({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    Console.log("Show wait page with message $message", scope: "FFWaitPage", level: LogLevel.dev);
    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      home: Scaffold(
        body: (message != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class FFErrorPage extends StatelessWidget {
  const FFErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Fframe.of(context)!.lightMode,
      darkTheme: Fframe.of(context)!.darkMode,
      themeMode: Fframe.of(context)!.themeMode,
      debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
      home: Scaffold(
        body: Fframe.of(context)!.navigationConfig.errorPage.contentPane!,
      ),
    );
  }
}
