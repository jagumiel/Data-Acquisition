# Graphical Voltimeter for Arduino and MATLAB

This project provides a graphical representation of voltage readings from an Arduino connected to MATLAB. The code continuously samples the analog input and plots the voltage against time in real-time.

## Prerequisites

- MATLAB installed on your system.
- Arduino board connected to your computer.
- MATLAB Support Package for Arduino installed.

## Installation and Setup

1. Clone or download the repository to your local machine.
2. Connect your Arduino board to your computer via USB.
3. Open MATLAB.
4. Ensure MATLAB can communicate with your Arduino by typing a = arduino() in the MATLAB command window.
5. Open the MATLAB script Graphical_Voltimeter.m.
6. Run the script.

## Usage

1. Upon running the script, a graphical window will appear.
2. The x-axis represents time in seconds, and the y-axis represents voltage in volts.
3. The graph will continuously update as voltage readings are obtained from the Arduino.

## Notes

- The analog input pin A0 is used in this example. You can modify the code to use a different pin if needed.
- The duration of sampling (tmax) can be adjusted as per requirements.
- Ensure proper connections and correct port selection for the Arduino in MATLAB.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- This project utilizes the MATLAB Support Package for Arduino.
