import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { default as config } from "./config";

if (!admin.apps.length) {
  admin.initializeApp();
}
admin.firestore().settings({ ignoreUndefinedProperties: true });
const db = admin.firestore();
const auth = admin.auth();

// Roles that grant user/role-management privileges. A caller must hold one of
// these to use the role-management callables.
const MANAGEMENT_ROLES = ["superadmin", "useradmin", "rolemanager"];

// Roles that only a superadmin may grant or revoke. Without this restriction a
// delegated role-manager could mint a superadmin (or peer manager) they control
// and escalate to full administrative access.
const PRIVILEGED_ROLES = ["superadmin", "useradmin", "rolemanager"];

const normalizeRoles = (roles: unknown): string[] =>
  Array.isArray(roles)
    ? roles.filter((r): r is string => typeof r === "string").map((r) => r.toLowerCase())
    : [];

const getRoles = async (uid: string): Promise<string[]> => {
  const claims = (await auth.getUser(uid)).customClaims;
  return claims && Array.isArray(claims["roles"]) ? (claims["roles"] as string[]) : [];
};

// Re-throw known HttpsErrors untouched; otherwise log the real cause server-side
// and return a generic message so internal error detail — and user-existence
// oracles from auth.getUser — never reach the client.
const toClientError = (context: string, e: unknown): functions.https.HttpsError => {
  if (e instanceof functions.https.HttpsError) {
    return e;
  }
  console.error(`${context} failed:`, e);
  return new functions.https.HttpsError("internal", "The request could not be completed.");
};


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
      // Atomically claim the "first user" slot so the initial SuperAdmin is
      // assigned exactly once, even under concurrent first-time sign-ups — the
      // previous `listUsers(2).length == 1` heuristic was a racy check-then-act.
      const bootstrapRef = db.doc("fframe/bootstrap");
      const isFirstUser = await db.runTransaction(async (tx) => {
        const snap = await tx.get(bootstrapRef);
        if (snap.exists && snap.get("initialAdminAssigned") === true) {
          return false;
        }
        tx.set(
          bootstrapRef,
          { initialAdminAssigned: true, initialAdminUid: user.uid },
          { merge: true },
        );
        return true;
      });

      const customClaims = isFirstUser ? config.initialUserRoles : config.defaultUserRoles;

      // Set custom user claims on this newly created user.
      await auth.setCustomUserClaims(user.uid, customClaims);

      const tmpUser: any = (await auth.getUser(user.uid)).toJSON();
      tmpUser.active = true;

      // Create a user firestore document in the users collection after refetching
      // the user from auth.
      await db.collection("users").doc(user.uid).set(tmpUser);
      console.log(`Processed ${user.email}`);
    } catch (error) {
      throw new Error(`processSignUp failed: ${error}`);
    }
  } else {
    console.log(`Did not process ${user.email}`);
  }
});


exports.getUserRoles = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  if (!context.auth) {
    throw new functions.https.HttpsError("permission-denied", "Authentication failed");
  }
  try {
    const callerRoles = normalizeRoles(await getRoles(context.auth.uid));
    const callerIsManager = MANAGEMENT_ROLES.some((r) => callerRoles.includes(r));

    // Only managers may read another user's roles; everyone else is pinned to
    // their own uid regardless of the payload. Previously any authenticated user
    // could read anyone's roles via a caller-supplied uid (IDOR).
    const requestedUid = payLoad && payLoad["uid"];
    const uid = callerIsManager && requestedUid ? requestedUid : context.auth.uid;

    return await getRoles(uid);
  } catch (e) {
    throw toClientError("getUserRoles", e);
  }
});


exports.addUserRole = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  if (!context.auth) {
    throw new functions.https.HttpsError("permission-denied", "Authentication failed");
  }
  try {
    const uid = payLoad && payLoad["uid"];
    const role = payLoad && payLoad["role"];

    // Validate inputs before any lookups; reject non-string/empty roles so no
    // malformed value is ever written into the security-relevant claims array.
    if (!uid || typeof uid !== "string" || !role || typeof role !== "string" || role.trim() === "") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "uid and role are mandatory non-empty strings.",
      );
    }

    const callerRoles = normalizeRoles(await getRoles(context.auth.uid));
    if (!MANAGEMENT_ROLES.some((r) => callerRoles.includes(r))) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Calling user has insufficient role assignments.",
      );
    }

    // Only a superadmin may grant a privileged/management role.
    if (PRIVILEGED_ROLES.includes(role.toLowerCase()) && !callerRoles.includes("superadmin")) {
      throw new functions.https.HttpsError(
        "permission-denied",
        `Only a superadmin may grant the '${role}' role.`,
      );
    }

    if (uid === context.auth.uid && !callerRoles.includes("superadmin")) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "User cannot change their own roles.",
      );
    }

    // Add the requested role to the target's existing roles (deduplicated).
    const roles = await getRoles(uid);
    if (!roles.includes(role)) {
      roles.push(role);
    }
    const newClaims = { roles };

    await auth.setCustomUserClaims(uid, newClaims);
    // Await the mirror write so failures surface and claims/Firestore stay in
    // sync rather than silently diverging.
    await db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

    // Echo the current settings
    return roles;
  } catch (e) {
    throw toClientError("addUserRole", e);
  }
});


exports.removeUserRole = functions.region("europe-west1").https.onCall(async (payLoad, context: functions.https.CallableContext) => {
  // Authentication / user information is automatically added to the request.
  if (!context.auth) {
    throw new functions.https.HttpsError("permission-denied", "Authentication failed");
  }
  try {
    const uid = payLoad && payLoad["uid"];
    const role = payLoad && payLoad["role"];

    if (!uid || typeof uid !== "string" || !role || typeof role !== "string" || role.trim() === "") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "uid and role are mandatory non-empty strings.",
      );
    }

    const callerRoles = normalizeRoles(await getRoles(context.auth.uid));
    if (!MANAGEMENT_ROLES.some((r) => callerRoles.includes(r))) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Calling user has insufficient role assignments.",
      );
    }

    // Only a superadmin may revoke a privileged/management role.
    if (PRIVILEGED_ROLES.includes(role.toLowerCase()) && !callerRoles.includes("superadmin")) {
      throw new functions.https.HttpsError(
        "permission-denied",
        `Only a superadmin may revoke the '${role}' role.`,
      );
    }

    if (uid === context.auth.uid && !callerRoles.includes("superadmin")) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "User cannot change their own roles.",
      );
    }

    const roles = (await getRoles(uid)).filter((r) => r !== role);
    const newClaims = { roles };

    await auth.setCustomUserClaims(uid, newClaims);
    await db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

    // Echo the current settings
    return roles;
  } catch (e) {
    throw toClientError("removeUserRole", e);
  }
});
