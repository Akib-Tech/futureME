/**
 * FutureMe — Claude-backed dynamic module content.
 *
 *   generateModule1Questions  — 3 reflective open questions for Module 1,
 *                               optionally adapted to the user's age bracket.
 *   generateInsight           — a short, per-user interpretation of one
 *                               module/stage's answers (replaces the
 *                               hardcoded "feedback" copy in the app).
 *
 * Both hold the Anthropic key server-side (Cloud Secret Manager, bound via
 * runWith({secrets})) and return plain JSON. The Flutter side treats any
 * failure here as "fall back to the built-in static content" — nothing in
 * the app breaks if these aren't deployed yet or the model errors.
 *
 * Set the key once before deploying:
 *   firebase functions:secrets:set ANTHROPIC_API_KEY
 */

const functions = require("firebase-functions");
const Anthropic = require("@anthropic-ai/sdk");

const MODEL = "claude-opus-5";
const RUNTIME = { secrets: ["ANTHROPIC_API_KEY"], timeoutSeconds: 120, memory: "512MB" };

function client() {
  return new Anthropic(); // reads ANTHROPIC_API_KEY from the environment
}

function firstText(message) {
  for (const block of message.content || []) {
    if (block.type === "text") return block.text;
  }
  return "";
}

function parseJsonBlock(text) {
  let t = String(text || "").trim();
  const fence = t.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/);
  if (fence) t = fence[1].trim();
  return JSON.parse(t);
}

const MODULE1_SYSTEM = `Ești designer de conținut pentru FutureMe, o aplicație de autocunoaștere în limba română pentru adolescenți și tineri adulți (14-25 ani).

Sarcină: generează EXACT 3 întrebări deschise și reflexive pentru Modulul 1 ("Cunoaștere & context"). Ele îl ajută pe utilizator să exploreze: ce l-a adus la aplicație, ce ar vrea să se schimbe pentru el, și cum ar arăta un parcurs profesional care i se potrivește.

Ton: cald, non-clinic, fără presiune. Fără jargon psihologic. Fără întrebări cu răspuns da/nu. Nu eticheta utilizatorul.

Răspunde DOAR cu un obiect JSON valid, fără markdown și fără text în plus:
{
  "questions": [
    { "question": "titlul întrebării, o propoziție", "subtitle": "1-2 propoziții care încadrează blând întrebarea", "placeholder": "text scurt pentru câmpul de răspuns", "hint": "indiciu scurt sau null" }
  ]
}
Exact 3 obiecte în "questions".`;

const INSIGHT_SYSTEM = `Ești psiholog consultant pentru FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Primești răspunsurile unui utilizator la o etapă a evaluării. Scrie o interpretare scurtă și personalizată, bazată STRICT pe răspunsurile primite.

Reguli:
- Limba română. Ton cald, non-clinic, orientativ. "Acesta este un reper, nu o etichetă."
- Fără diagnostice, fără afirmații definitive. Folosește "pare", "s-ar putea", "tinzi să".
- Bazează-te doar pe ce a scris utilizatorul; nu inventa.
- 2-4 elemente în "items".

Răspunde DOAR cu un obiect JSON valid, fără markdown:
{
  "profileLabel": "Profil orientativ sau null",
  "profileValue": "eticheta sintetică a etapei, sau null",
  "profileDescription": "1-2 propoziții despre profil, sau null",
  "items": [
    { "title": "...", "description": "...", "level": "low | medium | high | null" }
  ]
}
"profileValue"/"profileDescription" doar dacă etapa produce un profil sintetic (ex. stil de decizie). "level" doar pentru trăsături pe scală (ex. Big Five).`;

exports.generateModule1Questions = functions.runWith(RUNTIME).https.onCall(async (data) => {
  const ageBracket = data && typeof data.ageBracket === "string" ? data.ageBracket : null;
  const userMsg = ageBracket
    ? `Utilizatorul se află în intervalul de vârstă "${ageBracket}". Adaptează ușor limbajul la vârstă. Generează cele 3 întrebări.`
    : "Generează cele 3 întrebări.";

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      max_tokens: 2000,
      thinking: { type: "adaptive" },
      system: MODULE1_SYSTEM,
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  const questions = Array.isArray(parsed.questions) ? parsed.questions.slice(0, 3) : [];
  if (questions.length !== 3) {
    throw new functions.https.HttpsError("internal", "Expected exactly 3 questions.");
  }

  return {
    questions: questions.map((q) => ({
      question: String(q.question || ""),
      subtitle: String(q.subtitle || ""),
      placeholder: String(q.placeholder || "Scrie aici..."),
      hint: q.hint == null || q.hint === "" ? null : String(q.hint),
    })),
  };
});

const SCOPE_HINTS = {
  module1: "Modulul 1 — răspunsuri deschise despre context, motivație și direcție.",
  module2_stage1: "Modulul 2, Etapa 1 (MBTI) — cum se raportează la oameni, informații și decizii.",
  module2_stage2: "Modulul 2, Etapa 2 (Big Five) — deschidere, conștiinciozitate, extraversie, agreabilitate, stabilitate emoțională.",
  module2_stage3: "Modulul 2, Etapa 3 — stil cognitiv: cum învață, analizează și rezolvă probleme.",
  module2_stage4: "Modulul 2, Etapa 4 — stil decizional: ce îl ajută sau îl încurcă când ia decizii.",
  module2_stage5: "Modulul 2, Etapa 5 — tipare emoționale: cum reacționează sub presiune.",
  module2_stage6: "Modulul 2, Etapa 6 — control perceput: ce simte că poate influența.",
  module2_final: "Modulul 2 — sinteza celor 6 etape ale profilului psihologic.",
  module3_stage1: "Modulul 3, Etapa 1 (RIASEC) — ce tipuri de activități și domenii îl atrag.",
  module3_stage2: "Modulul 3, Etapa 2 — preferințe de lucru: ritm, libertate, ghidaj.",
  module3_stage3: "Modulul 3, Etapa 3 — mediile de lucru care îl susțin.",
  module3_final: "Modulul 3 — sinteza intereselor, stilului de lucru și mediilor.",
  module4_final: "Modulul 4 — aptitudini și puncte forte, pe baza a 40 de afirmații pe scală.",
  module5_synthesis: "Modulul 5 — sinteza întregului parcurs (Modulele 1-4): repere principale despre persoană și direcții de explorat.",
};

exports.generateInsight = functions.runWith(RUNTIME).https.onCall(async (data) => {
  const scope = data && typeof data.scope === "string" ? data.scope : "";
  const answers = data && Array.isArray(data.answers) ? data.answers : [];
  if (!scope || answers.length === 0) {
    throw new functions.https.HttpsError("invalid-argument", "scope and non-empty answers are required.");
  }

  const hint = SCOPE_HINTS[scope] || scope;
  const userMsg = `Etapă: ${scope}\nContext: ${hint}\n\nRăspunsurile utilizatorului (JSON):\n${JSON.stringify(answers, null, 2)}`;

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      max_tokens: 4000,
      thinking: { type: "adaptive" },
      system: INSIGHT_SYSTEM,
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  const items = Array.isArray(parsed.items) ? parsed.items : [];
  if (items.length === 0) {
    throw new functions.https.HttpsError("internal", "No insight items produced.");
  }

  const allowed = new Set(["low", "medium", "high"]);
  return {
    profileLabel: parsed.profileLabel == null ? null : String(parsed.profileLabel),
    profileValue: parsed.profileValue == null ? null : String(parsed.profileValue),
    profileDescription: parsed.profileDescription == null ? null : String(parsed.profileDescription),
    items: items.slice(0, 4).map((it) => ({
      title: String(it.title || ""),
      description: String(it.description || ""),
      level: allowed.has(it.level) ? it.level : null,
    })),
  };
});
