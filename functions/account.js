/**
 * FutureMe — server-trusted account mutations.
 *
 * `firestore.rules` denies client writes to the `subscription` and
 * `retakeUsage` fields on `users/{uid}` — a signed-in user can read their
 * own document but can no longer set "I'm subscribed" or reset their
 * retake quota by writing to it directly (e.g. via the Firestore console
 * or a raw SDK call). These callables are the only way those fields
 * change; Admin SDK writes from a Cloud Function bypass security rules
 * by design, which is the trust boundary this relies on.
 *
 * `admin.initializeApp()` is already called once in index.js before this
 * module is required.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

const db = admin.firestore();

const MONTHLY_RETAKE_LIMIT = 3;

function currentMonthKey() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
}

/**
 * Callable. Body: { plan, verified }. Records the current user's
 * subscription selection. `verified` should be true once real purchases
 * are confirmed via RevenueCat; false for the pre-RevenueCat fallback
 * flow. The caller is always `context.auth.uid` — a user can only ever
 * confirm a subscription for themselves.
 */
exports.confirmSubscription = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Trebuie să fii autentificat.");
  }
  const plan = data && typeof data.plan === "string" ? data.plan : "monthly";
  const verified = !!(data && data.verified);
  const status = verified ? "active" : "active_unverified";

  await db.collection("users").doc(context.auth.uid).set(
    {
      subscription: {
        status,
        plan,
        [verified ? "purchasedAt" : "selectedAt"]: admin.firestore.FieldValue.serverTimestamp(),
      },
    },
    { merge: true }
  );

  return { status };
});

/**
 * Callable. Increments the current user's retake usage for this month,
 * enforcing `MONTHLY_RETAKE_LIMIT` server-side (mirrors
 * `ModuleProgressRepository.monthlyRetakeLimit` on the client, which is
 * only a UI hint now). Throws `resource-exhausted` once the limit is hit.
 */
exports.useRetake = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Trebuie să fii autentificat.");
  }
  const docRef = db.collection("users").doc(context.auth.uid);

  return db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    const usage = snap.data() && snap.data().retakeUsage;
    const month = currentMonthKey();
    const used = usage && usage.month === month ? usage.count || 0 : 0;

    if (used >= MONTHLY_RETAKE_LIMIT) {
      throw new functions.https.HttpsError("resource-exhausted", "Ai folosit toate evaluările disponibile luna aceasta.");
    }

    const nextCount = used + 1;
    tx.set(docRef, { retakeUsage: { month, count: nextCount } }, { merge: true });
    return { retakesRemaining: MONTHLY_RETAKE_LIMIT - nextCount };
  });
});
