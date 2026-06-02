@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo Local preview: http://localhost:4001
echo Press Ctrl+C in this window to stop.
echo.

where pnpm >nul 2>&1
if errorlevel 1 (
  echo [ERROR] pnpm not found.
  pause
  exit /b 1
)

start http://localhost:4001
call pnpm run server
