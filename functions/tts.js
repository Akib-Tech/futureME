/**
 * FutureMe — ElevenLabs text-to-speech with Storage caching.
 *
 * Takes the text the app would have spoken on-device and returns a URL to an
 * MP3 in the user's own voice clone. Audio is cached by SHA-256 of the text,
 * so repeated or shared copy is synthesized (and paid for) exactly once.
 *
 * Set both secrets once before deploying:
 *   firebase functions:secrets:set ELEVENLABS_API_KEY
 *   firebase functions:secrets:set ELEVENLABS_VOICE_ID
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");

if (!admin.apps.length) admin.initializeApp();

const MODEL_ID = "eleven_multilingual_v2";
const RUNTIME = {
  secrets: ["ELEVENLABS_API_KEY", "ELEVENLABS_VOICE_ID"],
  timeoutSeconds: 120,
  memory: "512MB",
};

exports.synthesizeSpeech = functions.runWith(RUNTIME).https.onCall(async (data) => {
  const text = data && typeof data.text === "string" ? data.text.trim() : "";
  if (!text) {
    throw new functions.https.HttpsError("invalid-argument", "text is required.");
  }
  if (text.length > 10000) {
    throw new functions.https.HttpsError("invalid-argument", "text exceeds 10000 characters.");
  }

  const voiceId = process.env.ELEVENLABS_VOICE_ID;
  const hash = crypto.createHash("sha256").update(`${voiceId}:${MODEL_ID}:${text}`).digest("hex");
  const path = `tts/${hash}.mp3`;

  const bucket = admin.storage().bucket();
  const file = bucket.file(path);

  const [exists] = await file.exists();
  if (exists) {
    const [meta] = await file.getMetadata();
    return { url: downloadUrl(bucket.name, path, meta.metadata.firebaseStorageDownloadTokens) };
  }

  let response;
  try {
    response = await fetch(`https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`, {
      method: "POST",
      headers: {
        "xi-api-key": process.env.ELEVENLABS_API_KEY,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ text, model_id: MODEL_ID }),
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `ElevenLabs call failed: ${err.message}`);
  }

  if (!response.ok) {
    const detail = await response.text();
    throw new functions.https.HttpsError("internal", `ElevenLabs returned ${response.status}: ${detail}`);
  }

  const token = crypto.randomUUID();
  await file.save(Buffer.from(await response.arrayBuffer()), {
    contentType: "audio/mpeg",
    metadata: { metadata: { firebaseStorageDownloadTokens: token } },
  });

  return { url: downloadUrl(bucket.name, path, token) };
});

function downloadUrl(bucketName, path, token) {
  return `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodeURIComponent(path)}?alt=media&token=${token}`;
}