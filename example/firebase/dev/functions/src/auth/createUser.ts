import { randomUUID } from "crypto";
import * as nodemailer from "nodemailer";
import * as functions from "firebase-functions";
import { DocumentSnapshot } from "firebase-functions/v1/firestore";
import { auth, db, makeFunction } from "../firebase";

type Invite = {
  email: string;
  customClaims: {
    roles: string[];
  };
  clientId: string;
  createdBy?: string;
};

// Roles that may only be provisioned when the invite's creator is a superadmin.
const PRIVILEGED_ROLES = ["superadmin", "useradmin", "rolemanager"];

const isSuperadmin = async (uid?: string): Promise<boolean> => {
  if (!uid) {
    return false;
  }
  try {
    const claims = (await auth.getUser(uid)).customClaims;
    const roles = Array.isArray(claims?.roles) ? claims!.roles : [];
    return roles.map((r: string) => String(r).toLowerCase()).includes("superadmin");
  } catch {
    return false;
  }
};

export const createUser = makeFunction()
  .runWith({ secrets: ["SMTP_KEY"] })
  .firestore.document("invites/{inviteId}")
  .onCreate(async (snapshot: DocumentSnapshot) => {
    const mailTransport = nodemailer.createTransport({
      service: "SendinBlue",
      auth: {
        user: "info@churned.nl",
        pass: process.env.SMTP_KEY,
      },
    });

    try {
      const {
        email,
        customClaims: { roles },
        clientId,
        createdBy,
      }: Invite = snapshot.data() as Invite;

      // Validate the requested roles are an array of strings before any of them
      // are written into a user's security-relevant custom claims.
      if (!Array.isArray(roles) || roles.some((r) => typeof r !== "string")) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "invite.customClaims.roles must be an array of strings."
        );
      }

      // Privileged roles may only be provisioned when the invite creator is a
      // superadmin; otherwise strip them. This is the trigger-side defense that
      // backs the Firestore-rules restriction on who may create an invite, and
      // prevents an ordinary admin (or, absent rules, any writer) from
      // provisioning a SuperAdmin they control.
      const requestsPrivileged = roles.some((r) =>
        PRIVILEGED_ROLES.includes(r.toLowerCase())
      );
      const grantedRoles =
        requestsPrivileged && !(await isSuperadmin(createdBy))
          ? roles.filter((r) => !PRIVILEGED_ROLES.includes(r.toLowerCase()))
          : roles;

      const userExists = await db
        .collection("users")
        .where("email", "==", email)
        .get();

      if (userExists.size >= 1) {
        throw new functions.https.HttpsError(
          "already-exists",
          "User already exists"
        );
      }

      // Never delete an existing auth account based solely on an email from an
      // invite document — that enabled account takeover / denial of service. If
      // an auth user already exists for this email, abort instead of recreating.
      try {
        const authUser = await auth.getUserByEmail(email);
        if (authUser) {
          throw new functions.https.HttpsError(
            "already-exists",
            "An account already exists for this email."
          );
        }
      } catch (err) {
        if (err instanceof functions.https.HttpsError) {
          throw err;
        }
        // auth/user-not-found — no existing account, safe to continue.
      }

      const user = await auth.createUser({
        email,
        password: randomUUID(),
      });

      const { uid } = user;

      await auth.setCustomUserClaims(uid, { roles: grantedRoles });

      const userData = (await auth.getUser(uid)).toJSON();

      await db
        .collection("users")
        .doc(uid)
        .set({
          ...userData,
          clientId,
        });

      if (!user.email) {
        return null;
      }

      const link = await auth.generateSignInWithEmailLink(user.email, {
        url: `https://dash.churned.io/process-signup?email=${user.email}`,
        handleCodeInApp: true,
      });

      return mailTransport.sendMail({
        to: email,
        from: "info@churned.nl",
        subject: "Your Churned dash account",
        html: `Click <a href="${link}">here</a> to activate and complete your dash account.`,
      });
    } catch (error) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new Error(`createUser failed: ${error}`);
    }
  });
