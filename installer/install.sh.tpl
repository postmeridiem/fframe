#!/bin/bash

# fframe Installation Script
# This script automates the setup of a new Flutter project using the fframe framework.
#
# Compatibility:
# - macOS: Runs natively.
# - Linux: Runs natively.
# - Windows: Requires a Bash environment like Git Bash (recommended) or WSL.

# --- Helper Functions for Colors ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[0;33m'

info() {
    echo -e "${C_BLUE}INFO: $1${C_RESET}"
}

success() {
    echo -e "${C_GREEN}SUCCESS: $1${C_RESET}"
}

error() {
    echo -e "${C_RED}ERROR: $1${C_RESET}" >&2
}

prompt() {
    echo -e "${C_YELLOW}$1${C_RESET}"
}

# --- Platform & Dependency Checks ---
os_check() {
    OS="$(uname -s)"
    case "$OS" in
        Linux*)     MACHINE=Linux;;
        Darwin*)    MACHINE=macOS;;
        CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
        *)          MACHINE="UNKNOWN:${OS}"
    esac

    if [ "$MACHINE" = "Windows" ]; then
        prompt "--------------------------------- NOTE ----------------------------------"
        info "Running on Windows. Please ensure you are using a Bash shell"
        info "like Git Bash (recommended) or WSL for this script to work correctly."
        prompt "--------------------------------------------------------------------------"
        echo ""
    elif [ "$MACHINE" = "UNKNOWN" ]; then
        error "Running on an unsupported operating system. The script may not work correctly."
        # Do not exit, let the user try anyway
    fi
}

check_dep() {
    if ! command -v "$1" &> /dev/null; then
        error "$1 could not be found. Please install it before running this script."
        exit 1
    fi
}

os_check
info "Checking dependencies..."
check_dep "flutter"
check_dep "firebase"
check_dep "git"
check_dep "npm"
check_dep "sed"
check_dep "tar"
check_dep "base64"
success "All dependencies are installed."

# --- Introduction ---
echo ""
info "Welcome to the fframe installation script!"
info "This will guide you through creating a new Flutter project configured with fframe."
echo ""

# --- Gather Information ---
prompt "Please enter the name for your new Flutter project (e.g., my_awesome_app):"
read -r APP_NAME

if [ -z "$APP_NAME" ]; then
    error "Project name cannot be empty."
    exit 1
fi

if [ -d "$APP_NAME" ]; then
    error "A directory named '$APP_NAME' already exists. Please remove it or choose a different name."
    exit 1
fi

prompt "Please enter your Firebase Project ID (e.g., my-firebase-project-12345):"
read -r FIREBASE_PROJECT_ID

if [ -z "$FIREBASE_PROJECT_ID" ]; then
    error "Firebase Project ID cannot be empty."
    exit 1
fi

# --- Flutter Project Creation ---
info "Creating new Flutter project: $APP_NAME..."
flutter create "$APP_NAME"
cd "$APP_NAME" || exit

# --- Update pubspec.yaml ---
info "Adding fframe and Firebase dependencies to pubspec.yaml..."
cat <<EOT >> pubspec.yaml

  # fframe and Firebase dependencies
  fframe:
    git:
      url: https://github.com/postmeridiem/fframe.git
      ref: main
  firebase_core:
  firebase_auth:
  cloud_firestore:
EOT

info "Fetching Flutter dependencies..."
flutter pub get

# --- Manual Firebase Steps ---
echo ""
prompt "------------------------- MANUAL ACTION REQUIRED (1/2) -------------------------"
info "Please open your web browser and complete the following steps in the Firebase Console:"
info "1. Go to https://console.firebase.google.com and create a project with ID: $FIREBASE_PROJECT_ID"
info "2. Upgrade the project to the 'Blaze (Pay-as-you-go)' plan."
info "3. In Project Settings, add a new Flutter app and follow the setup instructions."
info "   This will generate and place a 'lib/firebase_options.dart' file in your 'lib/' directory."
info "4. In the Authentication section, enable the 'Google' sign-in provider."
info "5. In the Cloud Firestore section, create a new database in 'production mode'."
prompt "--------------------------------------------------------------------------"
read -p "Press [Enter] to continue once you have completed these steps..."

if [ ! -f "lib/firebase_options.dart" ]; then
    error "'lib/firebase_options.dart' not found. Please ensure you completed the Firebase setup correctly."
    exit 1
fi
success "'lib/firebase_options.dart' found."


# --- Backend Setup ---
prompt "------------------------- MANUAL ACTION REQUIRED (2/2) -------------------------"
info "Next, we will initialize the Firebase backend using the official CLI."
info "In your terminal, please run the following command:"
info "firebase init"
echo ""
info "Select the following options when prompted:"
info " - Feature Selection: Use Spacebar to select 'Firestore', 'Functions', and 'Hosting'."
info " - Project Setup: Use an existing project, and select '$FIREBASE_PROJECT_ID'."
info " - Firestore: Accept the default file names ('firestore.rules' and 'firestore.indexes.json')."
info " - Functions: Select 'TypeScript' as the language. Choose 'y' for ESLint. Choose 'y' to install dependencies."
info " - Hosting: Use 'build/web' as your public directory. Configure as a single-page app ('y'). Do NOT set up automatic builds with GitHub ('n')."
prompt "--------------------------------------------------------------------------"
read -p "Press [Enter] to continue once you have run 'firebase init'..."

if [ ! -f "firebase.json" ]; then
    error "'firebase.json' not found. Please ensure you completed the 'firebase init' step correctly."
    exit 1
fi

info "Initialization complete. Now applying fframe-specific configurations..."

# Decode and extract the embedded backend configuration. The placeholder
# __FFRAME_PAYLOAD__ is replaced by the build script.
base64 --decode << 'END_OF_PAYLOAD' | tar xzf -
__FFRAME_PAYLOAD__
END_OF_PAYLOAD

success "Configuration files applied."

# --- Configure and Deploy Backend ---
info "Configuring authorized domains for authentication..."
HOSTING_DOMAIN="$FIREBASE_PROJECT_ID.web.app"
sed -i.bak "s/\"fframe-template.web.app\"/\"$HOSTING_DOMAIN\", \"localhost\"/g" "functions/src/fframe-auth/config.ts" && rm "functions/src/fframe-auth/config.ts.bak"
success "Domains configured."

info "Installing backend dependencies..."
(cd functions && npm install)

info "Please log in to Firebase with the Firebase CLI..."
firebase login

info "Deploying Firebase assets (rules, functions, hosting)... This may take a few minutes."
firebase deploy

# --- Final Instructions ---
info "Overwriting default 'lib/main.dart' with a starter template for fframe..."
cat <<EOT > lib/main.dart
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Fframe(
      title: "My fframe App",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      //TODO: configure your light and dark themes
      lightMode: ThemeData.light(),
      darkMode: ThemeData.dark(),
      //TODO: configure your l10n settings
      l10nConfig: L10nConfig(),
      //TODO: configure your console logger
      consoleLogger: Console(),
      navigationConfig: NavigationConfig(
        destinations: [
          //TODO: Add your FframeDestinations here
          FframeDestination(
            icon: Icons.home,
            label: "Home",
            path: "home",
            screenBuilder: (context) => const Center(
              child: Text("Welcome to fframe!"),
            ),
          ),
        ],
      ),
    );
  }
}
EOT

# --- Completion ---
echo ""
success "fframe project '$APP_NAME' created successfully!"
info "Next steps:"
info "1. Open the project in your favorite IDE: 'cd $APP_NAME'"
info "2. Run the app: 'flutter run'"
info "3. Log in with your Google account. You will be the first user and automatically get the 'SuperUser' role."
info "4. Start building your app by adding FframeDestinations to 'navigationConfig' in 'lib/main.dart'."

echo ""
info "To make this script easily accessible, you can upload it to a GitHub Gist or your repository and run it with:"
info "curl -sL <raw_script_url> | bash"
echo "" 