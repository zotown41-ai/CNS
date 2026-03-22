@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\publish_literature_tracking.ps1"
if errorlevel 1 (
  echo.
  echo 发布失败，请查看上方日志。
  pause
  exit /b 1
)
echo.
echo 发布完成。
pause
