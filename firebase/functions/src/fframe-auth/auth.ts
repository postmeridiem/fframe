
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {default as config} from "./config";

if (!admin.apps.length) {
  admin.initializeApp();
}
admin.firestore().settings({ignoreUndefinedProperties: true});
const db = admin.firestore();
const auth = admin.auth();



// On sign up.

exports.processSignUp = functions.region("europe-west1").auth.user().onCreate(async (user) => {
  // Check if user meets role criteria.
  if (
    user.email &&
    config.authorizedDomains.map((authorizedDomain) => user.email?.endsWith(authorizedDomain)).includes(true) &&
    user.emailVerified
  ) {
    try {
      // Check if we already have users
      const customClaims = (await auth.listUsers(2)).users.length==1?config.initialUserRoles :config.defaultUserRoles;

      // Set custom user claims on this newly created user.
      await auth.setCustomUserClaims(user.uid, customClaims);

      // Create an user firestore document in users collection. After refetching the user from auth
      await db.collection("users").doc(user.uid).set((await auth.getUser(user.uid)).toJSON()).catch((reason) => {
        throw new Error(reason);
      });
    } catch (error) {
      throw new Error(`${error}`);
    }
  } else {
    console.log(`Did not process ${user.email}`);
  }
});


// exports.callLambda = functions.region("europe-west1").https.onCall(async (payLoad: JSON, context: functions.https.CallableContext) => {
//   // Authentication / user information is automatically added to the request.
//   if (!context.auth) {
//     throw new functions.https.HttpsError(
//       "failed-precondition",
//       "Authentication failed",
//     );
//   }

//     getAuth(context.auth.uid)


//   // return admin.auth().setCustomUserClaims(
//   //   context.params.docId,
//   //   claims
//   // );

// });

// /**
//  * Adds two numbers together.
//  * @param {string} url The first number.
//  * @param {string} email The first number.
//  * @param {string} displayName The first number.
//  * @param {string} bundleId The first number.
//  * @param {string} packageName The first number.
// //  * @returns {bool} The sum of the two numbers.
//  */
// export async function inviteNewUser(url: string, email: string, displayName: string, bundleId: string, packageName: string,) {
//   const actionCodeSettings = {
//     // The URL to redirect to for sign-in completion. This is also the deep
//     // link for mobile redirects. The domain (www.example.com) for this URL
//     // must be whitelisted in the Firebase Console.
//     url: url,
//     iOS: {
//       bundleId: bundleId,
//     },
//     android: {
//       packageName: packageName,
//       installApp: true,
//       minimumVersion: "12",
//     },
//     // This must be true.
//     handleCodeInApp: true,
//     dynamicLinkDomain: "custom.page.link",
//   };
//   admin.auth()
//     .generateSignInWithEmailLink(email, actionCodeSettings)
//     .then(function(link) {
//       // The link was successfully generated.
//       // Construct sign-in with email link template, embed the link and
//       // send using custom SMTP server.
//       // return sendSignInEmail(email, displayName, link);
//     })
//     .catch(function(error) {
//       // Some error occurred, you can inspect the code: error.code
//     });
// }
