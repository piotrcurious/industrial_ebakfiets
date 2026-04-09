include <master_dims.scad>
use <parts.scad>

// COMPLETE FRONT WHEEL ASSEMBLY
// Origin = Axle Center (0,0,0)
module front_wheel_assy() {
    // 1. Tire
    car_tire_13in();

    // 2. Rim (Mated to Tire)
    car_rim_13in();

    // 3. Hub Motor (Mated to Rim and provides the Axle)
    hub_motor_dd();
}

front_wheel_assy();
