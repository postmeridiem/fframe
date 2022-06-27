import * as functions from "firebase-functions";
import { auth, makeFunction } from "../firebase";

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
      const { uid } = payLoad || context.auth;

      const customClaims = (await auth.getUser(uid)).customClaims;

      return customClaims?.roles ?? [];
    } catch (e) {
      throw new functions.https.HttpsError("invalid-argument", `${e}`);
    }
  }
);
