# Failure Mode and Effects Analysis (FMEA)

This document identifies potential failure points in the Industrial E-Bakfiets design and specifies the engineering mitigations implemented to reduce risk.

| System | Potential Failure Mode | Effect | Severity | Mitigation Strategy |
| --- | --- | --- | --- | --- |
| **Steering** | Tie-rod end shear or detachment | Loss of steering control | **High** | Use of M10 Chrome-moly rod ends; Dual roll-pins on shaft collars; Redundant locking nuts. |
| **Frame** | Gooseneck weld fatigue | Structural collapse under load | **High** | Oversized 40x40mm tubing with internal gussets; Tapered "Gooseneck" geometry to distribute stress. |
| **Front Wheel** | M8 Rim Bolt loosening | Rim separation/Tube blowout | **High** | Grade 10.9 fasteners; Star-pattern torque spec (30Nm); Required use of Nyloc nuts and Blue Loctite. |
| **Electrical** | Battery thermal runaway | Fire hazard | **High** | LiFePO4 chemistry (inherently safer); Isolated waterproof enclosures; MIDI fuse protection (40A). |
| **Motor** | Axle rotation (Torque spin) | Phase wire shear; Motor loss | **Medium** | 10mm thick Grade 43 steel torque arm with dual-point anchoring to fork leg. |
| **Brakes** | Hydraulic line rupture | Partial loss of braking | **Medium** | Independent front/rear systems (203mm/180mm); Steel-braided hoses recommended for industrial use. |
| **Drivetrain** | Chain derailment | Loss of pedal assist | **Low** | Use of HDPE chain tubes to maintain alignment; High-engagement chainring profile. |

## Critical Inspection Points
For fleet operators, the following three items are considered **"Mission Critical"** and must be inspected daily:
1. **Steering Shaft Play**: Any vertical or radial play indicates bearing or collar failure.
2. **Torque Arm Bolt**: Ensure the M8 anchor bolt is tight and the arm shows no deformation.
3. **Rim Bolt Visual**: Check for any gap between the two rim halves or the adapter flanges.
