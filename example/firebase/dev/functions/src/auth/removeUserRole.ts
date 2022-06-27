import * as functions from "firebase-functions";
import { auth, db, makeFunction } from "../firebase";

type CustomClaims = {
  roles: string[];
};

type Payload = {
  role: string;
  uid: string;
};

const canManageUsers = (callerRoles: string[]) => {
  const roles = ["superadmin", "useradmin", "rolemanager"];

  return roles.some((role) => callerRoles.includes(role));
};

const getCustomClaims = async (uid: string): Promise<CustomClaims> => {
  const claims = (await auth.getUser(uid)).customClaims;

  return {
    roles: claims?.roles || [],
  };
};

export const removeUserRole = makeFunction().https.onCall(
  async (payLoad: Payload, context: functions.https.CallableContext) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Authentication failed"
      );
    }
    try {
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

      const callerRoles = callerClaims.roles.map((role: string) =>
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

      if (uid === context.auth.uid && !callerRoles.includes("superadmin")) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User cannot change their own roles."
        );
      }

      const customClaims: CustomClaims = await getCustomClaims(uid);

      const roles = customClaims.roles.filter(
        (claimRole) => claimRole !== role
      );

      const newClaims = {
        ...customClaims,
        roles,
      };

      await auth.setCustomUserClaims(uid, newClaims);
      db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

      // Echo the current settings
      return roles;
    } catch (e) {
      throw new functions.https.HttpsError("invalid-argument", `${e}`);
    }
  }
);
