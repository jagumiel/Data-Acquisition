# Data Acquisition - Adquisición de datos
## _Data acquisition and signal generation examples_

[EN] In this repository you can find some projects and examples about data acquisition and signal generation. Different hardware and software devices have been used. Existing projects have been done in MATLAB, LabVIEW, C ++ and VHDL.

[ES] En este repositorio se encuentran algunos proyectos y ejemplos sobre adquisición de datos y generación de señales. Se han utilizado diferentes dispositivos hardware y software. Los proyectos existentes se han hecho en MATLAB, LabVIEW, C++ y VHDL.

-----

## Repository Structure

The repository is organized in the following manner:

    .
    ├── Arduino                     # Contains full projects for Arduino.
    │   ├── DHT11-Reader            # Prints on screen ambient temp and hum. Needs DHT11 Sensor.
    │   └── Watch_Winder            # Code for a watch winder. It turns an ULN2003 stepper motor.
    ├── LabVIEW                     # Contains full LabVIEW projects. Runs on Arduino, but requires LabVIWE Software.
    │   ├── car_simulation          # Simulates car A/C system and auto lights. Needs  LM35 temp sensor and optoresistor.
    │   └── temp_reader             # Reads temp through DHT11 and writes it on an LCD display.
    ├── Matlab                      # Contains full matlab projects.
    │   ├── Graph_Voltimeter        # Represents the acquired voltage measure in a graph.
    │   ├── Lectura_fotoresistencia # Converts photoresistor acquired voltage to Lx.
    │   ├── Sensor_DHT11            # Reads from a DHT11 hum./temp. sensor.
    │   ├── Temp_Reader             # Reads temperature from a LM35 sensor.
    │   └── Transistor_Cmp          # Represents the transistor curve, so you can know if you transistors matches or not.
    ├── VHDL                        # Contains full Quartus II projects in VHDL for Intel Cyclone V Family.
    └── README.md                   # Readme.md file

