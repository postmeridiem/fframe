import * as functions from "firebase-functions";
import { auth, db, makeFunction } from "../firebase";

type CustomClaims = {
  roles: string[];
};

type Payload = {
  role: string;
  uid: string;
};

// Roles that grant user/role-management privileges.
const MANAGEMENT_ROLES = ["superadmin", "useradmin", "rolemanager"];

// Roles that only a superadmin may grant or revoke.
const PRIVILEGED_ROLES = ["superadmin", "useradmin", "rolemanager"];

const canManageUsers = (callerRoles: string[]) =>
  MANAGEMENT_ROLES.some((role) => callerRoles.includes(role));

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

export const removeUserRole = makeFunction().https.onCall(
  async (payLoad: Payload, context: functions.https.CallableContext) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Authentication failed"
      );
    }
    try {
      const { uid, role } = payLoad || ({} as Payload);

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

      const callerRoles = callerClaims.roles.map((r: string) =>
        String(r).toLowerCase()
      );

      if (!canManageUsers(callerRoles)) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Calling user has insufficient role assignments"
        );
      }

      // Only a superadmin may revoke a privileged/management role.
      if (
        PRIVILEGED_ROLES.includes(role.toLowerCase()) &&
        !callerRoles.includes("superadmin")
      ) {
        throw new functions.https.HttpsError(
          "permission-denied",
          `Only a superadmin may revoke the '${role}' role.`
        );
      }

      if (uid === context.auth.uid && !callerRoles.includes("superadmin")) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User cannot change their own roles."
        );
      }

      const customClaims: CustomClaims = await getCustomClaims(uid);

      const roles = customClaims.roles.filter((claimRole) => claimRole !== role);

      const newClaims = {
        ...customClaims,
        roles,
      };

      await auth.setCustomUserClaims(uid, newClaims);
      await db.doc(`users/${uid}`).set({ customClaims: newClaims }, { merge: true });

      // Echo the current settings
      return roles;
    } catch (e) {
      throw toClientError("removeUserRole", e);
    }
  }
);
