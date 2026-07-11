import * as functions from "firebase-functions";
import { auth, db, makeFunction } from "../firebase";

// Roles that grant user/role-management privileges.
const MANAGEMENT_ROLES = ["superadmin", "useradmin", "rolemanager"];

// Roles that only a superadmin may grant or revoke.
const PRIVILEGED_ROLES = ["superadmin", "useradmin", "rolemanager"];

const canManageUsers = (callerRoles: string[]) =>
  MANAGEMENT_ROLES.some((role) => callerRoles.includes(role));

type CustomClaims = {
  roles: string[];
};

const getCustomClaims = async (uid: string): Promise<CustomClaims> => {
  const claims = (await auth.getUser(uid)).customClaims;

  return {
    roles: Array.isArray(claims?.roles) ? claims!.roles : [],
  };
};

const toClientError = (
  context: string,
  e: unknown
): functions.https.HttpsError => {
  if (e instanceof functions.https.HttpsError) {
    return e;
  }
  console.error(`${context} failed:`, e);
  return new functions.https.HttpsError(
    "internal",
    "The request could not be completed."
  );
};

export const addUserRole = makeFunction().https.onCall(
  async (payLoad, context: functions.https.CallableContext) => {
    // Authentication / user information is automatically added to the request.
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Authentication failed"
      );
    }
    try {
      // Get the payload
      const { uid, role } = payLoad || {};

      if (
        !uid ||
        typeof uid !== "string" ||
        !role ||
        typeof role !== "string" ||
        role.trim() === ""
      ) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "uid and role are mandatory non-empty strings."
        );
      }

      const callerClaims = (await auth.getUser(context.auth.uid)).customClaims;

      if (!callerClaims || !callerClaims.roles) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Calling user has insufficient role assignments"
        );
      }

      const callerRoles = callerClaims["roles"].map((r: string) =>
        String(r).toLowerCase()
      );

      if (!canManageUsers(callerRoles)) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Calling user has insufficient role assignments"
        );
      }

      // Only a superadmin may grant a privileged/management role, otherwise a
      // delegated role-manager could mint a superadmin they control.
      if (
        PRIVILEGED_ROLES.includes(role.toLowerCase()) &&
        !callerRoles.includes("superadmin")
      ) {
        throw new functions.https.HttpsError(
          "permission-denied",
          `Only a superadmin may grant the '${role}' role.`
        );
      }

      if (uid === context.auth.uid && !callerRoles.includes("superadmin")) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User cannot change their own roles."
        );
      }

      // Add the new role to the target's existing roles (deduplicated).
      const customClaims = await getCustomClaims(uid);
      const roles = customClaims.roles.includes(role)
        ? customClaims.roles
        : [...customClaims.roles, role];

      const newClaims = {
        ...customClaims,
        roles,
      };

      await auth.setCustomUserClaims(uid, newClaims);
      // Await the mirror write so failures surface and claims/Firestore stay in
      // sync.
      await db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

      return newClaims.roles;
    } catch (e) {
      throw toClientError("addUserRole", e);
    }
  }
);
