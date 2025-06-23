# Project TODOs

This file lists the outstanding tasks and improvements for the `fframe` project, extracted from the original documentation.

### Documentation & Setup Scripts

-   **Create Fixture Script for `fframe` Collection:**
    -   The installation process requires creating an `fframe/` collection in Firestore. A script should be created to automate this setup.
    -   *Original Note: `create fframe/ collection with (TODO: fixture script)`*

-   **Automate Domain Configuration:**
    -   The `config.ts` file in the Firebase Functions requires manual entry of authorized domains. This should be scripted or centralized.
    -   *Original Note: `adjust firebase/functions/src/fframe-auth/config.ts to your domains (TODO: either script this, or make it use some shared config from somewhere)`*

-   **Clarify Cloud Function Permissions:**
    -   The installation guide needs a clearer explanation of how to set permissions for the Cloud Functions to allow all users to call them.
    -   *Original Note: `make sure the cloud functions permissions are set to allUsers can call Cloud Function (TODO: explain better)`*

### Optional Features & Examples

-   **Fixture Script for Suggestions:**
    -   Provide a fixture script to automatically add the `suggestions` collection and data for the example route.
    -   *Original Note: `remove the suggestions route (main.js, uncomment [suggestionNavigationTarget]) or run the (TODO: fixture script) to add suggestions to your app`*

-   **Fixture Script for Settings:**
    -   Provide a fixture script to add pre-configured settings documents for the example route.
    -   *Original Note: `remove or adjust the settings route (main.js, uncomment [settingNavigationTarget]) or run the (TODO: fixture script) to add preconfigured routes for settings to your app`* 