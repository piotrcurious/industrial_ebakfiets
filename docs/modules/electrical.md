# Electrical Module

The industrial bakfiets uses a dual-motor electrical system for redundant power, high torque, and increased efficiency.

## Dual Motor Setup
### 1. Front: 250W Direct Drive Hub Motor
- **Function**: Cruise efficiency and regenerative braking.
- **Benefit**: Smooth power delivery and low maintenance (no internal gears).

### 2. Rear: 300W Geared Hub Motor
- **Function**: Starting torque and hill climbing.
- **Benefit**: High internal reduction (planetary gears) provides massive torque for heavy loads at low speeds.

## Power Source
### 1. Battery Pack
- **Voltage**: 48V (Recommended for dual-motor current demands).
- **Chemistry**: Lithium Iron Phosphate (LiFePO4) or Lithium-Ion (NMC).
- **Capacity**: At least 15-20Ah (720-960Wh).
- **Enclosure Dimensions**:
  - **Size**: 320mm x 160mm x 90mm.
  - **Internal Mount Space**: 330mm x 170mm x 100mm.

### 2. Battery Management System (BMS)
- **Specification**: **40-60A continuous discharge capacity** to handle both motor controllers simultaneously.
- **Protection**: Overcurrent, overvoltage, undervoltage, and thermal protection.

## Control System
### 1. Motor Controllers
- **Dual Controllers**: Two separate 36V/48V 15-22A BLDC controllers (Sinewave for quiet operation).
- **Wiring and Connectors**:
  - **Main Battery Bus**: 10AWG or 12AWG silicone wire.
  - **Connectors**: XT90 (main battery), XT60 (motor phase and controllers), and Waterproof IP65 signal connectors (JST-SM or Higo).

### 2. Throttle and Display
- **Specification**: LCD SW900 or color TFT display for speed, mileage, and battery status.
- **Throttle**: Thumb or half-twist throttle (standard 22mm handlebar mount).

### 3. Wiring and Integration
- **Harness**: IP65 rated connectors and waterproof industrial enclosure (minimum 200mm x 150mm x 75mm).
- **Enclosure**: Waterproof industrial enclosure for controllers and BMS, mounted under the cargo bed for a low center of gravity.

## Tolerances and Safety
- **Voltage Drop**: Maximum allowable voltage drop in wiring is 2.5% under full load.
- **Thermal Margin**: Controllers and BMS must be mounted in an enclosure with at least 50mm of clearance for heat dissipation.
- **Fuse/Breaker**: Integrated 60A DC circuit breaker for the main battery supply.
