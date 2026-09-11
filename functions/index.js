/**
 * FutureMe — parent/guardian consent flow (age 14–15).
 *
 * Replaces the previously-simulated "EmailConsent -> SendEmailConsent ->
 * ConfirmConsent" client flow, where no email was ever sent and "Verifică
 * acordul" always succeeded. Real flow:
 *
 *   1. App calls `requestConsent({ parentEmail })` — creates a
 *      `consentRequests/{id}` doc (status: 'pending') and sends the email
 *      directly via Gmail SMTP (nodemailer), containing a link to
 *      `confirmConsent`. (Previously this went through the Firestore
 *      "Trigger Email" extension, but that extension's Cloud Function is
 *      Eventarc-triggered and Eventarc Firestore triggers do not support
 *      this project's `nam5` multi-region database — trigger creation/
 *      update fails with "Database does not exist in region us-central1".
 *      Sending directly from this plain callable sidesteps that platform
 *      limitation entirely.)
 *   2. The parent opens that link in a browser (no app/account needed) —
 *      `confirmConsent` verifies the token and flips the doc to 'confirmed'.
 *   3. The app polls `checkConsentStatus({ requestId })` from the
 *      "Verifică acordul" button and only proceeds once status is
 *      'confirmed'.
 *
 * The client never has permission to write `consentRequests` directly
 * (firestore.rules denies it by default) — only these Admin-SDK functions
 * can create/read/confirm a request, so a user cannot self-approve consent.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
const nodemailer = require("nodemailer");

admin.initializeApp();
const db = admin.firestore();

// Claude-backed dynamic module content (see ai.js).
const ai = require("./ai");
exports.generateModule1Questions = ai.generateModule1Questions;
exports.generateInsight = ai.generateInsight;

// Cloud Functions v1 (used here) gets a predictable URL of the form
// https://<region>-<projectId>.cloudfunctions.net/<name>, so the confirm
// link can be built without waiting for a post-deploy URL. Update REGION if
// you deploy functions to a region other than the default us-central1.
const PROJECT_ID = "futureme-a6ea7";
const REGION = "us-central1";
const CONFIRM_URL = `https://${REGION}-${PROJECT_ID}.cloudfunctions.net/confirmConsent`;

// Gmail account used to send consent emails. Its app password is bound via
// runWith({secrets: ["GMAIL_APP_PASSWORD"]}); set it once with:
//   firebase functions:secrets:set GMAIL_APP_PASSWORD
const GMAIL_USER = "ibraheemakin201@gmail.com";

function mailer() {
  return nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: { user: GMAIL_USER, pass: process.env.GMAIL_APP_PASSWORD },
  });
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const TOKEN_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 days

function renderHtmlPage(title, body) {
  return `<!doctype html>
<html lang="ro">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${title}</title>
<style>
  body { font-family: -apple-system, Roboto, Helvetica, Arial, sans-serif; max-width: 480px;
         margin: 72px auto; padding: 0 24px; color: #2B0B78; text-align: center; }
  h1 { font-size: 22px; }
  p { font-size: 16px; line-height: 1.5; color: #333; }
</style>
</head>
<body>
  <h1>${title}</h1>
  <p>${body}</p>
</body>
</html>`;
}

/**
 * Callable. Body: { parentEmail }. Creates the consent request and sends
 * the real email. Returns { requestId }.
 */
exports.requestConsent = functions.runWith({ secrets: ["GMAIL_APP_PASSWORD"] }).https.onCall(async (data) => {
  const parentEmail = String((data && data.parentEmail) || "").trim();
  if (!EMAIL_RE.test(parentEmail)) {
    throw new functions.https.HttpsError("invalid-argument", "Adresa de email a părintelui nu este validă.");
  }

  const token = crypto.randomBytes(32).toString("hex");
  const tokenHash = crypto.createHash("sha256").update(token).digest("hex");
  const docRef = db.collection("consentRequests").doc();
  const now = admin.firestore.Timestamp.now();

  await docRef.set({
    parentEmail,
    status: "pending",
    tokenHash,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    confirmedAt: null,
    expiresAt: admin.firestore.Timestamp.fromMillis(now.toMillis() + TOKEN_TTL_MS),
  });

  const confirmUrl = `${CONFIRM_URL}?id=${docRef.id}&token=${token}`;

  try {
    await mailer().sendMail({
      from: GMAIL_USER,
      to: parentEmail,
      subject: "FutureMe – cerere de acord părinte/tutore",
      html: `
        <p>Bună,</p>
        <p>Copilul dumneavoastră dorește să folosească aplicația FutureMe, un ghid pas cu pas de autocunoaștere,
           și are nevoie de acordul unui părinte sau tutore legal pentru a continua.</p>
        <p><a href="${confirmUrl}">Apasă aici pentru a confirma acordul</a></p>
        <p>Dacă nu recunoști această cerere, poți ignora acest email — nu se va întâmpla nimic fără confirmarea ta.</p>
      `,
    });
  } catch (err) {
    console.error("Failed to send consent email", err);
    throw new functions.https.HttpsError("internal", "Nu am putut trimite emailul de confirmare. Încearcă din nou.");
  }

  return { requestId: docRef.id };
});

/**
 * Callable. Body: { requestId }. Returns { status, confirmedAt } where
 * status is 'pending' | 'confirmed' | 'not_found'.
 */
exports.checkConsentStatus = functions.https.onCall(async (data) => {
  const requestId = String((data && data.requestId) || "");
  if (!requestId) {
    throw new functions.https.HttpsError("invalid-argument", "Lipsește requestId.");
  }

  const snap = await db.collection("consentRequests").doc(requestId).get();
  if (!snap.exists) {
    return { status: "not_found", confirmedAt: null };
  }

  const requestData = snap.data();
  return {
    status: requestData.status,
    confirmedAt: requestData.confirmedAt ? requestData.confirmedAt.toDate().toISOString() : null,
  };
});

/**
 * Public HTTP endpoint — opened directly in the parent's browser from the
 * email link. Not callable from the app; no auth, no Firebase SDK involved.
 */
exports.confirmConsent = functions.https.onRequest(async (req, res) => {
  const { id, token } = req.query;

  if (!id || !token) {
    res.status(400).send(renderHtmlPage("Link invalid", "Acest link de confirmare nu este valid."));
    return;
  }

  const docRef = db.collection("consentRequests").doc(String(id));
  const snap = await docRef.get();

  if (!snap.exists) {
    res.status(404).send(renderHtmlPage("Link invalid", "Nu am găsit această cerere de acord."));
    return;
  }

  const requestData = snap.data();

  if (requestData.status === "confirmed") {
    res.status(200).send(
      renderHtmlPage("Acord deja confirmat", "Acordul a fost deja confirmat. Poți închide această pagină.")
    );
    return;
  }

  if (requestData.expiresAt && requestData.expiresAt.toMillis() < Date.now()) {
    res.status(410).send(
      renderHtmlPage("Link expirat", "Acest link a expirat. Cere copilului tău să trimită din nou cererea din aplicație.")
    );
    return;
  }

  const providedHash = crypto.createHash("sha256").update(String(token)).digest("hex");
  const expected = Buffer.from(requestData.tokenHash, "hex");
  const provided = Buffer.from(providedHash, "hex");
  const valid = expected.length === provided.length && crypto.timingSafeEqual(expected, provided);

  if (!valid) {
    res.status(403).send(renderHtmlPage("Link invalid", "Acest link de confirmare nu este valid."));
    return;
  }

  await docRef.update({
    status: "confirmed",
    confirmedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  res.status(200).send(
    renderHtmlPage("Acord confirmat", "Mulțumim! Acordul a fost confirmat cu succes. Poți închide această pagină.")
  );
});
