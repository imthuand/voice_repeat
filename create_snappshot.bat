@echo off
setlocal enabledelayedexpansion

REM === CONFIG ===
set PROJECT_NAME=voice_repeat
set SNAPSHOT_NAME=%PROJECT_NAME%_snapshot_v1.zip

REM === TIMESTAMP ===
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set MIN=%dt:~10,2%

set SNAPSHOT_NAME=%PROJECT_NAME%_%YYYY%-%MM%-%DD%_%HH%-%MIN%.zip

echo.
echo Creating snapshot: %SNAPSHOT_NAME%
echo.

REM === TEMP FOLDER ===
set TEMP_DIR=__snapshot_temp__

if exist %TEMP_DIR% (
    rmdir /s /q %TEMP_DIR%
)

mkdir %TEMP_DIR%

REM === COPY CORE FILES ===
xcopy lib %TEMP_DIR%\lib /E /I /Y
xcopy test %TEMP_DIR%\test /E /I /Y

if exist pubspec.yaml copy pubspec.yaml %TEMP_DIR%\
if exist analysis_options.yaml copy analysis_options.yaml %TEMP_DIR%\

if exist docs xcopy docs %TEMP_DIR%\docs /E /I /Y

REM === CREATE ZIP USING POWERSHELL ===
powershell -Command "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%SNAPSHOT_NAME%' -Force"

REM === CLEANUP ===
rmdir /s /q %TEMP_DIR%

echo.
echo Snapshot created successfully: %SNAPSHOT_NAME%
echo.
pause