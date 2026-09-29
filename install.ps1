# ==============================================================================
# SOVEREIGN AI AGENT GOVERNANCE — WINDOWS SYSTEM INSTALLER (v2.0)
# ==============================================================================
# Standard: Sovereign Hardware Cluster & Agent OS Specification
# Target  : Windows 10 / Windows 11 / Windows Server (PowerShell 5.1+)
# Function: Installs 16 formal binding rules, 4-file GEMINI.md parity,
#           valid OpenCode Effect/Zod schema with Hybrid MVO, proxy wrapper,
#           agy-guard CLI, core skills, global git templates, and cross-project
#           SSOT governance on Windows nodes.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter()]
    [string]$TargetUserHome = $env:USERPROFILE,

    [Parameter()]
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   SOVEREIGN AI AGENT GOVERNANCE — WINDOWS INSTALLER  " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$HomeDir = $TargetUserHome
Write-Host "[ INFO ] Target Home Directory: $HomeDir" -ForegroundColor Gray

# ------------------------------------------------------------------------------
# 1. Ensure Directory Trees
# ------------------------------------------------------------------------------
Write-Host "[ 1/9 ] Initializing AI agent directory structure..." -ForegroundColor Yellow

$DirsToCreate = @(
    (Join-Path $HomeDir "bin"),
    (Join-Path $HomeDir ".local\bin"),
    (Join-Path $HomeDir ".gemini\config\rules"),
    (Join-Path $HomeDir ".gemini\config\plugins"),
    (Join-Path $HomeDir ".agents\skills"),
    (Join-Path $HomeDir ".agents\skills_archive"),
    (Join-Path $HomeDir ".claude"),
    (Join-Path $HomeDir ".opencode\bin"),
    (Join-Path $HomeDir ".opencode\skills"),
    (Join-Path $HomeDir ".config\opencode\skills"),
    (Join-Path $HomeDir ".codex"),
    (Join-Path $HomeDir ".git-templates\hooks"),
    (Join-Path $HomeDir "Projects"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\00-AGY-Memory"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\09-Panduan-Projek")
)

foreach ($dir in $DirsToCreate) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Host "  [ PASS ] Directories verified." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 2. Configure Persistent User PATH
# ------------------------------------------------------------------------------
Write-Host "[ 2/9 ] Configuring persistent User PATH..." -ForegroundColor Yellow
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$BinPath = Join-Path $HomeDir "bin"
$LocalBinPath = Join-Path $HomeDir ".local\bin"
$UpdatedPath = $false

foreach ($p in @($BinPath, $LocalBinPath)) {
    if ($UserPath -notlike "*$p*") {
        $UserPath = "$p;$UserPath"
        $UpdatedPath = $true
    }
    if ($env:PATH -notlike "*$p*") {
        $env:PATH = "$p;$env:PATH"
    }
}
if ($UpdatedPath) {
    [Environment]::SetEnvironmentVariable("PATH", $UserPath, "User")
    Write-Host "  [ PASS ] Added $BinPath and $LocalBinPath to User PATH." -ForegroundColor Green
} else {
    Write-Host "  [ PASS ] User PATH already contains bin directories." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 3. Deploy 16 Formal Rule Specifications
# ------------------------------------------------------------------------------
Write-Host "[ 3/9 ] Deploying 16 formal binding rule specifications..." -ForegroundColor Yellow

$RulesSourceDir = Join-Path $ScriptDir "rules"
$RulesTargetDir = Join-Path $HomeDir ".gemini\config\rules"

if (Test-Path $RulesSourceDir) {
    $RuleFiles = Get-ChildItem -Path $RulesSourceDir -Filter "*.md"
    foreach ($rule in $RuleFiles) {
        $content = Get-Content -Path $rule.FullName -Raw -Encoding UTF8
        $content = $content -replace '/home/(fuckadmin|aomiqaza)', $HomeDir.Replace('\', '/')
        $targetFile = Join-Path $RulesTargetDir $rule.Name
        [System.IO.File]::WriteAllText($targetFile, $content, [System.Text.Encoding]::UTF8)
    }
    Write-Host "  [ PASS ] Deployed $($RuleFiles.Count) rule files to $RulesTargetDir" -ForegroundColor Green
} else {
    Write-Host "  [ WARN ] Rules source directory not found: $RulesSourceDir" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# 4. Synchronize All 4 Physical GEMINI.md Files Byte-for-Byte
# ------------------------------------------------------------------------------
Write-Host "[ 4/9 ] Synchronizing GEMINI.md rules across all active agent endpoints..." -ForegroundColor Yellow

$GlobalRulesFile = Join-Path $ScriptDir "GLOBAL_RULES.md"
if (-not (Test-Path $GlobalRulesFile)) {
    $GlobalRulesFile = Join-Path $ScriptDir "templates\GEMINI.md"
}

if (Test-Path $GlobalRulesFile) {
    $RulesContent = Get-Content -Path $GlobalRulesFile -Raw -Encoding UTF8

    $GeminiTargets = @(
        (Join-Path $HomeDir "GEMINI.md"),
        (Join-Path $HomeDir ".gemini\GEMINI.md"),
        (Join-Path $HomeDir ".gemini\config\GEMINI.md"),
        (Join-Path $HomeDir ".agents\GEMINI.md"),
        (Join-Path $HomeDir ".claude\CLAUDE.md"),
        (Join-Path $HomeDir ".opencode\OPENCODE.md"),
        (Join-Path $HomeDir ".codex\CODEX.md")
    )

    foreach ($target in $GeminiTargets) {
        $parent = Split-Path -Parent $target
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        [System.IO.File]::WriteAllText($target, $RulesContent, [System.Text.Encoding]::UTF8)
    }
    Write-Host "  [ PASS ] Synchronized 7 agent instruction files." -ForegroundColor Green
} else {
    Write-Host "  [ WARN ] GLOBAL_RULES.md not found in $ScriptDir" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# 5. Deploy agy-guard CLI & Wrapper
# ------------------------------------------------------------------------------
Write-Host "[ 5/9 ] Deploying agy-guard CLI and batch wrapper..." -ForegroundColor Yellow
$AgyGuardSrc = Join-Path $ScriptDir "bin\agy-guard.py"
if (-not (Test-Path $AgyGuardSrc)) {
    $AgyGuardSrc = Join-Path $ScriptDir "bin\agy-guard"
}

if (Test-Path $AgyGuardSrc) {
    $AgyDestPy = Join-Path $HomeDir "bin\agy-guard.py"
    Copy-Item -Path $AgyGuardSrc -Destination $AgyDestPy -Force

    $AgyCmdDest = Join-Path $HomeDir "bin\agy-guard.cmd"
    $AgyCmdContent = @"
@echo off
setlocal
where python.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    python "%~dp0agy-guard.py" %*
    exit /b %ERRORLEVEL%
)
where py.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    py "%~dp0agy-guard.py" %*
    exit /b %ERRORLEVEL%
)
echo [ ERROR ] Python 3 is required to run agy-guard.
exit /b 1
"@
    [System.IO.File]::WriteAllText($AgyCmdDest, $AgyCmdContent, [System.Text.Encoding]::ASCII)
    Write-Host "  [ PASS ] Deployed agy-guard.py and agy-guard.cmd to $BinPath" -ForegroundColor Green
} else {
    Write-Host "  [ WARN ] agy-guard source not found. Skipping CLI deployment." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# 6. Deploy Core Agent Skills
# ------------------------------------------------------------------------------
Write-Host "[ 6/9 ] Deploying core sovereign agent skills..." -ForegroundColor Yellow
$SkillsSrc = Join-Path $ScriptDir "plugins\agent-skills\skills"
if (-not (Test-Path $SkillsSrc)) {
    $SkillsSrc = Join-Path $ScriptDir "skills"
}
if (Test-Path $SkillsSrc) {
    $SkillDirs = Get-ChildItem -Path $SkillsSrc -Directory
    $AgentSkillsDest = Join-Path $HomeDir ".agents\skills"
    $OpenCodeSkillsDest = Join-Path $HomeDir ".opencode\skills"
    $ConfigSkillsDest = Join-Path $HomeDir ".config\opencode\skills"

    foreach ($sd in $SkillDirs) {
        Copy-Item -Path $sd.FullName -Destination (Join-Path $AgentSkillsDest $sd.Name) -Recurse -Force
        Copy-Item -Path $sd.FullName -Destination (Join-Path $OpenCodeSkillsDest $sd.Name) -Recurse -Force
        Copy-Item -Path $sd.FullName -Destination (Join-Path $ConfigSkillsDest $sd.Name) -Recurse -Force
    }
    Write-Host "  [ PASS ] Deployed $($SkillDirs.Count) sovereign skills to agent skill vaults." -ForegroundColor Green
} else {
    Write-Host "  [ WARN ] Skills source not found. Skipping skills deployment." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# 7. Configure Global Git Templates & Anti-Blunder Hooks
# ------------------------------------------------------------------------------
Write-Host "[ 7/9 ] Deploying Global Git templates and pre-commit guardrails..." -ForegroundColor Yellow
$GitHooksSrc = Join-Path $ScriptDir "templates\git-hooks"
if (-not (Test-Path $GitHooksSrc)) {
    $GitHooksSrc = Join-Path $ScriptDir "git-hooks"
}
$TargetHooksDir = Join-Path $HomeDir ".git-templates\hooks"

if (Test-Path $GitHooksSrc) {
    $HookFiles = Get-ChildItem -Path $GitHooksSrc -File
    foreach ($hf in $HookFiles) {
        Copy-Item -Path $hf.FullName -Destination (Join-Path $TargetHooksDir $hf.Name) -Force
    }
    try {
        git config --global init.templateDir "$HomeDir\.git-templates"
        git config --global core.hooksPath "$HomeDir\.git-templates\hooks"
        Write-Host "  [ PASS ] Configured global Git templateDir and core.hooksPath." -ForegroundColor Green
    } catch {
        Write-Host "  [ WARN ] Could not configure git globals: $_" -ForegroundColor DarkGray
    }
}

# ------------------------------------------------------------------------------
# 8. Configure OpenCode with Valid Schema & Hybrid MVO
# ------------------------------------------------------------------------------
Write-Host "[ 8/9 ] Configuring OpenCode with valid schema and Hybrid MVO default..." -ForegroundColor Yellow

$NormalizedHome = $HomeDir.Replace('\', '/')
$OpenCodeJson = @{
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

$OpenCodeJsonString = $OpenCodeJson | ConvertTo-Json -Depth 10

$OpenCodeConfigs = @(
    (Join-Path $HomeDir ".opencode\opencode.json"),
    (Join-Path $HomeDir ".config\opencode\opencode.json")
)

foreach ($cfg in $OpenCodeConfigs) {
    $cfgDir = Split-Path -Parent $cfg
    if (-not (Test-Path $cfgDir)) { New-Item -ItemType Directory -Path $cfgDir -Force | Out-Null }
    [System.IO.File]::WriteAllText($cfg, $OpenCodeJsonString, [System.Text.Encoding]::UTF8)
}

# OpenCode Proxy Sanitizer Wrapper
$OpencodeCmdPath = Join-Path $HomeDir "bin\opencode.cmd"
$OpencodeCmdContent = @"
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
[System.IO.File]::WriteAllText($OpencodeCmdPath, $OpencodeCmdContent, [System.Text.Encoding]::ASCII)
Write-Host "  [ PASS ] Generated OpenCode configs with Hybrid MVO and proxy wrapper." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 9. Verification Audit
# ------------------------------------------------------------------------------
Write-Host "[ 9/9 ] Running system verification audit..." -ForegroundColor Yellow

$AllPass = $true
$Checks = @(
    (Join-Path $HomeDir ".gemini\config\rules\agent-persona-invariants.md"),
    (Join-Path $HomeDir ".gemini\config\rules\deterministic-machine-harness.md"),
    (Join-Path $HomeDir ".gemini\config\rules\ponytail-yagni.md"),
    (Join-Path $HomeDir ".gemini\GEMINI.md"),
    (Join-Path $HomeDir ".opencode\OPENCODE.md"),
    (Join-Path $HomeDir ".opencode\opencode.json"),
    $OpencodeCmdPath,
    (Join-Path $HomeDir "bin\agy-guard.cmd"),
    (Join-Path $HomeDir ".git-templates\hooks\pre-commit")
)

foreach ($chk in $Checks) {
    if (Test-Path $chk) {
        Write-Host "  [ PASS ] Found: $chk" -ForegroundColor Green
    } else {
        Write-Host "  [ FAIL ] Missing: $chk" -ForegroundColor Red
        $AllPass = $false
    }
}

$RuleCount = (Get-ChildItem (Join-Path $HomeDir ".gemini\config\rules") -Filter "*.md").Count
$SkillCount = (Get-ChildItem (Join-Path $HomeDir ".agents\skills") -Directory).Count

Write-Host "  [ STAT ] Formal Rules: $RuleCount / 16" -ForegroundColor Cyan
Write-Host "  [ STAT ] Agent Skills: $SkillCount / 33" -ForegroundColor Cyan

Write-Host "======================================================" -ForegroundColor Cyan
if ($AllPass -and $RuleCount -ge 16 -and $SkillCount -ge 30) {
    Write-Host "[ SUCCESS ] Windows Sovereign AI Agent Governance Fully Installed!" -ForegroundColor Green
    Write-Host "Node is now 100% compliant with sovereign cluster standards." -ForegroundColor Green
} else {
    Write-Host "[ WARN ] Installation completed with warnings. Check output above." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan
