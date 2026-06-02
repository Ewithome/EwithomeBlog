@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set SITE_URL=https://ewithome.github.io

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

goto :success

:deploy_failed
echo.
echo [WARN] Local deploy failed. Pushing source for GitHub Actions...
git add -A
git diff --cached --quiet
if errorlevel 1 git commit -m "chore: update site"
git push origin main
if errorlevel 1 goto :push_failed
echo Open Actions and wait for green check:
echo https://github.com/Ewithome/EwithomeBlog/actions
goto :success

:success
echo.
echo ========================================
echo   Done. Live site uses main branch:
echo   %SITE_URL%
echo.
echo   GitHub Pages settings on Ewithome.github.io:
echo   Branch = main , folder = / root
echo ========================================
start %SITE_URL%
pause
exit /b 0

:no_pnpm
echo [ERROR] pnpm not found.
pause
exit /b 1

:no_git
echo [ERROR] git not found.
pause
exit /b 1

:push_failed
echo.
echo [ERROR] Cannot reach github.com. Use VPN/proxy and retry.
echo.
pause
exit /b 1

:failed
echo.
echo [ERROR] Build failed. See log above.
pause
exit /b 1
