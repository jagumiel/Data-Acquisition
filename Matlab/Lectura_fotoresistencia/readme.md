# Light Sensor Data Logger

This project utilizes an Arduino board connected to MATLAB to log and graph light sensor readings from a photoresistor. The code converts voltage readings to luminosity measurements and displays them graphically in real-time.

## Prerequisites

- MATLAB installed on your system.
- Arduino board connected to your computer.
- MATLAB Support Package for Arduino installed.

## Installation and Setup

1. Clone or download the repository to your local machine.
2. Connect your Arduino board to your computer via USB.
3. Open MATLAB.
4. Ensure MATLAB can communicate with your Arduino by typing a = arduino('COM4','Uno') in the MATLAB command window. Replace 'COM4' with the appropriate port if needed.
5. Open the MATLAB script Light_Sensor_Data_Logger.m.
6. Run the script.

## Usage

1. Upon running the script, a graphical window will appear.
2. The x-axis represents time in seconds, and the y-axis represents luminosity in Lux.
3. The graph will continuously update as light sensor readings are obtained from the Arduino.

## Notes

- The analog input pin A0 is used to read the photoresistor in this example. You can modify the code to use a different pin if needed.
- Adjust the calibration parameters Ro, Rl, and Rc according to your sensor specifications.
- The duration of sampling (tmax) can be adjusted as per requirements.
- Ensure proper connections and correct port selection for the Arduino in MATLAB.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- This project utilizes the MATLAB Support Package for Arduino.
