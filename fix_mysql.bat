@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo     AUTO FIX XAMPP MySQL - DATA RECOVERY
echo ===============================================
echo.

REM --- Step 1: get date in YYYYMMDD format ---
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set dd=%%a
    set mm=%%b
    set yyyy=%%c
)

set BACKUPFOLDER=data_fix_using_bat_%yyyy%%mm%%dd%

echo Renaming old data folder to: %BACKUPFOLDER%
rename data %BACKUPFOLDER%

REM --- Step 2: Copy mysql/backup to new data folder ---
echo Creating new data folder from mysql\backup...
xcopy backup data /E /H /C /I /Q

REM --- Step 3: Copy database folders (except system folders) ---
echo Restoring your databases...

for /d %%D in (%BACKUPFOLDER%\*) do (
    set FOLDER=%%~nxD

    if /I NOT "!FOLDER!"=="mysql" (
    if /I NOT "!FOLDER!"=="performance_schema" (
    if /I NOT "!FOLDER!"=="phpmyadmin" (
    if /I NOT "!FOLDER!"=="test" (

        echo Copying database: !FOLDER!
        xcopy "%%D" "data\!FOLDER!\" /E /H /C /I /Q

    ))))
)

REM --- Step 4: Copy ibdata1 ---
echo Copying ibdata1 file...
copy "%BACKUPFOLDER%\ibdata1" "data\ibdata1" /Y

echo.
echo ===============================================
echo   ✔ MySQL Auto-Fix Completed  
echo   Now start MySQL from XAMPP Control Panel
echo ===============================================
pause
