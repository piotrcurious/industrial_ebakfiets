# Industrial E-Bakfiets

Welcome to the **industrial_ebakfiets** repository. This project aims to design and build heavy-duty cargo e-bikes using standard, widely available industrial and automotive parts.

## Project Concept

Most bicycles use specialized, often proprietary parts to minimize weight. The **Industrial E-Bakfiets** takes a different approach:
- **Prioritize Durability and Serviceability**: Use heavy-duty parts that are easy to find and replace.
- **Electric-First Design**: Leverage powerful motors to offset the weight of a robust, industrial-grade frame.
- **Automotive Components**: Incorporate standard car tires and split rims for maximum load capacity and easy maintenance.

## Technical Documentation

Detailed descriptions of the core components and systems:

### Core Hardware Modules
- **[Front Wheel Module](docs/modules/front_wheel.md)**: 13\" car tire, split rim, and direct drive hub motor.
- **[Frame Module](docs/modules/frame.md)**: Steel rectangular tube construction and screw-driven stabilizers.
- **[Drivetrain Module](docs/modules/drivetrain.md)**: 16\" rear wheel (moped rim) and pedal drive integration.
- **[Brakes & Steering Module](docs/modules/brakes_steering.md)**: 7202-bearing steering and high-performance braking.
- **[Mechanical Geometry](docs/modules/mechanical_geometry.md)**: Frame angles, rake, trail, and fork design.
- **[Cargo Box Module](docs/modules/cargo_box.md)**: 12mm Marine Plywood box with steel angle reinforcement.
- **[Subassemblies Detail](docs/modules/subassemblies_detail.md)**: Technical specs for custom-fabricated components.

### Systems, Software & Maintenance
- **[Electrical Module](docs/modules/electrical.md)**: Decentralized dual-motor/dual-battery architecture.
- **[Control & Software Module](docs/modules/control_software.md)**: Signal synchronization, PAS, and firmware configuration.
- **[Ergonomics & Accessories](docs/modules/ergonomics_accessories.md)**: Operator interface, lighting, and safety systems.
- **[Weather Protection](docs/modules/weather_protection.md)**: Modular canopy and windshield system.
- **[Manufacturing Jigs](docs/modules/manufacturing_jigs.md)**: Guides for frame alignment and welding.
- **[Maintenance & Safety](docs/modules/maintenance_safety.md)**: PM schedule, safety protocols, and build checklists.

## Technical Drawings (SVG)

The design is supported by dimensionally accurate SVG drawings (1px = 1mm scale):

- **[Full Assembly Drawing](docs/drawings/full_assembly.svg)**: Composed side view of the complete vehicle.
- **[Frame Side View](docs/drawings/frame_side.svg)**: Main spars, head tube, and cargo mounts.
- **[Front Fork Detail](docs/drawings/front_fork.svg)**: Crown, dropouts, and steering arms.
- **[Steering Head Section](docs/drawings/steering_head_section.svg)**: Cross-section of 7202 bearing integration.
- **[Front Wheel Assembly](docs/drawings/front_wheel_assembly.svg)**: Motor, flange, rim, and tire cross-section.
- **[Bipod Kickstand Detail](docs/drawings/bipod_kickstand.svg)**: Wide-base stand with pivot and springs.
- **[Stabilizer Unit Detail](docs/drawings/stabilizer_unit.svg)**: Screw-driven telescopic leg mechanism.
- **[Cargo Box Structure](docs/drawings/cargo_box_structure.svg)**: Perspective view of box and E-track rails.

## Bill of Materials (BOM) Alternatives

Choose the configuration that best fits your budget and requirements:

1. **[Industrial Standard](docs/bom/industrial_standard.md)**: Balanced cost and reliability (~$1,940).
2. **[Budget Salvage](docs/bom/budget_salvage.md)**: Optimized for lowest cost using salvaged parts (~$625).
3. **[Heavy Duty](docs/bom/heavy_duty.md)**: Over-engineered for maximum performance (~$3,810).

---

*For historical reference, the original project description can be found in [README_ORIGINAL.md](README_ORIGINAL.md).*
