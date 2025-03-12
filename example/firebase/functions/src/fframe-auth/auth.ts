import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { default as config } from "./config";

if (!admin.apps.length) {
  admin.initializeApp();
}
admin.firestore().settings({ ignoreUndefinedProperties: true });
const db = admin.firestore();
const auth = admin.auth();


// On sign up.
// TODO: get the function region into a config file
exports.processSignUp = functions.region("europe-west1").auth.user().onCreate(async (user) => {
  // Check if user meets role criteria.
  if (
    user.email &&
    config.authorizedEmailMasks.map((authorizedEmailMask) => user.email?.endsWith(authorizedEmailMask)).includes(true) &&
    user.emailVerified
  ) {
    try {
      // Check if we already have users
      const customClaims = (await auth.listUsers(2)).users.length == 1 ? config.initialUserRoles : config.defaultUserRoles;

      // Set custom user claims on this newly created user.
      await auth.setCustomUserClaims(user.uid, customClaims);

      var tmpUser: any = (await auth.getUser(user.uid)).toJSON();
      tmpUser.active = true;

      // Create an user firestore document in users collection. After refetching the user from auth
      await db.collection("users").doc(user.uid).set(tmpUser).catch((reason) => {
        throw new Error(reason);
      });
      console.log(`Processed ${user.email}`);
    } catch (error) {
      throw new Error(`${error}`);
    }
  } else {
    console.log(`Did not process ${user.email}`);
  }
});


exports.getUserRoles = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  console.log(context.auth);
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Authentication failed",
    );
  }
  try {
    const uid = payLoad["uid"] || context.auth.uid;


    console.log("Request accepted");
    const customClaims = (await auth.getUser(uid)).customClaims;
    if (customClaims && customClaims["roles"]) {
      return customClaims["roles"];
    }

    return [];
  } catch (e) {
    throw new functions.https.HttpsError("invalid-argument", `${e}`);
  }
});


exports.addUserRole = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Authentication failed",
    );
  }
  try {
    console.log("Check caller roles");

    // Get the payload
    const uid = payLoad["uid"];
    const role = payLoad["role"];

    const callerClaims = (await auth.getUser(context.auth.uid)).customClaims;
    let callerRoles: string[];
    if (callerClaims && callerClaims["roles"]) {
      callerRoles = callerClaims["roles"].map((role: string) => role.toLowerCase());
      if (!(
        callerRoles.includes("superadmin") ||
        callerRoles.includes("useradmin") ||
        callerRoles.includes("rolemanager"
        ))) {
        throw new functions.https.HttpsError(
          "permission-denied",
          `Calling user has insufficient role assignments: ${callerRoles.join(", ")}`,
        );
      }
    } else {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Calling user has insufficient role assignments",
      );
    }

    if (uid == context.auth.uid && !(callerRoles.includes("superadmin"))) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "User cannot change their own roles.",
      );
    }
    console.log("Request accepted", payLoad);
    // Process the request

    if (!uid || !role) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        `uid and role are mandatory. received: uid= ${uid} role=${role}`,
      );
    }

    // Get the current roles and add the new role to the current listed roles
    let customClaims = (await auth.getUser(uid)).customClaims;
    if (customClaims) {
      if (customClaims["roles"]) {
        customClaims["roles"].push(role);
      }
    } else {
      customClaims = { roles: [role] };
    }

    // Update the user auth in Firestore auth
    customClaims["roles"] = customClaims["roles"].filter((value: string, index: number, self: string[]) => {
      return self.indexOf(value) === index;
    });
    await auth.setCustomUserClaims(uid, customClaims);

    db.doc(`users/${uid}`).set({ customClaims: customClaims }, { merge: true });

    // Echo the current settings
    return customClaims["roles"];
  } catch (e) {
    throw new functions.https.HttpsError("invalid-argument", `${e}`);
  }
});


exports.removeUserRole = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Authentication failed",
    );
  }
  try {
    console.log("Check caller roles");

    // Get the payload
    const uid = payLoad["uid"];
    const role = payLoad["role"];

    const callerClaims = (await auth.getUser(context.auth.uid)).customClaims;
    let callerRoles: string[];
    if (callerClaims && callerClaims["roles"]) {
      callerRoles = callerClaims["roles"].map((role: string) => role.toLowerCase());
      if (!(
        callerRoles.includes("superadmin") ||
        callerRoles.includes("useradmin") ||
        callerRoles.includes("rolemanager"
        ))) {
        throw new functions.https.HttpsError(
          "permission-denied",
          `Calling user has insufficient role assignments: ${callerRoles.join(", ")}`,
        );
      }
    } else {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Calling user has insufficient role assignments",
      );
    }

    if (uid == context.auth.uid && !(callerRoles.includes("superadmin"))) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "User cannot change their own roles.",
      );
    }
    console.log("Request accepted", payLoad);
    // Process the request

    if (!uid || !role) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        `uid and role are mandatory. received: uid= ${uid} role=${role}`,
      );
    }


    // Get the current roles and add the new role to the current listed roles
    let customClaims = (await auth.getUser(uid)).customClaims;
    if (customClaims) {
      if (customClaims["roles"]) {
        customClaims["roles"];
        const index = customClaims["roles"].indexOf(role, 0);
        if (index > -1) {
          customClaims["roles"].splice(index, 1);
        }
      }
    } else {
      customClaims = { roles: [] };
    }

    // Update the user auth in Firestore auth
    customClaims["roles"] = customClaims["roles"].filter((value: string, index: number, self: string[]) => {
      return self.indexOf(value) === index;
    });
    await auth.setCustomUserClaims(uid, customClaims);

    db.doc(`users/${uid}`).set({ customClaims: customClaims }, { merge: true });

    // Echo the current settings
    return customClaims["roles"];
  } catch (e) {
    throw new functions.https.HttpsError("invalid-argument", `${e}`);
  }
});

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
