@echo off

if "%~1"=="?" goto HELP
if "%~1"=="/?" goto HELP
if "%~1"=="" goto HELP 

:: Pass raw command line agruments and first argument to Elevate.vbs
:: through environment variables.
set ELEVATE_CMDLINE=%*
set ELEVATE_APP=%1

cscript //nologo "%~dpn0.vbs" %*

GOTO:EOF

:HELP
echo  Provides a command line method of launching applications that prompt for elevation (Run as Administrator).
echo.   
echo    sudo [command]
GOTO:EOF