#!/usr/bin/env bash
# THE MADE — KIE.ai image model comparison
# Generates the SAME scene on two models (Nano Banana Pro + GPT Image 2),
# plus a variant with the chapter on-screen text "THE BRAIN".
# All at 2K, 16:9.
#
# USAGE:
#   export KIE_API_KEY="your_key_here"
#   ./generate_kie.sh
#
# Requires: curl, python3
set -euo pipefail

: "${KIE_API_KEY:?Set KIE_API_KEY env var first (export KIE_API_KEY=...)}"
API="https://api.kie.ai/api/v1/jobs"
OUT="$(cd "$(dirname "$0")" && pwd)/out"
mkdir -p "$OUT"

# ---- Prompts -----------------------------------------------------------------
SCENE='Pitch-black morgue-cold containment chamber, near-total darkness. A single emaciated grey alien cadaver (an "EBO") lying on a stainless-steel autopsy table, lit only by one faint cold rim of light. The entire frame is void-black and fully desaturated / monochrome — the ONLY color anywhere in the image is a thin trickle of glinting metallic copper-colored blood running across the steel table. Volumetric haze, fine 35mm film grain, clinical forensic sci-fi dread, Fincher-cold cinematic composition, photorealistic, 16:9.'

SCENE_TEXT='A cold pitch-black forensic morgue scene: a grey alien cadaver on a stainless-steel autopsy table in near-total darkness, the only color a thin trickle of glinting metallic copper blood on the steel. Clean documentary on-screen title typography overlaid: a large condensed white sans-serif heading reading "THE BRAIN", and below it a small monospace caption reading "it wasn'\''t built to think alone — it was built to be operated". Cinematic lower-third layout, void-black negative space, fine grain, 16:9.'

# ---- Helpers -----------------------------------------------------------------
create_task() { # $1=model  $2=prompt  -> prints taskId
  local model="$1" prompt="$2"
  python3 - "$model" "$prompt" <<'PY' > /tmp/_body.json
import json,sys
model,prompt=sys.argv[1],sys.argv[2]
inp={"prompt":prompt,"aspect_ratio":"16:9","resolution":"2K"}
if model=="nano-banana-pro": inp["output_format"]="png"
print(json.dumps({"model":model,"input":inp}))
PY
  curl -s -X POST "$API/createTask" \
    -H "Authorization: Bearer $KIE_API_KEY" \
    -H "Content-Type: application/json" \
    --data @/tmp/_body.json \
  | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("data",{}).get("taskId") or ("ERR:"+json.dumps(d)))'
}

poll_download() { # $1=taskId  $2=outfile-basename
  local tid="$1" base="$2" tries=0
  [[ "$tid" == ERR:* ]] && { echo "  ✗ createTask failed: ${tid#ERR:}"; return 1; }
  echo "  task: $tid"
  while (( tries < 90 )); do
    local resp state url
    resp="$(curl -s "$API/recordInfo?taskId=$tid" -H "Authorization: Bearer $KIE_API_KEY")"
    state="$(echo "$resp" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("data",{}).get("state",""))' 2>/dev/null || echo)"
    case "$state" in
      success)
        url="$(echo "$resp" | python3 -c 'import json,sys;d=json.load(sys.stdin)["data"];rj=json.loads(d.get("resultJson") or "{}");print((rj.get("resultUrls") or [""])[0])')"
        [[ -z "$url" ]] && { echo "  ✗ no result url"; return 1; }
        curl -s -L "$url" -o "$OUT/$base.png"
        echo "  ✓ saved $OUT/$base.png"
        return 0 ;;
      fail)
        echo "  ✗ generation failed: $(echo "$resp" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("data",{}).get("failMsg",""))')"
        return 1 ;;
      "") echo "  … unexpected response: $resp" ;;
      *)  printf "  … %s\r" "$state" ;;
    esac
    tries=$((tries+1)); sleep 4
  done
  echo "  ✗ timed out"; return 1
}

run() { # $1=label $2=model $3=prompt $4=outbase
  echo "[$1] model=$2"
  poll_download "$(create_task "$2" "$3")" "$4" || true
  echo
}

# ---- Execute (4 images) ------------------------------------------------------
echo "=== Scene A: all-black except copper blood ==="
run "Nano Banana Pro"  "nano-banana-pro"          "$SCENE"      "sceneA_nano-banana-pro"
run "GPT Image 2"      "gpt-image-2-text-to-image" "$SCENE"      "sceneA_gpt-image-2"

echo "=== Scene B: same scene WITH chapter text 'THE BRAIN' ==="
run "Nano Banana Pro"  "nano-banana-pro"          "$SCENE_TEXT" "sceneB_text_nano-banana-pro"
run "GPT Image 2"      "gpt-image-2-text-to-image" "$SCENE_TEXT" "sceneB_text_gpt-image-2"

echo "Done. Images in: $OUT"
