# THE MADE — Production Blueprint

Synthese aus 16 Spezialisten-Agenten (5 Video-Designer · 2 Transition + 2 Text · 3 SFX + 3 Musik · 3 Automation · 1 Scriptschreiber).

## 1. Design — „COLD STORAGE / SPECIMEN-9"
Klinische Asservatenkammer unter sterbendem OP-Licht. Monochrom cyan/stahl + **einziger warmer Akzent = Kupferblut**. Schlägt Nexpo durch „die Akte selbst": leichenkalt, redacted, gestempelt.

| Rolle | Hex |
|---|---|
| Void-Schwarz | `#070A0C` |
| Morgue-Cyan | `#0E2A33` |
| Cryo-Steel | `#3A4A52` |
| Surgical-White | `#E8F1F3` |
| Kupferblut (Akzent) | `#B06A3B` |
| Alert-Amber | `#D98A2B` |

- **Fonts:** Inter Tight (Titel/Keywords, Black) + JetBrains Mono (Daten/Captions) + Stardos Stencil (Stempel) — alle frei.
- **Motive:** Mess-Grid, Reticle-Eckklammern, Mono-Adress-Tags, Redaction-Balken, Frost-Kanten.
- **Specs:** 2560×1440 (2K), 16:9, 24 fps, sRGB/Rec.709. Hero-Plates @ 2880×1620 für Punch-in-Reserve. Stills als PNG (Text/Infografik), JPG q95 (Foto-Inserts).

## 2. Bildmodell
- **Primary: Flux 1.1 Pro (fal.ai)** — ~85% der Frames; beste Material-Realistik (Frost, Haut, Kupfer), kalte Cine-Gradation.
- **Fallback: Ideogram 3.0** — ~15%; lesbarer In-Image-Text (Infografiken, Lab-Signage, Redaction-Labels).
- **Style-Suffix** (an jeden Prompt): `cold forensic pathology archive, single hard overhead surgical lamp, crushed blacks lifted into cyan-teal shadow (#0E2A33), clipped surgical-white highlights, one isolated copper accent (#B06A3B), volumetric haze, fine 35mm grain, registration grid + corner tick brackets, anamorphic clinical sci-fi dread, Fincher-cold, photoreal, 2560x1440, 16:9 --ar 16:9`

## 3. Transition-Kit (Editor, kein AI-Video)
1. **Clinical Hard Cut** (Default ~70%) — auf den Beat.
2. **Frost-Wipe** (18–24f) — in Freezer/Specimen-Shots.
3. **Redaction-Bar-Swipe** (10–14f) — Themenwechsel (Signatur-Tell).
4. **RGB-Split Glitch Cut** (3–5f) — Widersprüche/Lügen-Reveal.
5. **Cold Light-Leak Dissolve** (20–30f) — Atempausen, Mirror/Close.
6. **Sub-Bass Whip / Speed-Ramp** (6–10f) — Descent/Tempo.
- **Hero-Übergänge (je 1×):** „The Strand" (DNA Bombshell), „Cold Bloom" (The Brain), „The Unredaction" (Revelation).
- **Ken-Burns:** 1 Move pro Shot. Default Push 100→106–110% über 4–7s. Pull-back nur für Scale-Reveals. 3-Layer-Parallax für ~8–12 Hero-Shots.

## 4. Text/Typo-System
- Section-Title-Cards (Mono-Kicker + Inter Tight Black, blur-in + tracking-collapse).
- Typewriter/Redaction-Reveal (18–22 ch/s, Block-Cursor ▋, Balken retract).
- Key-Word-Pop-ups (scale-snap + 1f RGB-Split; max 1 / 20–30s; rote „Danger"-Wörter).
- Lower-Thirds (Mono, Cyan-Tick), Classified-Stamp (Stencil, stamp-slam), finale ON-BLACK-Lines (blur-in, lange Holds).
- Captions: Inter/JetBrains Medium, ~42–48px, halbtransparente Dark-Plate, lower-25%, 5–7 Wörter, Keyword-Emphasis cyan/rot synchron zur VO.

## 5. SFX & Musik
- **SFX-Palette (14 Cues):** Sub-Drop/Boom, Freezer-Room-Tone, HDD-Spin, Elevator-Rumble, Scalpel/Film-Peel, Heartbeat, Geiger-Clicks, Riser, Glitch-Stutter, 1× Braam (nur The Brain), Tape-Stop (Skeptic), Reverse-Cymbal, Whisper-Bed, Sonar-Ping.
- **Stille:** harter Silence-Cut auf den Brain-Reveal; Musik-Dropout vor DNA-Bombshell; trockener Raumton im Skeptic-Beat.
- **Main-Theme:** 3–4-Ton absteigendes Moll, einsames (leicht verstimmtes) Klavier über Sub-Drone — verstimmt = „manufactured". Bare im Cold Open → geglitcht im Address System → volle Streicher in der Revelation → bare/sinister in Mirror/Close.
- **Library (monetarisierungs-sicher):** Epidemic Sound „Dark & Mysterious / Drones / Cinematic Tension" (Hampus Naeselius, Christoffer Moe Ditlevsen). Analoga: Reznor/Ross, Hildur Guðnadóttir, Zimmer.

## 6. Voiceover (ElevenLabs)
- **Primary: „Daniel"** — britisch, klinische Doku-Autorität. Model *Eleven Multilingual v2*, Stability 50, Similarity 80, Style 10, Speaker-Boost AN, Speed 0.93.
- **Backup:** „George" (wärmer/intimer), US-Alternative „Bill".

## 7. Automation-Pipeline
- **Stack:** n8n (self-hosted) Orchestrator + Python/FastAPI-Microservice + Supabase-Manifest (1 Row/Video, JSON pro Shot) + Drive/R2 Assets.
- **Voll-Auto:** Segmentierung (Claude) → Prompt-Gen (Style-Suffix) → Batch-Bilder (Flux) → Upscale → VO (ElevenLabs API) → WhisperX Word-Timecodes → Captions → vorbefüllte DaVinci-Timeline (FCPXML/OTIO) → Metadaten → Upload (YouTube Data API).
- **Mensch (Qualität):** Bild-Curation, Schnitt-Timing/Pacing, Ken-Burns-Richtung, Infografiken, Thumbnail, Final-QC.
- **Durchsatz:** ~5–7 h Mensch/Video → 3–4 Videos/Woche pro Editor (5–6 mit VA).

## 8. Eckdaten / Kosten
- **Länge:** ~9:00 Min.
- **Bilder:** 122 Basis (≈150–160 perceived), nur Stills + Zooms + Transitions, kein AI-Video. Inkl. Re-Rolls ~300 Generierungen.
- **KI-Bildkosten @2K:** Flux ~$0.04/Bild → ~$12 + Upscale (~$1–3) ≈ **$13–18/Video**. Ideogram-Infografiken ~$0.08/Bild. LLM < $1.
- **Marginalkosten gesamt:** ~$15–25/Video. Fixkosten Tooling: ~$150–250/Monat. ElevenLabs Pro $99/Monat deckt ~40+ Videos.

## 9. Infografiken (3)
- **A — The Address System:** 16 zirkuläre Chromosomen-Ringe + Gen-Barcode/Adress-Callout (vs. menschl. 23 linear). → `infographic-A-address-system.html`
- **B — Human vs EBO:** Anatomie-Checkliste (keine Zähne/Genitalien/Nabel/Anus) + I/O-Flow (Kupfer rein → Ammoniak raus, braunes Blut).
- **C — Intel Reliability Grade:** A-1…F-5-Skala, gestempelt **F-5**.

## 10. Shotlist (Sektionen)
Cold Open 9 · Promise 5 · Recruitment 11 · Descent 8 · Freezer 11 · DNA Bombshell 8 · Address System 10 · Biologist's Warning 7 · Body/Anatomy 12 · Brain 10 · Revelation 8 · Skeptic 8 · Mirror 6 · Close 9 = **122 Bilder**.
**Hero-Bilder:** #3 (4 Körper Freezer-Wide/Thumbnail), #38+#40 (Haut hebt sich → blasse Haut), #83+#88/#91 (4-Segment-Hirn + Nodule-Interface), #122 (leerer fünfter Tisch).
