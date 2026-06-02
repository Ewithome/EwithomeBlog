@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo   Local deploy - needs GitHub access
echo ========================================
echo.

where pnpm >nul 2>&1
if errorlevel 1 goto :no_pnpm

call pnpm run clean
if errorlevel 1 goto :failed
call pnpm run build
if errorlevel 1 goto :failed
call pnpm run deploy
if errorlevel 1 goto :failed

echo Done: https://ewithome.github.io
pause
exit /b 0

:no_pnpm
echo [ERROR] pnpm not found.
pause
exit /b 1

:failed
echo [ERROR] Failed. Use publish.bat + GitHub Actions if network blocks GitHub.
pause
exit /b 1
