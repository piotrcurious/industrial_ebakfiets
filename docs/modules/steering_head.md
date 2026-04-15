# Industrial E-Bakfiets: Steering Head Module

The steering head is the primary pivot point of the bicycle, connecting the fork to the main frame. It is designed for high-load industrial use using a "no-machining" approach.

## 1. Physical Interface
The assembly is centered on the steering axis, tilted at **68 degrees** from the horizontal.

- **Lower Interface**: Mates with the fork crown via a 15mm precision shaft.
- **Internal Interface**: Houses two **7202 angular contact bearings** (15x35x11mm).
- **Outer Interface**: 1-1/4" Schedule 40 steel pipe (OD 42.16mm, ID 35.05mm).
- **Structural Interface**: A 20mm thick steel gusset plate welded to the HT, providing the mating surface for the main frame connection member.

## 2. Bearing Arrangement
Angular contact bearings are used to handle both the radial loads from steering and the significant axial (thrust) loads from the cargo weight.
- **Top Bearing**: Oriented to take upward thrust.
- **Bottom Bearing**: Oriented to take downward thrust.
- **Preload**: Achieved using M15 shaft collars and shim washers.

## 3. Surface-to-Surface Mating logic
In the digital model, the steering head is located by moving from the **Fork Crown** up the **Steering Shaft**. The Frame is then located by moving from the **HT Gusset Face** backwards. This ensures that any change in fork length or HT diameter automatically propagates through the rest of the chassis geometry without manual recalculation.

## 4. Safety Specs
- **Travel Limit**: +/- 45 degrees via 10mm steel stop pins.
- **Fasteners**: M8 Grade 12.9 for the gusset-to-frame connection (if bolted) or full-penetration welds.
