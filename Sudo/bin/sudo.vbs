' //***************************************************************************
' // ***** Script Header *****
' //
' // File:      Sudo.vbs
' // Additional files required:  Sudo.cmd
' //
' // Purpose:   To provide a command line method of launching applications that
' //            prompt for elevation (Run as Administrator).
' //
' // Usage:     (Not used directly.  Launched from Sudo.cmd)
' //
' // Version:   1.1.2
' // Date :     27-dec-2019
' //
' // History:
' // 1.0.0   01-Feb-2007  Created initial version used internally.
' // 1.0.1   01-Mar-2007  Added detailed usage output.
' // 1.0.0	 23-Oct-2013  Released on chocolatey
' // 1.0.1   08-Sep-2014  chocolatey framework changes required new version
' // 1.0.2   12-Jun-2015  chocolatey framework changes required new version
' // 1.1.0   20-Apr-2018  Added the option of keeping current directory 
' //                      context by using the inserted . or _ as first command argument 
' //                      when used a context cmd shell window is opened for setting 
' //                      current directory context using _ hides this window 
' // 1.1.1   04-Feb-2019  Added the -V or -version option to query the version of sudo
' // 1.1.2   27-dec-2019  Retain current directory even with special chars (janusblack)
' // ***** End Header *****
' //***************************************************************************

Set objShell = CreateObject("Shell.Application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set objWshProcessEnv = objWshShell.Environment("PROCESS")

' Get execution context information from sudo.cmd passed in through environment variables.
strCommandLine = objWshProcessEnv("SUDO_CMDLINE")
strApplicationArgument1 = objWshProcessEnv("SUDO_ARG1")
strApplicationArgument2 = objWshProcessEnv("SUDO_ARG2")
strCurrentDirectory = objWshProcessEnv("SUDO_CD")
strCurrentDrive = objWshProcessEnv("SUDO_DRIVE")

If (WScript.Arguments.Count >= 1) Then
    strFlag = WScript.Arguments(0)
    If (strFlag = "") OR (strFlag="help") OR (strFlag="/h") OR (strFlag="\h") OR (strFlag="-h") _
        OR (strFlag = "\?") OR (strFlag = "/?") OR (strFlag = "-?") OR (strFlag="h") _
        OR (strFlag = "?") Then
        DisplayUsage
		WScript.Quit
    ElseIf (strFlag="-V") OR (strFlag="--version") Then
        DisplayVersion
		WScript.Quit
    Else

        boolKeepCurrentDirectoryContext = ((strApplicationArgument1 = ".") OR (strApplicationArgument1 = "_"))
        boolHideCurrentDirectoryContextCommandWindow = (strApplicationArgument1 = "_")

        If (boolKeepCurrentDirectoryContext = True) Then
            
            If (Len(strApplicationArgument2) > 0) Then  
                strApplication = strApplicationArgument2
                strArguments = Right(strCommandLine, (Len(strCommandLine) - (Len(strApplicationArgument1) + Len(strApplicationArgument2) + 1)))
            Else
                strApplication = "cmd"
                strArguments = ""
            End If

            'Shell.ShellExecute method https://msdn.microsoft.com/en-us/library/windows/desktop/gg537745(v=vs.85).aspx

            If (boolHideCurrentDirectoryContextCommandWindow) Then            
                vShow = 0 'Open the application with a hidden window
                'vShow = 2 'Open the application with a minimized window
                'vShow = 7 'Open the application with a minimized window. The active window remains active.
            Else
                'vShow = 1  'Open the application with a normal window. If the window is minimized or maximized, the system restores it to its original size and position.
                vShow = 10 'Open the application with its window in the default state specified by the application.
            End If

            'WScript.Echo "objShell.ShellExecute ""cmd"",""/C """ & strCurrentDrive & " && cd " & strCurrentDirectory & " && " & strApplication & " " & strArguments & """, """ & strCurrentDirectory & """, ""runas"", " & vShow
            objShell.ShellExecute "cmd","/C """ & strCurrentDrive & " && cd " & strCurrentDirectory & " && " & strApplication & " " & strArguments & """", strCurrentDirectory, "runas", vShow

        Else
            strApplication = strApplicationArgument1
            strArguments = Right(strCommandLine, (Len(strCommandLine) - Len(strApplication)))
        
            'WScript.Echo "objShell.ShellExecute """ & strApplication & """, """ & strArguments & """, """ & strCurrentDirectory & """, ""runas"" "
            objShell.ShellExecute strApplication, strArguments, strCurrentDirectory, "runas"

            'Note that strCurrentDirectory is not respected when runas is used, why the piped commands on a command shell is in use above 

        End if
         
    End If
Else
    DisplayUsage
    WScript.Quit
End If

Sub DisplayVersion

    WScript.Echo "Sudo version 1.1.2" & vbCrLf & _
        "https://chocolatey.org/packages/Sudo" & vbCrLf & _
        "https://github.com/janhebnes/chocolatey-packages/tree/master/Sudo" & vbCrLf

End Sub

Sub DisplayUsage

    WScript.Echo "Start application that prompt for elevation (Run as Administrator)." & vbCrLf & _
                 "" & vbCrLf & _
                "SUDO command" & vbCrLf & _
				"" & vbCrLf & _
				"    elevate command" & vbCrLf & _
				"" & vbCrLf & _
				"SUDO . command" & vbCrLf & _
				"" & vbCrLf & _
				"    elevate and preserve current directory" & vbCrLf & _
				"" & vbCrLf & _
				"SUDO _ command" & vbCrLf & _
				"" & vbCrLf & _
				"    elevate and preserve current directory but hide context window used to set context" & vbCrLf & _
				"" & vbCrLf & _
				"SUDO notepad %cd%\hosts" & vbCrLf & _
				"" & vbCrLf & _
				"    Note also the option of getting the current directory using %CD%\ where you would have used .\" & vbCrLf & _
				 "" & vbCrLf & _
                 "SUDO -V " & vbCrLf & _
                 "SUDO --version" & vbCrLf & _
                 "" & vbCrLf & _
				"    Prints the sudo version as well as the chocolatey package source" & vbCrLf & _
                 "" & vbCrLf & _
                 "Examples:" & vbCrLf & _
                 "" & vbCrLf & _
                 "    sudo cmd /k cd ""C:\Program Files""" & vbCrLf & _
                 "    or       sudo . cmd" & vbCrLf & _
                 "    or       sudo . " & vbCrLf & _
                 "" & vbCrLf & _
                 "    sudo powershell -NoExit -Command Set-Location 'C:\Windows'" & vbCrLf & _
                 "    or       sudo . powershell" & vbCrLf & _
                 "" & vbCrLf & _
                 "    sudo notepad ""c:\Windows\System32\drivers\etc\hosts""" & vbCrLf & _
                 "    or       sudo _ notepad hosts" & vbCrLf & _
                 "    or       sudo notepad %cd%\hosts" & vbCrLf & _
                 "" & vbCrLf & _
                 "" & vbCrLf & _
                 "Note that keeping current directory requires an elevated cmd shell " & vbCrLf & _
                 "that sets directory context before executing your command. " & vbCrLf & _ 
                 "" & vbCrLf & _
                 "You can also keep context by working with %CD%\ on file locations." & vbCrLf & _
                 "" & vbCrLf & _
                 "Usage with scripts: When using the sudo command with scripts such as" & vbCrLf & _
                 "Windows Script Host or Windows PowerShell scripts, you should specify" & vbCrLf & _
                 "the script host executable (i.e., wscript, cscript, powershell) as the " & vbCrLf & _
                 "application." & vbCrLf & _
                 "" & vbCrLf & _
                 "Sample usage with scripts:" & vbCrLf & _
                 "" & vbCrLf & _
                 "    sudo cscript ""C:\windows\system32\slmgr.vbs"" " & vbCrLf & _
                 "    sudo powershell -NoExit -Command & 'C:\Temp\Test.ps1'" & vbCrLf & _
                 "" & vbCrLf & _
                 "" & vbCrLf & _
                 "The sudo command consists of sudo.cmd and sudo.vbs" & vbCrLf

End Sub
