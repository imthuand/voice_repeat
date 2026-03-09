@echo off
setlocal

REM Move to project root (one level above /tool)
cd /d "%~dp0.."

echo ============================
echo Voice Repeat - Verify
echo Project Root: %CD%
echo ============================

echo.
echo [1/4] flutter pub get
call flutter pub get
if errorlevel 1 goto fail

echo.
echo [2/4] build_runner
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 goto fail

echo.
echo [3/4] flutter analyze
call flutter analyze
if errorlevel 1 goto fail

echo.
echo [4/4] flutter test (if tests exist)

IF EXIST test (
    call flutter test
    if errorlevel 1 goto fail
) ELSE (
    echo No test folder found, skipping tests
)

echo.
echo ============================
echo OK - verify passed
echo ============================
exit /b 0

:fail
echo.
echo ============================
echo FAIL - verify failed
echo ============================
exit /b 1