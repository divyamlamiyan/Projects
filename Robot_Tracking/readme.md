Objective:
		Tracking the motion of multiple Robots on the ground using a single overhead Camera


Programming Language used 	: Python 2.7 & swi-prolog
Library used 				: numpy, zbar, CV2


FILES:
		1. Detection.py : for detection of multiple QR Codes which returns the current centroid of every QR Codes with its data.
		2. Robot1.pl : to detect and move towards other QR Codes (Robots) based on distance and angle.
		3. Robot2.pl : to detect and move away from Robot1.
		

EXECUTION:
		used python 2.7 or above to run using the command:
		python detection.py

		- A windows of camera will open

		Need to calibrate QR Codes:
		- place all QR Codes in the vision of camera
		- press 'esc' to complete the calibration process.
		- The detected QR codes will be detected in rectangular shape
		- Now for every iteration (depends of density of QR Codes), the centroid of every QR Codes will be saved in a file named 'data.txt'

ABOUT 'detection.py':
        -use tacking() module for detection without exponential averagiing. 
        -use calibration() and tracking_with_exp() modules for detection with exponential averaging. 