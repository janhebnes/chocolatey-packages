@echo off

:: Pass execution context information through environment variables.
set SUDO_CMDLINE=%*
set SUDO_ARG1=%1
set SUDO_ARG2=%2
set SUDO_CD="%CD%"
set SUDO_DRIVE=%CD:~0,2%

:: %~dpn0 is refering to this files name and %* sends along the full commandline  
cscript //nologo "%~dpn0.vbs" %*
