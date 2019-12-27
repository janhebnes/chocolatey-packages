### [https://chocolatey.org/packages/Sudo](https://chocolatey.org/packages/Sudo)

    λ choco install sudo
    or
    λ choco upgrade sudo


# sudo /?

Start application that prompt for elevation (Run as Administrator).

SUDO command
>elevate command

SUDO . command
>elevate and preserve current directory

SUDO _ command
>elevate and preserve current directory but hide context window used to set context

SUDO notepad %cd%\hosts
> *Note also the option of getting the current directory using %CD%\ where you would have used .\ on file path arguments*

SUDO -V
>returns the version and source

Examples:

    sudo cmd /k cd "C:\Program Files"
    or       sudo . cmd
    or       sudo .

    sudo powershell -NoExit -Command Set-Location 'C:\Windows'
    or       sudo . powershell

    sudo notepad "c:\Windows\System32\drivers\etc\hosts"
    or       sudo _ notepad hosts
    or       sudo notepad %cd%\hosts
    
    sudo -V 
    sudo --version
    
    Sudo version 1.1.2
    https://chocolatey.org/packages/Sudo
    https://github.com/janhebnes/chocolatey-packages/tree/master/Sudo

 

Note that keeping current directory requires an elevated cmd shell
that sets directory context before executing your command.

You can also keep context by working with %CD%\ on file locations.

Usage with scripts: When using the sudo command with scripts such as
Windows Script Host or Windows PowerShell scripts, you should specify
the script host executable (i.e., wscript, cscript, powershell) as the
application.

Sample usage with scripts:

    sudo cscript "C:\windows\system32\slmgr.vbs"
    sudo powershell -NoExit -Command & 'C:\Temp\Test.ps1'


The sudo command consists of sudo.cmd and sudo.vbs








