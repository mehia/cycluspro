@echo off
title myhabits - instalador de atalho
echo.
echo   ==========================================
echo    myhabits - criando o atalho do aplicativo
echo   ==========================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1"
echo.
pause
