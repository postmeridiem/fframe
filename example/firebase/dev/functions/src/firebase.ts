import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

if (!admin.apps.length) {
  admin.initializeApp();
}

admin.firestore().settings({ ignoreUndefinedProperties: true });

export const db = admin.firestore();
export const auth = admin.auth();

export const makeFunction = (region = "europe-west1") => {
  return functions.region(region);
};
