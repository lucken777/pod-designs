# THE MADE — Handoff / Übergabe-Dokument

Vollständige Übergabe des Projektstands, damit du in einer anderen Umgebung
(mit funktionierender KIE-API-Anbindung) sofort weitermachen kannst.

> **Offener nächster Schritt:** Die 4 KIE-Vergleichsbilder generieren (siehe Abschnitt 1).
> In der bisherigen Web-Umgebung war `api.kie.ai` durch den Netzwerk-Egress-Filter
> blockiert. In deiner Desktop/Projekt-Umgebung mit KIE-Anbindung läuft es.

---

## 1) AUFGABE: 4 KIE-Vergleichsbilder generieren

**Ziel:** Dieselbe Szene auf 2 Modellen + eine Variante mit Kapitel-Text. Alles 2K, 16:9.

| Datei | Modell-ID (KIE) | Inhalt |
|---|---|---|
| sceneA_nano-banana-pro.png | `nano-banana-pro` | Szene: alles schwarz, nur Kupferblut |
| sceneA_gpt-image-2.png | `gpt-image-2-text-to-image` | dieselbe Szene |
| sceneB_text_nano-banana-pro.png | `nano-banana-pro` | dieselbe Szene + Kapitel-Text „THE BRAIN" |
| sceneB_text_gpt-image-2.png | `gpt-image-2-text-to-image` | dieselbe + Text |

### Prompts
**Szene A (alles schwarz außer Kupferblut):**
> Pitch-black morgue-cold containment chamber, near-total darkness. A single emaciated grey alien cadaver (an "EBO") lying on a stainless-steel autopsy table, lit only by one faint cold rim of light. The entire frame is void-black and fully desaturated / monochrome — the ONLY color anywhere in the image is a thin trickle of glinting metallic copper-colored blood running across the steel table. Volumetric haze, fine 35mm film grain, clinical forensic sci-fi dread, Fincher-cold cinematic composition, photorealistic, 16:9.

**Szene B (mit Kapitel-Text):**
> A cold pitch-black forensic morgue scene: a grey alien cadaver on a stainless-steel autopsy table in near-total darkness, the only color a thin trickle of glinting metallic copper blood on the steel. Clean documentary on-screen title typography overlaid: a large condensed white sans-serif heading reading "THE BRAIN", and below it a small monospace caption reading "it wasn't built to think alone — it was built to be operated". Cinematic lower-third layout, void-black negative space, fine grain, 16:9.

### KIE API-Spec (verifiziert aus docs.kie.ai)
- **Create:** `POST https://api.kie.ai/api/v1/jobs/createTask`
  Header: `Authorization: Bearer <KEY>`, `Content-Type: application/json`
  Body Nano Banana Pro: `{"model":"nano-banana-pro","input":{"prompt":"...","aspect_ratio":"16:9","resolution":"2K","output_format":"png"}}`
  Body GPT Image 2: `{"model":"gpt-image-2-text-to-image","input":{"prompt":"...","aspect_ratio":"16:9","resolution":"2K"}}`
  → Antwort: `{"code":200,"data":{"taskId":"..."}}`
- **Poll:** `GET https://api.kie.ai/api/v1/jobs/recordInfo?taskId=<id>`
  → `data.state` ∈ {waiting, queuing, generating, success, fail}; bei success: `data.resultJson` = JSON-String mit `resultUrls[]`. **Ergebnis-URLs verfallen nach ~24h → sofort downloaden.**

### Sofort ausführen
Das fertige Script liegt im Repo: **`the-made/tests/generate_kie.sh`**
```bash
export KIE_API_KEY="<dein_key>"
./the-made/tests/generate_kie.sh
# Bilder landen in the-made/tests/out/
```
Egress freigeben für: `api.kie.ai` und `tempfile.aiquickdraw.com` (Download-Host).

---

## 2) PROJEKT-DATEIEN (bereits im Repo, Branch `claude/chatgpt-conversation-agents-4z67jj`)
- `the-made/master-script.md` — finales VO-Master-Script „THE MADE" (EBO-Leak)
- `the-made/production-blueprint.md` — Design, Bild-Pipeline, Transitions, Typo, SFX/Musik, ElevenLabs, Kosten
- `the-made/infographic-A-address-system.html` — Beispiel-Infografik (2K, im Browser öffnen)
- `the-made/tests/generate_kie.sh` — KIE-Bildvergleich-Script
- `the-made/README.md` — Übersicht

---

## 3) DESIGN-SYSTEM „COLD STORAGE / SPECIMEN-9" (Kurzreferenz)
Monochrom cyan/stahl + einziger warmer Akzent = **Kupferblut**. Leichenkalt, klinisch, redacted.
| Rolle | Hex | | Rolle | Hex |
|---|---|---|---|---|
| Void-Schwarz | `#070A0C` | | Surgical-White | `#E8F1F3` |
| Morgue-Cyan | `#0E2A33` | | Kupferblut | `#B06A3B` |
| Cryo-Steel | `#3A4A52` | | Alert-Amber | `#D98A2B` |

- **Bildmodell:** Flux 1.1 Pro war „nicht gut genug" → Test läuft auf **Nano Banana Pro** vs **GPT Image 2** (dieser Vergleich = offene Aufgabe oben).
- **Stimme:** ElevenLabs **„Daniel"** — Multilingual v2, Stability 50 / Similarity 80 / Style 10 / Speed 0.93.
- **Musik:** verstimmtes Moll-Klavier + Sub-Drone; Epidemic Sound (dark cinematic).
- **Video:** ~9 Min, 122 Bilder (nur Stills + Ken-Burns + Transitions, kein AI-Video), 2K/16:9/24fps.

---

## 4) CHANNEL-STRATEGIE — Top 5 Video-Ideen (aus 3 Research-Agenten)
Marktlücke = LEMMiNO-Qualität × hohe Themen-Gravitation (UAP/declassified/Science-Horror) × höhere Frequenz.

1. **The 4chan Whistleblower Nobody Could Debunk** (Hammers-Leaker) — EBO-Zwilling, frisch. *Hoch*
2. **The CIA Document That Says Reality Isn't Real** (Gateway Process, declassified, gerade viral). *Hoch*
3. **We Secretly Built Engineered Humans** (CRISPR-Babys / He Jiankui) — „THE MADE"-Reim. *Hoch*
4. **The People Who Tried to Tell Us — And Didn't Survive** (tote UAP-Whistleblower) — News-Peak Juni 2026. *Hoch* 🔥
5. **The Radio That's Been Buzzing for 40 Years** (UVB-76) — ongoing, audio-Dread. *Hoch*

**20-Slate (5 Säulen × 4):**
- Anonyme Leaks: Hammers · John Titor · Max Spiers · Bob Lazar/Element 115
- Declassified: Gateway Process · Project Sun Streak (Ark) · Moscow Signal→Havana · Acoustic Kitty
- Engineered Life/Science-Horror: CRISPR-Babys · Brain Organoids · Cordyceps · Gene-edited Pathogens
- Ongoing Mysteries: UVB-76 · Max-Headroom-Hijack · Numbers Stations · Cicada 3301 (neuer Winkel)
- Existenzieller Science-Horror: Dying-Brain-Surge · Toxoplasma & Free Will · Wow!-Signal · Dead Internet Theory / AI-2027

**Format:** 16–22 Min Longform + 1–2 Shorts/Video als Funnel.
**Kritisch (Monetarisierung):** YouTube AI-Slop-Crackdown (15.07.2025) — Faceless ok, *Slop* nicht. Original-Script, EINE Stimme, zitierte Primärquellen. Framing immer „alleged / according to declassified docs / scientists propose"; keine Gore-Thumbnails, kein f-word in den ersten 60s.

---

## 5) OFFENE TODOs
- [ ] **4 KIE-Vergleichsbilder generieren** (Abschnitt 1) → Modell-Entscheidung Nano Banana Pro vs GPT Image 2
- [ ] Danach: bestes Modell als Channel-Standard festlegen, Infografik B & C bauen
- [ ] Master-Script für Video #4 (tote Whistleblower, heißestes Thema) oder #1 schreiben
- [ ] Optional: n8n-Automatisierungs-Workflow als JSON
