# ==============================================================================
# SOVEREIGN AI AGENT GOVERNANCE — WINDOWS SYSTEM INSTALLER
# ==============================================================================
# Standard: Sovereign Hardware Cluster & Agent OS Specification
# Target  : Windows 10 / Windows 11 / Windows Server (PowerShell 5.1+)
# Function: Installs 16 formal binding rules, 4-file GEMINI.md parity,
#           valid OpenCode Effect/Zod schema with Hybrid MVO, proxy wrapper,
#           and cross-project SSOT governance on Windows nodes.
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
Write-Host "[ 1/7 ] Initializing AI agent directory structure..." -ForegroundColor Yellow

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
# 2. Deploy 16 Formal Rule Specifications
# ------------------------------------------------------------------------------
Write-Host "[ 2/7 ] Deploying 16 formal binding rule specifications..." -ForegroundColor Yellow

$RulesSourceDir = Join-Path $ScriptDir "rules"
$RulesTargetDir = Join-Path $HomeDir ".gemini\config\rules"

if (Test-Path $RulesSourceDir) {
    $RuleFiles = Get-ChildItem -Path $RulesSourceDir -Filter "*.md"
    foreach ($rule in $RuleFiles) {
        $content = Get-Content -Path $rule.FullName -Raw -Encoding UTF8
        # Normalize Linux paths to generic user paths if necessary
        $content = $content -replace '/home/(fuckadmin|aomiqaza)', $HomeDir.Replace('\', '/')
        $targetFile = Join-Path $RulesTargetDir $rule.Name
        [System.IO.File]::WriteAllText($targetFile, $content, [System.Text.Encoding]::UTF8)
    }
    Write-Host "  [ PASS ] Deployed $($RuleFiles.Count) rule files to $RulesTargetDir" -ForegroundColor Green
} else {
    Write-Host "  [ WARN ] Rules source directory not found: $RulesSourceDir" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# 3. Synchronize All 4 Physical GEMINI.md Files Byte-for-Byte
# ------------------------------------------------------------------------------
Write-Host "[ 3/7 ] Synchronizing GEMINI.md rules across all active agent endpoints..." -ForegroundColor Yellow

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
# 4. Configure OpenCode with Valid Schema & Hybrid MVO
# ------------------------------------------------------------------------------
Write-Host "[ 4/7 ] Configuring OpenCode with valid schema and Hybrid MVO default..." -ForegroundColor Yellow

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

# Check if existing MCP servers exist in ~/.gemini/config/mcp_config.json
$GeminiMcpFile = Join-Path $HomeDir ".gemini\config\mcp_config.json"
if (Test-Path $GeminiMcpFile) {
    try {
        $mcpRaw = Get-Content -Path $GeminiMcpFile -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($mcpRaw.mcpServers) {
            foreach ($prop in $mcpRaw.mcpServers.PSObject.Properties) {
                $serverName = $prop.Name
                $srv = $prop.Value
                $cmdList = @()
                if ($srv.command) { $cmdList += $srv.command }
                if ($srv.args) { $cmdList += $srv.args }

                $serverEntry = [ordered]@{
                    "type" = "local"
                    "command" = $cmdList
                    "enabled" = $false
                }
                if ($srv.env) {
                    $serverEntry["environment"] = $srv.env
                }
                $OpenCodeJson.mcp[$serverName] = $serverEntry
            }
        }
    } catch {
        Write-Host "  [ NOTE ] Could not parse mcp_config.json: $_" -ForegroundColor DarkGray
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
Write-Host "  [ PASS ] Generated OpenCode configs with Hybrid MVO (all MCPs disabled by default)." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 5. OpenCode Proxy Sanitizer Wrapper for Windows
# ------------------------------------------------------------------------------
Write-Host "[ 5/7 ] Installing OpenCode proxy sanitizer wrapper for Windows..." -ForegroundColor Yellow

$OpencodeCmdPath = Join-Path $HomeDir "bin\opencode.cmd"
$OpencodeCmdContent = @"
@echo off
rem ============================================================================
rem OpenCode Proxy Sanitizer Wrapper for Windows
rem Solves Bun fetch UnsupportedProxyProtocol by rewriting socks5:// -> http://
rem ============================================================================

setlocal enabledelayedexpansion

set "TARGET_HTTP=%HTTP_PROXY%"
set "TARGET_HTTPS=%HTTPS_PROXY%"

if defined HTTP_PROXY (
    if "!HTTP_PROXY:~0,9!"=="socks5://" (
        set "HTTP_PROXY=http://!HTTP_PROXY:~9!"
    )
)

if defined HTTPS_PROXY (
    if "!HTTPS_PROXY:~0,9!"=="socks5://" (
        set "HTTPS_PROXY=http://!HTTPS_PROXY:~9!"
    )
)

set "ALL_PROXY="

rem Locate real opencode binary
where opencode.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    opencode.exe %*
    exit /b %ERRORLEVEL%
)

where bun.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    bunx opencode %*
    exit /b %ERRORLEVEL%
)

npx -y opencode %*
exit /b %ERRORLEVEL%
"@

[System.IO.File]::WriteAllText($OpencodeCmdPath, $OpencodeCmdContent, [System.Text.Encoding]::ASCII)
Write-Host "  [ PASS ] Installed proxy wrapper at $OpencodeCmdPath" -ForegroundColor Green

# ------------------------------------------------------------------------------
# 6. Cross-Project SSOT Symlink / Copy across Projects
# ------------------------------------------------------------------------------
Write-Host "[ 6/7 ] Scaffolding AGENTS.md cross-agent SSOT in active projects..." -ForegroundColor Yellow

$ProjectsDir = Join-Path $HomeDir "Projects"
if (Test-Path $ProjectsDir) {
    $SubDirs = Get-ChildItem -Path $ProjectsDir -Directory
    $scaffoldCount = 0
    foreach ($sub in $SubDirs) {
        $geminiFile = Join-Path $sub.FullName "GEMINI.md"
        $agentsFile = Join-Path $sub.FullName "AGENTS.md"

        if (Test-Path $geminiFile) {
            if (-not (Test-Path $agentsFile)) {
                try {
                    # Try creating symbolic link first
                    New-Item -ItemType SymbolicLink -Path $agentsFile -Target "GEMINI.md" -Force -ErrorAction Stop | Out-Null
                    $scaffoldCount++
                } catch {
                    # Fallback to copy if developer mode / privileges disallow symlinks
                    Copy-Item -Path $geminiFile -Destination $agentsFile -Force
                    $scaffoldCount++
                }
            }
        }
    }
    Write-Host "  [ PASS ] Scaffolding complete across $scaffoldCount repositories in $ProjectsDir." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 7. Verification Audit
# ------------------------------------------------------------------------------
Write-Host "[ 7/7 ] Running system verification audit..." -ForegroundColor Yellow

$AllPass = $true
$Checks = @(
    (Join-Path $HomeDir ".gemini\config\rules\agent-persona-invariants.md"),
    (Join-Path $HomeDir ".gemini\config\rules\deterministic-machine-harness.md"),
    (Join-Path $HomeDir ".gemini\config\rules\ponytail-yagni.md"),
    (Join-Path $HomeDir ".gemini\GEMINI.md"),
    (Join-Path $HomeDir ".opencode\OPENCODE.md"),
    (Join-Path $HomeDir ".opencode\opencode.json"),
    $OpencodeCmdPath
)

foreach ($chk in $Checks) {
    if (Test-Path $chk) {
        Write-Host "  [ PASS ] Found: $chk" -ForegroundColor Green
    } else {
        Write-Host "  [ FAIL ] Missing: $chk" -ForegroundColor Red
        $AllPass = $false
    }
}

Write-Host "======================================================" -ForegroundColor Cyan
if ($AllPass) {
    Write-Host "[ SUCCESS ] Windows Sovereign AI Agent Governance Fully Installed!" -ForegroundColor Green
    Write-Host "Node is now 100% compliant with sovereign cluster standards." -ForegroundColor Green
} else {
    Write-Host "[ WARN ] Installation completed with warnings. Check output above." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan
