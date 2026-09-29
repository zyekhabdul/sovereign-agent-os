# SOVEREIGN AI AGENT GOVERNANCE — THIWIN RUNTIME SPECIFICATION

- **Node Identifier**: `core-002` (`thiwin` / `thinkpad-win`)
- **Host OS**: Windows 11 Pro / Enterprise (x86_64)
- **Primary Users**: `sysdevadmin` / `laptop-admin`
- **Target Agents**: Antigravity CLI (`agy`), OpenCode, Claude Code, Codex, VSCode/Cursor
- **Network**: Tailscale (`100.78.84.3`), MeshCentral Zero-Footprint Transport, Rathole (`22016`)
- **Applicability**: Mandatory for all AI agents executing on node `thiwin`

---

## 1. SOVEREIGN AGENT ARCHITECTURE & INVARIANTS

Every AI coding agent operating on `thiwin` MUST strictly adhere to the unified cluster standards:
1. **Watak Kognitif (Persona)**: Objective Technical Mentor. Caveman terse, high-density, root-cause focused. Zero pleasantries, strict no-emoji.
2. **Supreme Operational Principle**: Autonomous single-stream execution. Machine as quality arbiter (compiler, typechecker, test runner returning exit code 0).
3. **Ponytail / YAGNI**: Minimalist code generation, zero speculative abstraction, minimal diff radius.
4. **Inspect Before Apply ("Cari Dulu Baru Terapkan")**: Never mutate code without prior inspection.
5. **Git Push Restriction**: `git commit` is permitted locally for checkpoints; `git push` is STRICTLY PROHIBITED without explicit human command.
6. **Sovereign Host Discipline**: Never bind development servers to active production ports.

---

## 2. REQUISITE DIRECTORY ARCHITECTURE (WINDOWS)

The AI agent on `thiwin` must ensure the following directories exist under `$env:USERPROFILE`:

```powershell
$Dirs = @(
    "$env:USERPROFILE\bin",
    "$env:USERPROFILE\.local\bin",
    "$env:USERPROFILE\.gemini\config\rules",
    "$env:USERPROFILE\.gemini\config\plugins",
    "$env:USERPROFILE\.agents\skills",
    "$env:USERPROFILE\.opencode\bin",
    "$env:USERPROFILE\.opencode\skills",
    "$env:USERPROFILE\.config\opencode\skills",
    "$env:USERPROFILE\.claude",
    "$env:USERPROFILE\.codex",
    "$env:USERPROFILE\Projects",
    "$env:USERPROFILE\Documents\Obsidian Vault\00-AGY-Memory",
    "$env:USERPROFILE\Documents\Obsidian Vault\09-Panduan-Projek"
)
foreach ($d in $Dirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force } }
```

---

## 3. OPENCODE HYBRID MVO SPECIFICATION & SCHEMA REQUIREMENT

### Critical Issue: Claude-Style Schema Rejection & Bun Proxy Protocol Error
OpenCode v1.0.x uses an Effect/Zod validator. Writing Claude-style configuration (`command: string, args: [], env: {}`) causes startup failure:
`Invalid input: expected "local" or "remote"`

Additionally, if Cloudflare WARP (`127.0.0.1:40000`) or SOCKS5 proxies are present in environment variables (`HTTP_PROXY`, `ALL_PROXY`), Bun's native `fetch()` fails with:
`UnsupportedProxyProtocol fetching "https://opencode.ai/zen/v1/responses"`

### Required Schema & Hybrid MVO Configuration (`%USERPROFILE%\.opencode\opencode.json`):
1. **MCP Definition**:
   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "server-name": {
         "type": "local",
         "command": ["node", "C:/path/to/server.js"],
         "environment": { "KEY": "value" },
         "enabled": false
       }
     },
     "instructions": [
       "C:/Users/<user>/.opencode/OPENCODE.md",
       "C:/Users/<user>/.gemini/config/rules/agent-persona-invariants.md",
       "C:/Users/<user>/.gemini/config/rules/ponytail-yagni.md",
       "C:/Users/<user>/.gemini/config/rules/deterministic-machine-harness.md"
     ],
     "skills": {
       "paths": [
         "C:/Users/<user>/.opencode/skills",
         "C:/Users/<user>/.config/opencode/skills"
       ]
     },
     "tool_output": {
       "max_lines": 200,
       "max_bytes": 16384
     },
     "compaction": {
       "auto": true,
       "tail_turns": 15
     }
   }
   ```
2. **Hybrid MVO Law**: All MCP servers MUST have `"enabled": false` by default. MCPs are activated on-demand per project or per session to prevent process contention and massive prompt token tax (~30k tokens/turn).

---

## 4. PROXY PROTOCOL SANITIZER WRAPPER (`opencode.cmd`)

Place in `%USERPROFILE%\bin\opencode.cmd` (and ensure `%USERPROFILE%\bin` is in Windows `PATH`):

```bat
@echo off
setlocal enabledelayedexpansion

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
```

---

## 5. CROSS-PROJECT SSOT GOVERNANCE (`AGENTS.md`)

In every repository located in `%USERPROFILE%\Projects\<repo>\`:
Ensure `AGENTS.md` exists and points to `GEMINI.md`.
```powershell
Get-ChildItem -Path "$env:USERPROFILE\Projects" -Directory | ForEach-Object {
    $g = Join-Path $_.FullName "GEMINI.md"
    $a = Join-Path $_.FullName "AGENTS.md"
    if (Test-Path $g -and -not (Test-Path $a)) {
        try { New-Item -ItemType SymbolicLink -Path $a -Target "GEMINI.md" -Force }
        catch { Copy-Item -Path $g -Destination $a -Force }
    }
}
```

---

## 6. ONE-SHOT AUTONOMOUS EXECUTION COMMAND

To bootstrap node `thiwin` in one command, run in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-sovereign-thiwin.ps1
```

### Empirical Verification Gate:
```powershell
# 1. Verify OpenCode models exit 0
opencode models

# 2. Verify OpenCode run
opencode run "echo sovereign-ok"

# 3. Verify rule files exist
Get-ChildItem -Path "$env:USERPROFILE\.gemini\config\rules" | Measure-Object | Select-Object -ExpandProperty Count
# Target: >= 16 rule files
```
