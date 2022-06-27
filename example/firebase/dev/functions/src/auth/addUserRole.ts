import * as functions from "firebase-functions";
import { auth, db, makeFunction } from "../firebase";

const canManageUsers = (callerRoles: string[]) => {
  const roles = ["superadmin", "useradmin", "rolemanager"];

  return roles.some((role) => callerRoles.includes(role));
};

type CustomClaims = {
  roles: string[];
};

const getCustomClaims = async (uid: string): Promise<CustomClaims> => {
  const claims = (await auth.getUser(uid)).customClaims;

  return {
    roles: claims?.roles || [],
  };
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
      const { uid, role } = payLoad;

      if (!uid || !role) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          `uid and role are mandatory. received: uid= ${uid} role=${role}`
        );
      }

      const callerClaims = (await auth.getUser(context.auth.uid)).customClaims;

      if (!callerClaims || !callerClaims.roles) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Calling user has insufficient role assignments"
        );
      }

      const callerRoles = callerClaims["roles"].map((role: string) =>
        role.toLowerCase()
      );

      if (!canManageUsers(callerRoles)) {
        throw new functions.https.HttpsError(
          "permission-denied",
          `Calling user has insufficient role assignments: ${callerRoles.join(
            ", "
          )}`
        );
      }

      if (uid == context.auth.uid && !callerRoles.includes("superadmin")) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User cannot change their own roles."
        );
      }

      // Get the current roles and add the new role to the current listed roles
      const customClaims = await getCustomClaims(uid);

      const newClaims = {
        ...customClaims,
        roles: [...customClaims.roles, role],
      };

      await auth.setCustomUserClaims(uid, newClaims);

      db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

      return newClaims.roles;
    } catch (e) {
      throw new functions.https.HttpsError("invalid-argument", `${e}`);
    }
  }
);
