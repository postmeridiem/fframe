import * as functions from "firebase-functions";
import { auth, makeFunction } from "../firebase";

// Roles that grant user/role-management privileges.
const MANAGEMENT_ROLES = ["superadmin", "useradmin", "rolemanager"];

export const getUserRoles = makeFunction().https.onCall(
  async (payLoad, context: functions.https.CallableContext) => {
    // Authentication / user information is automatically added to the request.
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Authentication failed"
      );
    }
    try {
      const callerClaims = (await auth.getUser(context.auth.uid)).customClaims;
      const callerRoles = Array.isArray(callerClaims?.roles)
        ? callerClaims!.roles.map((r: string) => String(r).toLowerCase())
        : [];
      const callerIsManager = MANAGEMENT_ROLES.some((r) =>
        callerRoles.includes(r)
      );

      // Only managers may read another user's roles; everyone else is pinned to
      // their own uid regardless of the payload (prevents IDOR).
      const requestedUid = payLoad && payLoad.uid;
      const uid =
        callerIsManager && requestedUid ? requestedUid : context.auth.uid;

      const customClaims = (await auth.getUser(uid)).customClaims;

      return customClaims?.roles ?? [];
    } catch (e) {
      if (e instanceof functions.https.HttpsError) {
        throw e;
      }
      console.error("getUserRoles failed:", e);
      throw new functions.https.HttpsError(
        "internal",
        "The request could not be completed."
      );
    }
  }
);
