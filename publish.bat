@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo   Ewithome Blog - Publish
echo ========================================
echo.

where pnpm >nul 2>&1
if errorlevel 1 goto :no_pnpm
where git >nul 2>&1
if errorlevel 1 goto :no_git

echo [1/3] hexo clean...
call pnpm run clean
if errorlevel 1 goto :failed

echo.
echo [2/3] hexo generate...
call pnpm run build
if errorlevel 1 goto :failed

echo.
echo [3/3] git push source - GitHub Actions will deploy...
git add -A
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "chore: update site"
) else (
  echo No file changes. Pushing anyway if needed...
)

git push origin main
if errorlevel 1 goto :push_failed

echo.
echo ========================================
echo   Source pushed. CI deploys gh-pages.
echo   Site: https://ewithome.github.io
echo   Actions: https://github.com/Ewithome/EwithomeBlog/actions
echo   Wait 2-5 minutes after green checkmark.
echo ========================================
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
echo [ERROR] git push failed - cannot reach github.com
echo Try VPN/proxy, or run publish-local.bat with VPN.
echo First time: set DEPLOY_KEY secret - see README.md
echo.
pause
exit /b 1

:failed
echo.
echo [ERROR] Build failed. See log above.
pause
exit /b 1
