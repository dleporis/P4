Project theme: Robotic assistance for disabled patients, control via brain-computer interface

Code for Steady State Visually Evoked Potential stimulation
This is used together with EEG sensor as a BCI to control a robot.

P4_stimulus_auto_hotkey_slave_arrows.pde handles the GUI, and can have 2 states changed by keyboard input: On or Off. It also opens and terminates P4_octopus.exe
Autohotkey program P4_octopus.akh is responsible for switching between application Windows and automating the start/stop of EEG gathering, and start/stop of stimulus in P4_stimulus_auto_hotkey_slave_arrows.pde

For best performance please compile source codes to .exe, and make sure the P4_octopus.exe is in P4_stimulus_auto_hotkey_slave_arrows\data directory.

The stimulus contains 4 arrows, blinking at 20Hz,	15Hz,	12Hz	and 8,57Hz
Each square coresponds to 1 command for the robot: Up, down, left, right.
The functions behind the arrows can be switched by changing the opeating mode (blinking square top-left).
The subject focuses on one of the square, and the frequency of this square should be captured by an EEG equipment 
such as EMOTIV EPOC+ Mobile Headset

Requirenments:

-PROCESSING IDE, which can be downloaded here:
https://processing.org//download/
AutoHotKey software:
https://www.autohotkey.com/

/data folder contains the .mp3 that plays the beep

