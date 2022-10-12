part of fframe;

// ignore: must_be_immutable
class Fframe extends InheritedWidget {
  Fframe({
    Key? key,
    this.title = "FlutFrame",
    required this.firebaseOptions,
    required this.navigationConfig,
    required this.darkMode,
    required this.lightMode,
    required this.l10nConfig,
    this.providerConfigs,
    this.debugShowCheckedModeBanner = true,
    this.globalActions,
    this.postLoad,
  }) : super(key: key, child: const FFramePreload());

  final String title;
  final FirebaseOptions firebaseOptions;
  final List<ProviderConfiguration>? providerConfigs;
  final NavigationConfig navigationConfig;
  final ThemeData darkMode;
  final ThemeData lightMode;
  final L10nConfig l10nConfig;
  final bool debugShowCheckedModeBanner;
  final List<Widget>? globalActions;
  final PostLoad? postLoad;

  FFrameUser? user;

  static Fframe? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Fframe>();
  }

  String? errorText;
  String? waitText;

  Widget showErrorPage({required BuildContext context, required String errorText}) {
    this.errorText = errorText;
    return FRouter.of(context).errorPage(context: context);
  }

  Widget showWaitPage({required BuildContext context, required String waitText}) {
    this.waitText = waitText;
    return FRouter.of(context).errorPage(context: context);
  }

  @override
  bool updateShouldNotify(Fframe oldWidget) {
    return true;
  }
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
      future: Firebase.initializeApp(options: Fframe.of(context)!.firebaseOptions),
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
                debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
                title: "lalala",
                home: Scaffold(
                  body: Fframe.of(context)!.navigationConfig.errorPage.contentPane!,
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

        return const FrouterLoader();
      },
    );
  }
}

class FrouterLoader extends ConsumerStatefulWidget {
  const FrouterLoader({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FrouterLoaderState();
}

class _FrouterLoaderState extends ConsumerState<FrouterLoader> {
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
                debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
                home: Scaffold(
                  body: Fframe.of(context)!.navigationConfig.errorPage.contentPane!,
                ),
              );
            }

            //Store the user
            if (snapshot.data != null) {
              Fframe.of(context)!.user = FFrameUser.fromFirebaseUser(firebaseUser: snapshot.data!);
            } else {
              Fframe.of(context)!.user = null;
            }

            return FRouterLoader(
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
  _EmailAuthManagerState createState() => _EmailAuthManagerState();
}

class _EmailAuthManagerState extends State<EmailAuthManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("dynamic link research: ${Uri.base} => ${FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())}");
    Uri uri = Uri.parse(Uri.base.toString().replaceAll("/#/", "/"));

    if (FirebaseAuth.instance.isSignInWithEmailLink(Uri.base.toString())) {
      if (uri.queryParameters.containsKey("hash")) {
        String hash = uri.queryParameters["hash"]!;
        String emailAddress = utf8.decode(base64.decode(hash));
        debugPrint(emailAddress);

        debugPrint(emailAddress);
        return FutureBuilder<UserCredential>(
            future: FirebaseAuth.instance.signInWithEmailLink(email: emailAddress, emailLink: Uri.base.toString()),
            builder: (BuildContext context, AsyncSnapshot<UserCredential> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.waiting:
                  return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.active:
                  return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    debugPrint("Link sign in failed: ${snapshot.error}");
                    return const FframeBuilder();
                  }

                  UserCredential? userCredential = snapshot.data;
                  debugPrint("Resulting user: ${userCredential?.user?.email}");
                  return const FframeBuilder();
              }
            });
      } else {
        debugPrint("emailAddress not found in hash");
      }
    }
    return const FframeBuilder();
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
      return const FframeBuilder();
    }
    return FutureBuilder<void>(
      future: Fframe.of(context)!.postLoad!(context),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Fframe.of(context)!.navigationConfig.waitPage.contentPane ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          case ConnectionState.done:
            if (snapshot.error != null) {
              return MaterialApp(
                debugShowCheckedModeBanner: Fframe.of(context)!.debugShowCheckedModeBanner,
                title: Fframe.of(context)?.title ?? "TODO: Configure the freaking language engine",
                home: Scaffold(
                  body: Fframe.of(context)!.navigationConfig.errorPage.contentPane!,
                ),
              );
            }
            return const FframeBuilder();
        }
      },
    );
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
      themeMode: ThemeMode.system,
      locale: L10n.getLocale(),
      title: Fframe.of(context)!.title,
    );
  }
}

typedef PostLoad = Function(
  BuildContext context,
);
