part of fframe;

// ignore: must_be_immutable
class Fframe extends InheritedWidget {
  Fframe({
    Key? key,
    this.title = "FlutFrame loading...",
    required this.firebaseOptions,
    required this.navigationConfig,
    required this.darkMode,
    required this.lightMode,
    required this.l10nConfig,
    this.themeMode = ThemeMode.system,
    this.providerConfigs,
    this.debugShowCheckedModeBanner = true,
    this.logThreshold = LogLevel.dev,
    this.globalActions,
    this.postLoad,
    this.postSignIn,
    this.postSignOut,
  }) : super(key: key, child: const FFramePreload());

  final String title;

  final FirebaseOptions firebaseOptions;
  final List<ProviderConfiguration>? providerConfigs;
  final NavigationConfig navigationConfig;
  final ThemeData darkMode;
  final ThemeData lightMode;
  late ThemeMode themeMode;
  final L10nConfig l10nConfig;
  final bool debugShowCheckedModeBanner;
  final List<Widget>? globalActions;
  final PostFunction? postLoad;
  final PostFunction? postSignIn;
  final PostFunction? postSignOut;
  final LogLevel logThreshold;

  FFrameUser? user;

  static Fframe? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Fframe>();
  }

  String? errorText;
  String? waitText;

  Widget showErrorPage(
      {required BuildContext context, required String errorText}) {
    this.errorText = errorText;
    return FRouter.of(context).errorPage(context: context);
  }

  Widget showWaitPage(
      {required BuildContext context, required String waitText}) {
    this.waitText = waitText;
    return FRouter.of(context).waitPage(context: context);
  }

  void setThemeMode({required ThemeMode newThemeMode}) {
    themeMode = newThemeMode;
  }

  @override
  bool updateShouldNotify(Fframe oldWidget) {
    return true;
  }

  void log(
    String message, {
    String scope = "Unspecified",
    LogLevel level = LogLevel.dev,
  }) {
    LogLevel logThreshold = this.logThreshold;
    switch (logThreshold) {
      case LogLevel.fframe:
        if (level == LogLevel.fframe ||
            level == LogLevel.dev ||
            level == LogLevel.prod) {
          // show all log prints
          debugPrint("$scope: $message");
        }
        break;
      case LogLevel.dev:
        if (level == LogLevel.dev || level == LogLevel.prod) {
          // show all log prints with level warning or error
          debugPrint("$scope: $message");
        }
        break;
      case LogLevel.prod:
        if (level == LogLevel.prod) {
          // show all log prints with level error
          debugPrint("$scope: $message");
        }
        break;
      default:
    }
  }
}

enum LogLevel {
  fframe,
  dev,
  prod,
}

class FFramePreload extends StatelessWidget {
  const FFramePreload({Key? key}) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
      future:
          Firebase.initializeApp(options: Fframe.of(context)!.firebaseOptions),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          // return MaterialApp(
          //   debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
          //   home: Scaffold(
          //     body: Fframe.of(context)!.navigationConfig.waitPage.contentPane!,
          //   ),
          // );
          case ConnectionState.done:
            if (snapshot.error != null) {
              return MaterialApp(
                debugShowCheckedModeBanner:
                    Fframe.of(context)!.debugShowCheckedModeBanner,
                title: Fframe.of(context)?.title ?? "",
                home: Scaffold(
                  body: Fframe.of(context)!
                      .navigationConfig
                      .errorPage
                      .contentPane!,
                ),
              );
            }
            return const FframeL10nLoader();
          // return MaterialApp(
          //   debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
          //   home: const Scaffold(
          //     body: FframeL10nLoader(),
          //   ),
          // );
        }
      },
    );
  }
}

class FframeL10nLoader extends StatefulWidget {
  const FframeL10nLoader({Key? key}) : super(key: key);

  @override
  State<FframeL10nLoader> createState() => _FframeL10nLoaderState();
}

class _FframeL10nLoaderState extends State<FframeL10nLoader> {
  @override
  Widget build(BuildContext context) {
    return InitializeL10n(
      navigationConfig: Fframe.of(context)!.navigationConfig,
      l10nConfig: Fframe.of(context)!.l10nConfig,
      l10Builder: (context, l10n) {
        if (l10n == null) {
          //Apparently stil loading.... give it a bit of time...
          return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        return const FRouterLoader();
      },
    );
  }
}

class FRouterLoader extends ConsumerStatefulWidget {
  const FRouterLoader({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FRouterLoaderState();
}

class _FRouterLoaderState extends ConsumerState<FRouterLoader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          case ConnectionState.active:
            if (snapshot.error != null) {
              return MaterialApp(
                debugShowCheckedModeBanner:
                    Fframe.of(context)!.debugShowCheckedModeBanner,
                home: Scaffold(
                  body: Fframe.of(context)!
                      .navigationConfig
                      .errorPage
                      .contentPane!,
                ),
              );
            }

            //Store the user
            if (snapshot.data != null) {
              Fframe.of(context)!.user =
                  FFrameUser.fromFirebaseUser(firebaseUser: snapshot.data!);
            } else {
              Fframe.of(context)!.user = null;
            }

            return FRouterInit(
                mainScreen: MainScreen(
                  appTitle: Fframe.of(context)!.title,
                  l10nConfig: Fframe.of(context)!.l10nConfig,
                ),
                navigationConfig: Fframe.of(context)!.navigationConfig,
                routerBuilder: (context) {
                  return const EmailAuthManager();
                });
        }
      },
    );
  }
}

class EmailAuthManager extends StatefulWidget {
  const EmailAuthManager({Key? key}) : super(key: key);

  @override
  EmailAuthManagerState createState() => EmailAuthManagerState();
}

class EmailAuthManagerState extends State<EmailAuthManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Fframe.of(context)!.log(
        "dynamic link research: ${Uri.base} => ${FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())}",
        scope: "fframeLog.EmailAutManager",
        level: LogLevel.fframe);
    Uri uri = Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));

    if (FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())) {
      if (uri.queryParameters.containsKey("hash")) {
        String hash = uri.queryParameters["hash"]!;
        String emailAddress = utf8.decode(base64.decode(hash));

        return FutureBuilder<UserCredential>(
            future: FirebaseAuth.instance.signInWithEmailLink(
                email: emailAddress, emailLink: Uri.base.toString()),
            builder:
                (BuildContext context, AsyncSnapshot<UserCredential> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Fframe.of(context)!
                          .navigationConfig
                          .waitPage
                          .contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.waiting:
                  return Fframe.of(context)!
                          .navigationConfig
                          .waitPage
                          .contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.active:
                  return Fframe.of(context)!
                          .navigationConfig
                          .waitPage
                          .contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    Fframe.of(context)!.log(
                        "Link sign in failed: ${snapshot.error}",
                        scope: "fframeLog.EmailAutManager",
                        level: LogLevel.fframe);
                    return const FframePostLoad();
                  }

                  UserCredential? userCredential = snapshot.data;
                  Fframe.of(context)!.log(
                      "Resulting user: ${userCredential?.user?.email}",
                      scope: "fframeLog.EmailAutManager",
                      level: LogLevel.fframe);
                  return const FframePostLoad();
              }
            });
      } else {
        Fframe.of(context)!.log("emailAddress not found in hash",
            scope: "fframeLog.EmailAutManager", level: LogLevel.fframe);
      }
    }
    return const FframePostAuth();
  }
}

class FframePostAuth extends StatefulWidget {
  const FframePostAuth({
    Key? key,
  }) : super(key: key);

  @override
  State<FframePostAuth> createState() => _FframeFframePostAuthState();
}

class _FframeFframePostAuthState extends State<FframePostAuth> {
  bool signedIn = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Fframe.of(context)?.postSignIn == null &&
        Fframe.of(context)?.postSignOut == null) {
      Fframe.of(context)!.log("No code provided",
          scope: "fframeLog.postSignIn/Out", level: LogLevel.fframe);
      return const FframePostLoad();
    } else {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData && snapshot.data != null && signedIn == false) {
            //User has gone from signed out to signed in
            Fframe.of(context)!.log("Code executing",
                scope: "fframeLog.postSignIn", level: LogLevel.fframe);
            if (Fframe.of(context)?.postSignIn != null) {
              return FutureBuilder<void>(
                future: Fframe.of(context)!.postSignIn!(context),
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Fframe.of(context)!
                              .navigationConfig
                              .waitPage
                              .contentPane ??
                          const Center(
                            child: CircularProgressIndicator(),
                          );
                    case ConnectionState.done:
                      if (snapshot.error != null) {
                        return MaterialApp(
                          debugShowCheckedModeBanner:
                              Fframe.of(context)!.debugShowCheckedModeBanner,
                          home: Scaffold(
                            body: Fframe.of(context)!
                                .navigationConfig
                                .errorPage
                                .contentPane!,
                          ),
                        );
                      }
                      return const FframePostLoad();
                  }
                },
              );
            } else {
              return const FframePostLoad();
            }
          } else {
            //User had gone from signed in to signed out
            Fframe.of(context)!.log("Code executing",
                scope: "fframeLog.postSignOut", level: LogLevel.fframe);
            if (Fframe.of(context)?.postSignOut != null) {
              return FutureBuilder<void>(
                future: Fframe.of(context)!.postSignOut!(context),
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Fframe.of(context)!
                              .navigationConfig
                              .waitPage
                              .contentPane ??
                          const Center(
                            child: CircularProgressIndicator(),
                          );
                    case ConnectionState.done:
                      if (snapshot.error != null) {
                        return MaterialApp(
                          debugShowCheckedModeBanner:
                              Fframe.of(context)!.debugShowCheckedModeBanner,
                          home: Scaffold(
                            body: Fframe.of(context)!
                                .navigationConfig
                                .errorPage
                                .contentPane!,
                          ),
                        );
                      }
                      return const FframePostLoad();
                  }
                },
              );
            } else {
              return const FframePostLoad();
            }
          }
        },
      );
    }
  }
}

class FframePostLoad extends StatefulWidget {
  const FframePostLoad({
    Key? key,
  }) : super(key: key);

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
      Fframe.of(context)!.log("No code provided",
          scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return const FframeBuilder();
    } else {
      Fframe.of(context)!.log("Code executing",
          scope: "fframeLog.postLoad", level: LogLevel.fframe);
      return FutureBuilder<void>(
        future: Fframe.of(context)!.postLoad!(context),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Fframe.of(context)!
                      .navigationConfig
                      .waitPage
                      .contentPane ??
                  const Center(
                    child: CircularProgressIndicator(),
                  );
            case ConnectionState.done:
              if (snapshot.error != null) {
                return MaterialApp(
                  debugShowCheckedModeBanner:
                      Fframe.of(context)!.debugShowCheckedModeBanner,
                  home: Scaffold(
                    body: Fframe.of(context)!
                        .navigationConfig
                        .errorPage
                        .contentPane!,
                  ),
                );
              }
              return const FframeBuilder();
          }
        },
      );
    }
  }
}

class FframeBuilder extends StatelessWidget {
  const FframeBuilder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      routeInformationParser: FNavigationRouteInformationParser(),
      routerDelegate: FNavigationRouterDelegate(),
      debugShowCheckedModeBanner: false,
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
