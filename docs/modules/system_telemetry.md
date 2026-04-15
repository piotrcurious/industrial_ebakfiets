# System Telemetry and Supervisory Control

To ensure the reliability of the industrial dual-motor system, a "Supervisory Controller" is recommended. While the hub motors operate on their own internal/external BLDC controllers, the Supervisor acts as a cockpit dashboard and safety watchdog.

## 1. Hardware Overview
- **Microcontroller**: Arduino Nano, ESP32, or Teensy 4.0.
- **Display**: High-contrast 20x4 Character LCD or Sunlight-readable OLED.
- **Sensors**:
  - **Voltage Divider**: To monitor the 48V-60V main traction battery.
  - **Hall-Effect Current Sensors**: (e.g., ACS712 or ACS758) on the positive lead of each motor controller.
  - **Thermistor (NTC 10k)**: Embedded in the motor windings or attached to the motor housing to monitor heat soak during heavy climbing.

## 2. Telemetry Metrics
The system should track and display the following in real-time:
- **Voltage (V)**: Critical for determining State of Charge (SOC) and identifying voltage sag under load.
- **Amperage (A)**: Individual current for Front and Rear motors. This helps detect if one motor is working significantly harder (e.g., due to a mechanical issue or mismatched speed limits).
- **Power (W)**: Total instantaneous power consumption ($V \times (A_{front} + A_{rear})$).
- **Temperature (C)**: Thermal monitoring for both motors to prevent stator demagnetization.

## 3. Safety Logic
### Thermal Throttling
If either motor exceeds **85°C**, the Supervisor should trigger an audible alarm. Advanced implementations can use a relay or signal intercept to pull the throttle signal low, forcing the operator to slow down until the system cools.

### Low Voltage Cutoff (LVC)
While BLDC controllers have built-in LVC, the Supervisor provides a secondary visual warning when the battery reaches **42.0V** (for a 48V pack), allowing the operator to return to base before the BMS shuts down the system.

## 4. Wiring Diagram Integration
The Supervisor is powered by the **12V DC-DC converter** bus. Signal wires for the current sensors and thermistors should be shielded to prevent interference from the high-current phase wires of the motors.

- **[Reference Implementation (Arduino Code)](../software/system_monitor.ino)**
