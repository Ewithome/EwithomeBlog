@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set SITE_URL=https://ewithome.github.io
set LOCAL_URL=http://localhost:4001

if exist "%~dp0proxy.local.bat" call "%~dp0proxy.local.bat"

echo ========================================
echo   Ewithome Blog - Publish
echo ========================================
echo.

where pnpm >nul 2>&1
if errorlevel 1 goto :no_pnpm
where git >nul 2>&1
if errorlevel 1 goto :no_git

echo [1/4] hexo clean...
call pnpm run clean
if errorlevel 1 goto :failed

echo.
echo [2/4] hexo generate...
call pnpm run build
if errorlevel 1 goto :failed

echo.
echo [3/4] deploy to Ewithome.github.io branch main...
call pnpm run deploy
if errorlevel 1 goto :deploy_failed

echo.
echo [4/4] backup source to EwithomeBlog...
git add -A
git diff --cached --quiet
if errorlevel 1 git commit -m "chore: update site"
git push origin main 2>nul

goto :success_online

:deploy_failed
echo.
echo [WARN] deploy failed. Trying GitHub Actions via EwithomeBlog push...
git add -A
git diff --cached --quiet
if errorlevel 1 git commit -m "chore: update site"
git push origin main
if errorlevel 1 goto :network_failed
echo.
echo Source pushed. Wait for Actions green check:
echo https://github.com/Ewithome/EwithomeBlog/actions
echo Then open %SITE_URL%
start https://github.com/Ewithome/EwithomeBlog/actions
goto :success_wait

:success_online
echo.
echo ========================================
echo   Published to Ewithome.github.io main
echo   %SITE_URL%
echo ========================================
start %SITE_URL%
pause
exit /b 0

:success_wait
echo.
pause
exit /b 0

:network_failed
echo.
echo ========================================
echo [ERROR] Cannot reach github.com port 443
echo ========================================
echo.
echo Your build succeeded locally but upload failed.
echo.
echo Fix network, then run publish.bat again:
echo   1. Turn on VPN or system proxy
echo   2. Copy proxy.local.bat.example to proxy.local.bat
echo      Edit port e.g. 7890 or 10809
echo   3. Or run in PowerShell:
echo      git config --global http.https://github.com.proxy http://127.0.0.1:7890
echo.
echo Local preview is starting now:
echo   %LOCAL_URL%
echo ========================================
start %LOCAL_URL%
start "Hexo Preview" cmd /k "cd /d "%~dp0" && pnpm run server"
pause
exit /b 1

:no_pnpm
echo [ERROR] pnpm not found.
pause
exit /b 1

:no_git
echo [ERROR] git not found.
pause
exit /b 1

:failed
echo.
echo [ERROR] Build failed. See log above.
pause
exit /b 1
