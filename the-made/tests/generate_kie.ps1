<#
  THE MADE - KIE.ai image model comparison (pure PowerShell, no bash needed)
  Generates the SAME scene on two models (Nano Banana Pro + GPT Image 2),
  plus a variant with the chapter on-screen text "THE BRAIN". All 2K, 16:9.

  USAGE (PowerShell):
     $env:KIE_API_KEY = "your_key_here"
     .\the-made\tests\generate_kie.ps1
#>

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- Config ------------------------------------------------------------------
$Key = $env:KIE_API_KEY
if ([string]::IsNullOrWhiteSpace($Key)) { throw "Set the KIE_API_KEY env var first:  `$env:KIE_API_KEY = '...'" }
$Api = "https://api.kie.ai/api/v1/jobs"
$OutDir = Join-Path $PSScriptRoot "out"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$Headers = @{ Authorization = "Bearer $Key" }

# --- Prompts -----------------------------------------------------------------
$Scene = "Pitch-black morgue-cold containment chamber, near-total darkness. A single emaciated grey alien cadaver (an 'EBO') lying on a stainless-steel autopsy table, lit only by one faint cold rim of light. The entire frame is void-black and fully desaturated / monochrome - the ONLY color anywhere in the image is a thin trickle of glinting metallic copper-colored blood running across the steel table. Volumetric haze, fine 35mm film grain, clinical forensic sci-fi dread, Fincher-cold cinematic composition, photorealistic, 16:9."

$SceneText = "A cold pitch-black forensic morgue scene: a grey alien cadaver on a stainless-steel autopsy table in near-total darkness, the only color a thin trickle of glinting metallic copper blood on the steel. Clean documentary on-screen title typography overlaid: a large condensed white sans-serif heading reading 'THE BRAIN', and below it a small monospace caption reading 'it wasn''t built to think alone - it was built to be operated'. Cinematic lower-third layout, void-black negative space, fine grain, 16:9."

# --- Functions ---------------------------------------------------------------
function New-KieTask {
    param([string]$Model, [string]$Prompt)
    $input = @{ prompt = $Prompt; aspect_ratio = "16:9"; resolution = "2K" }
    if ($Model -eq "nano-banana-pro") { $input.output_format = "png" }
    $body = @{ model = $Model; input = $input } | ConvertTo-Json -Depth 6
    $resp = Invoke-RestMethod -Method Post -Uri "$Api/createTask" -Headers $Headers `
            -ContentType "application/json" -Body $body
    if ($resp.code -ne 200) { throw "createTask failed: $($resp | ConvertTo-Json -Depth 6)" }
    return $resp.data.taskId
}

function Get-KieResult {
    param([string]$TaskId, [string]$OutFile)
    Write-Host "  task: $TaskId"
    for ($i = 0; $i -lt 90; $i++) {
        $r = Invoke-RestMethod -Method Get -Uri "$Api/recordInfo?taskId=$TaskId" -Headers $Headers
        $state = $r.data.state
        switch ($state) {
            "success" {
                $url = ($r.data.resultJson | ConvertFrom-Json).resultUrls[0]
                if (-not $url) { throw "no result url" }
                Invoke-WebRequest -Uri $url -OutFile $OutFile
                Write-Host "  OK -> $OutFile" -ForegroundColor Green
                return
            }
            "fail" { throw "generation failed: $($r.data.failMsg)" }
            default { Write-Host "  ... $state" -NoNewline; Write-Host "`r" -NoNewline }
        }
        Start-Sleep -Seconds 4
    }
    throw "timed out"
}

function Invoke-Gen {
    param([string]$Label, [string]$Model, [string]$Prompt, [string]$Base)
    Write-Host "[$Label] model=$Model"
    try {
        $id = New-KieTask -Model $Model -Prompt $Prompt
        Get-KieResult -TaskId $id -OutFile (Join-Path $OutDir "$Base.png")
    } catch {
        Write-Host "  X $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# --- Execute (4 images) ------------------------------------------------------
Write-Host "=== Scene A: all-black except copper blood ===" -ForegroundColor Cyan
Invoke-Gen "Nano Banana Pro" "nano-banana-pro"            $Scene     "sceneA_nano-banana-pro"
Invoke-Gen "GPT Image 2"     "gpt-image-2-text-to-image"  $Scene     "sceneA_gpt-image-2"

Write-Host "=== Scene B: same scene WITH chapter text 'THE BRAIN' ===" -ForegroundColor Cyan
Invoke-Gen "Nano Banana Pro" "nano-banana-pro"            $SceneText "sceneB_text_nano-banana-pro"
Invoke-Gen "GPT Image 2"     "gpt-image-2-text-to-image"  $SceneText "sceneB_text_gpt-image-2"

Write-Host "Done. Images in: $OutDir" -ForegroundColor Cyan
