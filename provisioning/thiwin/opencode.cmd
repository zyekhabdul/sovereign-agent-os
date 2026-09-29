@echo off
rem ============================================================================
rem OpenCode Proxy Sanitizer Wrapper for Windows (thiwin / core-002)
rem Rewrites socks5:// to http:// to prevent Bun fetch UnsupportedProxyProtocol
rem ============================================================================

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
