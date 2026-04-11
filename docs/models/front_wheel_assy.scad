include <master_dims.scad>
include <parts.scad>

// COMPLETE FRONT WHEEL ASSEMBLY
// Origin = Axle Center (0,0,0)
module front_wheel_assy() {
    // 1. Tire (Corrected Orientation)
    car_tire_13in();

    // 2. Split Rim (Two halves)
    car_rim_13in_split();

    // 3. Fasteners (6x M8 Bolts)
    rim_fastener_pattern();

    // 4. Hub Motor (Sandwiches the rim)
    hub_motor_dd();
}

front_wheel_assy();
