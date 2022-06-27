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
      }: Invite = snapshot.data() as Invite;

      const userExists = await db
        .collection("users")
        .where("email", "==", email)
        .get();

      if (userExists.size === 1) {
        throw new functions.https.HttpsError(
          "already-exists",
          "User already exists"
        );
      }

      try {
        const authUser = await auth.getUserByEmail(email);

        if (authUser) {
          await auth.deleteUser(authUser.uid);
        }
      } catch (err) {
        // user doesn't exist, continue
      }

      // If user exists, but is not in DB. Recreate
      const user = await auth.createUser({
        email,
        password: randomUUID(),
      });

      const { uid } = user;

      await auth.setCustomUserClaims(uid, { roles });

      const userData = (await auth.getUser(uid)).toJSON();

      await db
        .collection("users")
        .doc(uid)
        .set({
          ...userData,
          clientId,
        })
        .catch((reason) => {
          throw new Error(reason);
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
      throw new Error(`${error}`);
    }
  });
