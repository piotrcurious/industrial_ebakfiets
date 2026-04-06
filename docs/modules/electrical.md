# Electrical Module

The industrial bakfiets uses a decentralized, dual-battery, dual-motor electrical system for maximum efficiency, redundancy, and reduced wiring losses.

## Decentralized Architecture
Instead of a single central battery and controller, the system is split into two localized power units to keep high-current motor wires as short as possible.

### 1. Front Power Unit (Fork Mounted)
- **Location**: Mounted on the custom front fork, directly behind the head tube.
- **Components**:
  - **Front Battery**: 36V or 48V (10-15Ah).
  - **Front BLDC Controller**: 250W Direct Drive controller.
  - **Front Housing Box**: Oversized waterproof enclosure (250x180x100mm) to accommodate salvaged controllers.
- **Benefit**: Significantly reduces resistance and complexity in the front motor wiring.

### 2. Rear Power Unit (Frame Mounted)
- **Location**: Mounted on the main frame, above the chain line and near the rear hub motor.
- **Components**:
  - **Rear Battery**: 36V or 48V (10-15Ah).
  - **Rear BLDC Controller**: 300W Geared hub motor controller.
  - **Rear Housing Box**: Oversized waterproof enclosure (250x180x100mm).
- **Benefit**: Keeps high-torque rear motor wires short and protected from cargo area.

## Dual-Battery Equalizer System
The two batteries are connected by a single, thick **Equalizer Wire** to balance the load and provide redundancy.

- **Specification**: **8AWG or 10AWG silicone-insulated wire**.
- **Function**: Allows the system to draw power from both batteries simultaneously, reducing voltage sag and allowing the bike to run if one battery fails.
- **Protection**: Each battery must have its own 40-60A fuse before the equalizer junction.

## Housing & Clearance
### BLDC Housing Box (Large Margin Design)
- **Internal Dimensions**: 250mm x 180mm x 100mm.
- **Why**: Specifically designed with a large margin to accommodate various salvaged controllers with different dimensions and cooling fins.
- **Clearance Requirements**:
  - **Chain/Gears**: Minimum 50mm vertical clearance from the chain line to the bottom of the housing.
  - **Brakes/Tires**: Minimum 25mm clearance from any moving part or brake caliper.

## Control System Integration
- **Throttle/Display**: Single throttle and display unit connected via a Y-splitter cable to both controllers.
- **Brake Cutoff**: Industrial-grade e-brake levers connected in parallel to both controllers to stop all motors instantly.
- **Wiring Harness**: IP65 rated signal connectors (Higo/Julet style).

## Tolerances and Safety
- **Voltage Drop**: Minimized by short localized runs (< 1.0% drop).
- **Thermal Margin**: 50mm internal clearance around salvaged controllers for air circulation.
- **Equalizer Connector**: XT90-S (Anti-spark) for safe connection of the two battery systems.
