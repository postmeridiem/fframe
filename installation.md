- clone/copy the example dir from the project into a new project
- adjust pubspec.yaml namespace and version
- in pubspec.yaml, remove the active fframe dependency, and uncomment the sample in the lines above to replace it.
- do a find replace in your lib dir, replacing [example/] with [yournamespace/]
- run flutter pub get
- create an empty firestore project, on Blaze Plan (required due to built-in backend role enforcement)
- make sure you have google login enabled as option in in firestore. this is used for your admin account
- use the firebase [add app] to connect flutter app instructions to set up credentials
- create a firebase hosting setup to deploy your app to
- in the google cloud console, search for OAuth and set up your OAuth consent screen (set to internal to get started quickly)
- in the same page left go to [Credentials]
- in the [Browser key (auto created by Firebase)] record, switch restrictions to http referrers and add your localhost:[yourport], and any other urls you want to use this app on
- create fframe/ collection with (TODO: fixture script)
- adjust firebase/firestore.rules to list the domains you use
- adjust firebase/functions/src/fframe-auth/config.ts to your domains (TODO: either script this, or make it use some shared config from somewhere)
- adjust firebase/.firebaserc to show your firestore project
- run $ npm install in firebase/functions
- NOTE: the example project is configured to run in europe-west1. Adjust the typescript code to correct this if you are running in another region.
- deploy the firebase support functions, by navigating to the firebase dir and running $ firebase deploy. This will create the infrastructure for role enforcement.
- make sure the cloud functions permissions are set to allUsers can call Cloud Function (TODO: explain better)
- run your app and use the Login button. This will create a firebase authentication record for your Google profile. This is the first created profile, so it should have been auto created with SuperUser role (allowing role management on accounts)
- create the appropriate indexes for the user view by navigating to users and following the link presented there


optional bits:
- remove the suggestions route (main.js, uncomment [suggestionNavigationTarget]) or run the (TODO: fixture script) to add suggestions to your app
- remove or adjust the settings route (main.js, uncomment [settingNavigationTarget]) or run the (TODO: fixture script) to add preconfigured routes for settings to your app
