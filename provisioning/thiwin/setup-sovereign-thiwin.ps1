# ==============================================================================
# SOVEREIGN AI AGENT GOVERNANCE — THIWIN DEDICATED BOOTSTRAPPER (v2.0)
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
Write-Host "   SOVEREIGN NODE BOOTSTRAP: THIWIN (CORE-002) v2.0   " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..") -ErrorAction SilentlyContinue
$HomeDir = $TargetUserHome
Write-Host "[ INFO ] Target Home: $HomeDir" -ForegroundColor Gray
Write-Host "[ INFO ] Script Dir : $ScriptDir" -ForegroundColor Gray

# ------------------------------------------------------------------------------
# 1. Directory Tree
# ------------------------------------------------------------------------------
Write-Host "[ 1/9 ] Initializing sovereign directory tree..." -ForegroundColor Yellow
$Dirs = @(
    (Join-Path $HomeDir "bin"),
    (Join-Path $HomeDir ".local\bin"),
    (Join-Path $HomeDir ".gemini\config\rules"),
    (Join-Path $HomeDir ".gemini\config\plugins"),
    (Join-Path $HomeDir ".agents\skills"),
    (Join-Path $HomeDir ".agents\skills_archive"),
    (Join-Path $HomeDir ".opencode\bin"),
    (Join-Path $HomeDir ".opencode\skills"),
    (Join-Path $HomeDir ".config\opencode\skills"),
    (Join-Path $HomeDir ".claude"),
    (Join-Path $HomeDir ".codex"),
    (Join-Path $HomeDir ".git-templates\hooks"),
    (Join-Path $HomeDir "Projects"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\00-AGY-Memory"),
    (Join-Path $HomeDir "Documents\Obsidian Vault\09-Panduan-Projek")
)
foreach ($d in $Dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
Write-Host "  [ PASS ] Directories created." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 2. Configure User PATH
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
# 3. Deploy 16 Formal Rules
# ------------------------------------------------------------------------------
Write-Host "[ 3/9 ] Deploying 16 formal binding rules..." -ForegroundColor Yellow
$RulesDir = Join-Path $ScriptDir "rules"
if (-not (Test-Path $RulesDir) -and $RepoRoot) {
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
} else {
    Write-Host "  [ FAIL ] Rules directory not found!" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# 4. Synchronize GEMINI.md & Instructions
# ------------------------------------------------------------------------------
Write-Host "[ 4/9 ] Deploying cross-agent SSOT root files..." -ForegroundColor Yellow
$GlobalRules = Join-Path $ScriptDir "GLOBAL_RULES.md"
if (-not (Test-Path $GlobalRules) -and $RepoRoot) {
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

# ------------------------------------------------------------------------------
# 5. Deploy agy-guard CLI & Wrapper
# ------------------------------------------------------------------------------
Write-Host "[ 5/9 ] Deploying agy-guard CLI and batch wrapper..." -ForegroundColor Yellow
$AgyGuardSrc = Join-Path $ScriptDir "bin\agy-guard.py"
if (-not (Test-Path $AgyGuardSrc)) {
    $AgyGuardSrc = Join-Path $ScriptDir "bin\agy-guard"
}
if (-not (Test-Path $AgyGuardSrc) -and $RepoRoot) {
    $AgyGuardSrc = Join-Path $RepoRoot "bin\agy-guard"
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
$SkillsSrc = Join-Path $ScriptDir "skills"
if (-not (Test-Path $SkillsSrc) -and $RepoRoot) {
    $SkillsSrc = Join-Path $RepoRoot "plugins\agent-skills\skills"
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
$GitHooksSrc = Join-Path $ScriptDir "git-hooks"
if (-not (Test-Path $GitHooksSrc) -and $RepoRoot) {
    $GitHooksSrc = Join-Path $RepoRoot "templates\git-hooks"
}
$TargetHooksDir = Join-Path $HomeDir ".git-templates\hooks"

if (Test-Path $GitHooksSrc) {
    $HookFiles = Get-ChildItem -Path $GitHooksSrc -File
    foreach ($hf in $HookFiles) {
        Copy-Item -Path $hf.FullName -Destination (Join-Path $TargetHooksDir $hf.Name) -Force
    }
    # Configure Git globals
    try {
        git config --global init.templateDir "$HomeDir\.git-templates"
        git config --global core.hooksPath "$HomeDir\.git-templates\hooks"
        Write-Host "  [ PASS ] Configured global Git templateDir and core.hooksPath." -ForegroundColor Green
    } catch {
        Write-Host "  [ WARN ] Could not configure git globals: $_" -ForegroundColor DarkGray
    }
}

# ------------------------------------------------------------------------------
# 8. OpenCode Configuration & Proxy Wrapper
# ------------------------------------------------------------------------------
Write-Host "[ 8/9 ] Configuring OpenCode (Effect/Zod schema, Hybrid MVO, Proxy Wrapper)..." -ForegroundColor Yellow
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

# Proxy Sanitizer Wrapper
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
Write-Host "  [ PASS ] OpenCode configured and proxy wrapper installed." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 9. Verification Audit
# ------------------------------------------------------------------------------
Write-Host "[ 9/9 ] Running complete verification audit..." -ForegroundColor Yellow
$VerificationFailed = $false
$RequiredFiles = @(
    (Join-Path $HomeDir ".gemini\config\rules\agent-persona-invariants.md"),
    (Join-Path $HomeDir ".gemini\config\rules\deterministic-machine-harness.md"),
    (Join-Path $HomeDir ".gemini\config\rules\ponytail-yagni.md"),
    (Join-Path $HomeDir ".gemini\GEMINI.md"),
    (Join-Path $HomeDir ".opencode\OPENCODE.md"),
    (Join-Path $HomeDir ".opencode\opencode.json"),
    (Join-Path $HomeDir "bin\opencode.cmd"),
    (Join-Path $HomeDir "bin\agy-guard.cmd"),
    (Join-Path $HomeDir ".git-templates\hooks\pre-commit")
)
foreach ($rf in $RequiredFiles) {
    if (Test-Path $rf) {
        Write-Host "  [ PASS ] $rf" -ForegroundColor Green
    } else {
        Write-Host "  [ FAIL ] Missing $rf" -ForegroundColor Red
        $VerificationFailed = $true
    }
}

$RuleCount = (Get-ChildItem (Join-Path $HomeDir ".gemini\config\rules") -Filter "*.md").Count
$SkillCount = (Get-ChildItem (Join-Path $HomeDir ".agents\skills") -Directory).Count

Write-Host "  [ STAT ] Formal Rules: $RuleCount / 16" -ForegroundColor Cyan
Write-Host "  [ STAT ] Agent Skills: $SkillCount / 33" -ForegroundColor Cyan

Write-Host "======================================================" -ForegroundColor Cyan
if (-not $VerificationFailed -and $RuleCount -ge 16 -and $SkillCount -ge 30) {
    Write-Host "[ SUCCESS ] thiwin sovereign setup verified exit code 0" -ForegroundColor Green
} else {
    Write-Host "[ WARN ] Setup completed with warnings or missing items." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan
