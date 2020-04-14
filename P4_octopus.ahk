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

^e:: ; CTRL+e pressed
	; open calculator (EEG pogram later)
	Sleep, 500														; sleep 5000ms (I guess)
	WinActivate, Calculator ahk_class ApplicationFrameWindow		; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow		; maximise window
	Sleep, 2 														; sleep 2ms 
	Click, 200, 870 												; in calculator, click 1
	Click, 1400,870 												; in calculator, click +
	Click, 600, 870 												; in calculator, click 2
	Click, 1400, 990 												; in calculator, click =
	Sleep, 10 														; sleep 10ms 
	
	WinActivate P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window
	WinMaximize P4_stimulus_auto_hotkey_slave ahk_class SunAwtFrame	; change window
	Sleep, 5000 													; sleep 5000ms (I guess)
	Send, e 														; start "P4_stimulus_auto_hotkey_slave" stimulus
	Sleep, 10000 													; sleep 10000ms (stimulus running)
	Send, q 														; stop "P4_stimulus_auto_hotkey_slave" stimulus
	
	WinActivate, Calculator ahk_class ApplicationFrameWindow		; change window
	WinMaximize, Calculator ahk_class ApplicationFrameWindow		; maximise window
	Sleep, 2 														; sleep 2ms 
	Click, 200, 870 												; in calculator, click 1
	Click, 1400,870 												; in calculator, click +
	Click, 600, 870 												; in calculator, click 2
	Click, 1400, 990 												; in calculator, click =
	return
	
^c::
	ExitApp ; (comment) exits the script