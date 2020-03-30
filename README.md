Code for Steady State Visually Evoked Potential stimulation
This is used together with EEG sensor as a BCI to control a robot

Timeline:
- 4s pause (this can be modified)
- beep
- 1s pause
-5s when the stimulus is running.

The stimulus contains 4 squares, blinking at 20Hz,	15Hz,	12Hz	and 8,57Hz
Each square coresponds to 1 command for the robot.
The subject focuses on one of the square, and the frequency of this square should be captured by an EEG equipment 
such as EMOTIV EPOC+ Mobile Headset

The sourse code can be run in PROCESSING IDE, which can be downloaded here:
https://processing.org//download/
The IDE is available for Windows, Mac and also Linux.

/data folder contains the .mp3 that plays the beep

