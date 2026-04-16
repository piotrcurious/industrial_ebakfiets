# Supervisory Controller: Wiring and Pinout Specification

This document details the precise wiring for the Arduino/ESP32 based Supervisory Controller used in the Industrial E-Bakfiets.

## 1. Microcontroller Pin Mapping (Arduino Nano Reference)

| Pin | Function | Type | Connection |
| --- | --- | --- | --- |
| **A0** | Battery Voltage | Analog In | 60V Voltage Divider (10k/1k) |
| **A1** | Front Current | Analog In | ACS758 Sensor (Front Controller V+) |
| **A2** | Rear Current | Analog In | ACS758 Sensor (Rear Controller V+) |
| **A3** | Front Motor Temp | Analog In | NTC 10k Thermistor (Motor Hub) |
| **A4** | Rear Motor Temp | Analog In | NTC 10k Thermistor (Motor Hub) |
| **A5** | I2C SCL | Digital | 20x4 LCD Display |
| **A6** | I2C SDA | Digital | 20x4 LCD Display |
| **D9** | Alarm Buzzer | PWM Out | 5V Active Buzzer / Piezo |
| **D10** | Throttle Cutoff | Digital Out | Relay/Optocoupler (Intercepts 5V signal) |
| **VIN** | Power In | Power | 12V DC-DC Converter Bus |
| **GND** | Ground | Power | Main System Ground |

## 2. Sensor Calibration Data
- **Voltage Divider**: $V_{out} = V_{in} \times (1000 / (10000 + 1000))$. Multiply raw reading by **11.0**.
- **Current Sensor (ACS758-50B)**: 40mV per Amp. Zero point at 2.5V.
- **Thermistor**: Use 10k pull-up resistor. Beta value: 3950.

## 3. Signal Harness Color Code (Recommended)
| Color | Function | Gauge |
| --- | --- | --- |
| **Red** | 12V DC-DC Power | 20 AWG |
| **Black** | Signal Ground | 20 AWG |
| **Yellow** | Analog Data (V/A/T) | 22 AWG |
| **Green** | I2C SDA | 24 AWG (Twisted Pair) |
| **Blue** | I2C SCL | 24 AWG (Twisted Pair) |
| **White** | Alarm/Control | 22 AWG |

## 4. Interference Mitigation
- **Shielding**: The Analog signal wires (A1-A4) should be routed through a grounded braided copper sleeve to prevent noise from the BLDC phase wires.
- **Capacitance**: Add a 0.1uF capacitor between each Analog Input and GND at the Arduino pins to filter high-frequency switching noise.
