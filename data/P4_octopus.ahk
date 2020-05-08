#SingleInstance, force

/*
Details of Processing IDE window
P4_stimulus_frame_processing | Processing 3.5.3
ahk_class SunAwtFrame
ahk_exe javaw.exe
*/

/*
Details of running stimulus sketch window
P4_stimulus_frame_processing
ahk_class SunAwtFrame
ahk_exe java.exe
*/
/*
Spotify Premium
ahk_class Chrome_WidgetWin_0
ahk_exe Spotify.exe
*/
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
	Sleep, 500														; sleep 5000ms (I guess)
	/*
	; test on Win10 calculator in case EEG recorder is not available
	WinActivate, Calculator ahk_class ApplicationFrameWindow		; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow		; maximise window
	Sleep, 2 														; sleep 2ms 
	Click, 200, 870 												; in calculator, click 1
	Click, 1400,870 												; in calculator, click +
	Click, 600, 870 												; in calculator, click 2
	Click, 1400, 990 												; in calculator, click =
	Sleep, 10 														; sleep 10ms 
	*/
	
	Click, 224, 259 ; click on the 'start recording' button
	;Sleep, 500 ; to see that the recording has started
	WinActivate P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window to stimulus
	WinMaximize P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window
	
	Sleep, 5000 ; 5 seconds pre-stimulus period													; sleep 5000ms (I guess)
	
	Send, e ; start stimulus														; start "P4_stimulus_auto_hotkey_slave" stimulus
	Sleep, 30000 ; 30 seconds stimulus period													; sleep 10000ms (stimulus running)
	Send, q ; stop stimulus
	
	Sleep, 5000 ; 5 seconds after-stimulus period													; stop "P4_stimulus_auto_hotkey_slave" stimulus
	
	; Open EEG EmotivXavierTestBench window to stop the recording of EEG
	WinActivate, Recording Configration ahk_class QWidget ahk_exe EmotivXavierTestBench.exe
	Click, 224, 259 ; click on the 'stop recording' button
	
	/*
	WinActivate, Calculator ahk_class ApplicationFrameWindow		; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow		; maximise window
	Sleep, 2 														; sleep 2ms 
	Click, 200, 870 												; in calculator, click 1
	Click, 1400,870 												; in calculator, click +
	Click, 600, 870 												; in calculator, click 2
	Click, 1400, 990 												; in calculator, click =
	return
	*/
^c::
	ExitApp ; (comment) exits the script
