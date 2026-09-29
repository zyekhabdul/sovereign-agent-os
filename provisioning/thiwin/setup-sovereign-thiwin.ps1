# ==============================================================================
# SOVEREIGN AI AGENT GOVERNANCE — THIWIN DEDICATED BOOTSTRAPPER
# ==============================================================================
# Target: ThinkPad Windows (core-002 / thiwin)
# Path  : provisioning/thiwin/setup-sovereign-thiwin.ps1
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter()]
    [string]$TargetUserHome = $env:USERPROFILE
)

$ErrorActionPreference = "Stop"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   SOVEREIGN NODE BOOTSTRAP: THIWIN (CORE-002)        " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
$HomeDir = $TargetUserHome
Write-Host "[ INFO ] Target Home: $HomeDir" -ForegroundColor Gray
Write-Host "[ INFO ] Repository Root: $RepoRoot" -ForegroundColor Gray

# 1. Directories
Write-Host "[ 1/6 ] Creating sovereign directory tree..." -ForegroundColor Yellow
$Dirs = @(
    (Join-Path $HomeDir "bin"),
    (Join-Path $HomeDir ".local\bin"),
    (Join-Path $HomeDir ".gemini\config\rules"),
    (Join-Path $HomeDir ".gemini\config\plugins"),
    (Join-Path $HomeDir ".agents\skills"),
    (Join-Path $HomeDir ".opencode\bin"),
    (Join-Path $HomeDir ".opencode\skills"),
    (Join-Path $HomeDir ".config\opencode\skills"),
    (Join-Path $HomeDir ".claude"),
    (Join-Path $HomeDir ".codex"),
    (Join-Path $HomeDir "Projects"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\00-AGY-Memory"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\09-Panduan-Projek")
)
foreach ($d in $Dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
Write-Host "  [ PASS ] Directories created." -ForegroundColor Green

# 2. Deploy 16 Rules
Write-Host "[ 2/6 ] Deploying 16 formal binding rules..." -ForegroundColor Yellow
$RulesDir = Join-Path $ScriptDir "rules"
if (-not (Test-Path $RulesDir)) {
    $RulesDir = Join-Path $RepoRoot "rules"
}
if (Test-Path $RulesDir) {
    $RuleFiles = Get-ChildItem -Path $RulesDir -Filter "*.md"
    $TargetRulesDir = Join-Path $HomeDir ".gemini\config\rules"
    foreach ($rf in $RuleFiles) {
        $content = Get-Content -Path $rf.FullName -Raw -Encoding UTF8
        $content = $content -replace '/home/(fuckadmin|aomiqaza)', $HomeDir.Replace('\', '/')
        [System.IO.File]::WriteAllText((Join-Path $TargetRulesDir $rf.Name), $content, [System.Text.Encoding]::UTF8)
    }
    Write-Host "  [ PASS ] Deployed $($RuleFiles.Count) rules to $TargetRulesDir" -ForegroundColor Green
}

# 3. GEMINI.md Cross-Agent Parity
Write-Host "[ 3/6 ] Deploying cross-agent SSOT root files..." -ForegroundColor Yellow
$GlobalRules = Join-Path $ScriptDir "GLOBAL_RULES.md"
if (-not (Test-Path $GlobalRules)) {
    $GlobalRules = Join-Path $RepoRoot "GLOBAL_RULES.md"
}
if (Test-Path $GlobalRules) {
    $RulesContent = Get-Content -Path $GlobalRules -Raw -Encoding UTF8
    $Targets = @(
        (Join-Path $HomeDir "GEMINI.md"),
        (Join-Path $HomeDir ".gemini\GEMINI.md"),
        (Join-Path $HomeDir ".gemini\config\GEMINI.md"),
        (Join-Path $HomeDir ".agents\GEMINI.md"),
        (Join-Path $HomeDir ".claude\CLAUDE.md"),
        (Join-Path $HomeDir ".opencode\OPENCODE.md"),
        (Join-Path $HomeDir ".codex\CODEX.md")
    )
    foreach ($tgt in $Targets) {
        $p = Split-Path -Parent $tgt
        if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
        [System.IO.File]::WriteAllText($tgt, $RulesContent, [System.Text.Encoding]::UTF8)
    }
    Write-Host "  [ PASS ] Synced 7 root instruction files." -ForegroundColor Green
}

# 4. OpenCode Configuration
Write-Host "[ 4/6 ] Configuring OpenCode with Effect/Zod schema & Hybrid MVO..." -ForegroundColor Yellow
$RefOpenCode = Join-Path $ScriptDir "opencode.windows.json"
$OpenCodeJsonString = ""

if (Test-Path $RefOpenCode) {
    $OpenCodeJsonString = Get-Content -Path $RefOpenCode -Raw -Encoding UTF8
    $OpenCodeJsonString = $OpenCodeJsonString -replace 'C:/Users/[^/]+', $HomeDir.Replace('\', '/')
} else {
    $NormalizedHome = $HomeDir.Replace('\', '/')
    $OpenCodeObj = @{
        "`$schema" = "https://opencode.ai/config.json"
        "mcp" = @{}
        "instructions" = @(
            "$NormalizedHome/.opencode/OPENCODE.md",
            "$NormalizedHome/.gemini/config/rules/agent-persona-invariants.md",
            "$NormalizedHome/.gemini/config/rules/ponytail-yagni.md",
            "$NormalizedHome/.gemini/config/rules/deterministic-machine-harness.md"
        )
        "skills" = @{
            "paths" = @(
                "$NormalizedHome/.opencode/skills",
                "$NormalizedHome/.config/opencode/skills"
            )
        }
        "tool_output" = @{
            "max_lines" = 200
            "max_bytes" = 16384
        }
        "compaction" = @{
            "auto" = $true
            "tail_turns" = 15
        }
    }
    $OpenCodeJsonString = $OpenCodeObj | ConvertTo-Json -Depth 10
}

$OpenCodeDestinations = @(
    (Join-Path $HomeDir ".opencode\opencode.json"),
    (Join-Path $HomeDir ".config\opencode\opencode.json")
)
foreach ($dst in $OpenCodeDestinations) {
    $dp = Split-Path -Parent $dst
    if (-not (Test-Path $dp)) { New-Item -ItemType Directory -Path $dp -Force | Out-Null }
    [System.IO.File]::WriteAllText($dst, $OpenCodeJsonString, [System.Text.Encoding]::UTF8)
}
Write-Host "  [ PASS ] OpenCode configurations deployed." -ForegroundColor Green

# 5. OpenCode Proxy Wrapper
Write-Host "[ 5/6 ] Installing Bun proxy sanitizer wrapper (opencode.cmd)..." -ForegroundColor Yellow
$CmdSource = Join-Path $ScriptDir "opencode.cmd"
$CmdDest = Join-Path $HomeDir "bin\opencode.cmd"

if (Test-Path $CmdSource) {
    Copy-Item -Path $CmdSource -Destination $CmdDest -Force
} else {
    $CmdContent = @"
@echo off
setlocal enabledelayedexpansion
if defined HTTP_PROXY (
    if "!HTTP_PROXY:~0,9!"=="socks5://" set "HTTP_PROXY=http://!HTTP_PROXY:~9!"
)
if defined HTTPS_PROXY (
    if "!HTTPS_PROXY:~0,9!"=="socks5://" set "HTTPS_PROXY=http://!HTTPS_PROXY:~9!"
)
set "ALL_PROXY="
where opencode.exe >nul 2>&1
if %ERRORLEVEL% equ 0 ( opencode.exe %* & exit /b %ERRORLEVEL% )
where bun.exe >nul 2>&1
if %ERRORLEVEL% equ 0 ( bunx opencode %* & exit /b %ERRORLEVEL% )
npx -y opencode %*
exit /b %ERRORLEVEL%
"@
    [System.IO.File]::WriteAllText($CmdDest, $CmdContent, [System.Text.Encoding]::ASCII)
}
Write-Host "  [ PASS ] Wrapper written to $CmdDest" -ForegroundColor Green

# 6. Verification
Write-Host "[ 6/6 ] Running verification checks..." -ForegroundColor Yellow
$VerificationFailed = $false
$RequiredFiles = @(
    (Join-Path $HomeDir ".gemini\config\rules\agent-persona-invariants.md"),
    (Join-Path $HomeDir ".gemini\config\rules\deterministic-machine-harness.md"),
    (Join-Path $HomeDir ".gemini\config\rules\ponytail-yagni.md"),
    (Join-Path $HomeDir ".gemini\GEMINI.md"),
    (Join-Path $HomeDir ".opencode\OPENCODE.md"),
    (Join-Path $HomeDir ".opencode\opencode.json"),
    $CmdDest
)
foreach ($rf in $RequiredFiles) {
    if (Test-Path $rf) {
        Write-Host "  [ PASS ] $rf" -ForegroundColor Green
    } else {
        Write-Host "  [ FAIL ] Missing $rf" -ForegroundColor Red
        $VerificationFailed = $true
    }
}

Write-Host "======================================================" -ForegroundColor Cyan
if (-not $VerificationFailed) {
    Write-Host "[ SUCCESS ] thiwin sovereign setup verified exit code 0" -ForegroundColor Green
} else {
    Write-Host "[ WARN ] Setup completed with missing components." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan
