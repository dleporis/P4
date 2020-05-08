#SingleInstance, force

^f:: ; CTRL+f pressed
	WinActivate, Recording Configration ahk_class QWidget ahk_exe EmotivXavierTestBench.exe
	Sleep, 100
	Click, 202, 23
	Send, C:\Faculta\ROB4\Recordings
	Sleep, 100
	Send, %A_Tab%
	Sleep, 100
	Send, testt
	Sleep, 100
	Send, %A_Tab%
	Sleep, 100
	Send, 3
	Sleep, 100
	Send, %A_Tab%
	Sleep, 100
	Send, 3
	Sleep, 100
	
^e:: ; CTRL+e pressed
	; Open EEG EmotivXavierTestBench window to activate the recording of EEG
	WinActivate, Recording Configration ahk_class QWidget ahk_exe EmotivXavierTestBench.exe
															
	/*
	; test on Win10 calculator in case EEG recorder is not available
	WinActivate, Calculator ahk_class ApplicationFrameWindow	; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow	; maximise window
	Click, 200, 870 												
	Click, 1400,870 												
	Click, 600, 870 												
	Click, 1400, 990 								
	*/
	
	Click, 224, 259 ; click on the 'start recording' button
	;Sleep, 500 ; to see that the recording has started
	WinActivate P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window to stimulus
	WinMaximize P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window
	
	Sleep, 10000 ; 10 seconds pre-stimulus period
	
	Send, e ; start stimulus
	Sleep, 10000 ; 10 seconds stimulus period
	Send, q ; stop stimulus

	Sleep, 10000 ; 10 seconds after-stimulus period		
											;
	; Open EEG EmotivXavierTestBench window to stop the recording of EEG
	WinActivate, Recording Configration ahk_class QWidget ahk_exe EmotivXavierTestBench.exe
	Click, 224, 259 ; click on the 'stop recording' button
	
	/*
	WinActivate, Calculator ahk_class ApplicationFrameWindow		; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow		; maximise window
	Sleep, 2 
	Click, 200, 870 												
	Click, 1400,870 												
	Click, 600, 870 												
	Click, 1400, 990 												
	return
	*/
^c::
	ExitApp ; (comment) exits the script
