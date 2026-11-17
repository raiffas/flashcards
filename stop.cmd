@echo off
REM Wrapper so it works from cmd or double-click; bypasses execution policy for this run only
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
