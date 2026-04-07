# Control and Software Module

The industrial bakfiets uses a decentralized control system to manage its dual hub motors, ensuring synchronized performance and operator safety.

## Control Architecture
The system relies on parallel signal distribution to synchronize two independent BLDC controllers.

### 1. Signal Synchronization (Y-Splitter Method)
- **Throttle Signal**: A shielded 3-core Y-splitter cable sends the analog voltage signal (0.8V - 4.2V) from the handlebar throttle to both the Front and Rear BLDC controllers simultaneously.
- **Brake Cutoff**: NC (Normally Closed) or NO (Normally Open) e-brake sensors are connected in parallel to the high/low brake signal inputs of both controllers.
- **Display Connection**: The LCD display communicates via UART with the Master (Rear) controller for data logging, while the Slave (Front) controller operates on throttle signal only.

### 2. PAS (Pedal Assist) Integration
- **Primary Drive**: The 12-magnet PAS sensor is connected exclusively to the **Rear (Geared) Controller**.
- **Logic**: Pedal assist provides the initial torque for heavy loads. The front motor is used primarily for cruise and high-speed efficiency via manual throttle override.

## Firmware and Configuration
To ensure the two motors work in harmony rather than competing, the following firmware parameters are recommended:

### 1. Speed and Torque Matching
- **Speed Limit**: Matched to **25km/h (nominal)** on both controllers to prevent over-running.
- **Current Limit**:
  - Front (Direct Drive): **15A - 20A** (Optimized for cruise efficiency).
  - Rear (Geared): **22A - 30A** (Optimized for starting torque).

### 2. Acceleration Curves
- **Soft Start**: High setting (Level 5-10) to prevent wheel spin on the front 13\" car tire and reduce stress on the rear gears.
- **Regen Braking**: Enabled on the **Front Controller** only, set to 50% strength to provide stable slowing without skidding.

## Wiring Schematics (Simplified)
- **Main Bus**: 48V from dual batteries via 8AWG Equalizer.
- **Signal Bus**: 5V Hall effect, 5V PAS, 5V Throttle, and UART/CAN for display.
- **Connectors**: Use IP65 Julet/Higo connectors for all signal wiring to withstand industrial cleaning and weather.
